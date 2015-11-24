//
//  SelectAddressViewController.m
//  GuduMorning
//
//  Created by Macbook on 15/9/5.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "SelectAddressViewController.h"

// View
#import "AddressListCell.h"
#import <ActionSheetStringPicker.h>

// Theme
#import "MegaTheme.h"

// Category
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "RLMResults+ToArray.h"
#import "UIView+CreateBorder.h"
#import "Pingpp.h"
#define kReuseCell @"address_cell"
#import "UIScrollView+EmptyDataSet.h"

// ViewController
#import "AddAddressViewController.h"
#import "SelectCouponViewController.h"
#import "PayResultViewController.h"

// Class
#import "PayResultHandlerManager.h"
typedef enum : NSUInteger {
    None,    //未有任何操作
    Waiting,//支付请求等待响应
    PayDone,//支付成功
    PayFailed,//支付失败
} PayStatus;

@interface SelectAddressViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, SelectCouponDelegate, PayResultHandlerDelegate>{

    __weak IBOutlet UIView *selectDeliveryTimeAndPayMethod;
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet UITableView *addressTableView;
    
    //label
    __weak IBOutlet UILabel *deliveryTimelabel;
    
    __weak IBOutlet UILabel *payMethodLabel;
    
    //按钮
    __weak IBOutlet UIButton *deliveryTimeButton;
    __weak IBOutlet UIButton *payMethodButton;
    __weak IBOutlet UIButton *submitButton;
    
    // 优惠券
    __weak IBOutlet UIView *couponView;
    __weak IBOutlet UIButton *selectCouponButton;
    __weak IBOutlet UILabel *currentCouponLabelView;
    
}

/**
 *  支付状态
 */
@property (nonatomic, assign) PayStatus status;

/**
 *  可选的送餐时间
 */
@property (nonatomic, strong) NSArray *availableDeliveryTime;
/**
 *  可选的支付方式
 */
@property (nonatomic, strong) NSArray *availablePayMethod;

/**
 *  用户的地址,array
 */
@property (nonatomic, strong) NSArray *addressList;

/**
 *  送餐时间
 */
@property (nonatomic, copy) NSNumber *deliveryTimeIndex;

/**
 *  支付方式
 */
@property (nonatomic, copy) NSNumber *payMethodIndex;

@property (nonatomic, strong) CouponModel *coupon;

/**
 *  订单提交后才有值
 */
@property (nonatomic, strong) OrderModel *order;

@end

@implementation SelectAddressViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initUI];
    [self setUpTrigger];
}

- (void)initUI{
    self.title = @"地址&支付";
    // 等待basic config加载
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [couponView drawBottomLine:TopBorder lineWidth:1/[UIScreen mainScreen].scale fillColor:kLineColor];
    [selectDeliveryTimeAndPayMethod  drawBottomLine:TopBorder lineWidth:1/[UIScreen mainScreen].scale fillColor:kLineColor];
    [bottomView drawBottomLine:TopBorder lineWidth:1/[UIScreen mainScreen].scale fillColor:kLineColor];
    addressTableView.tableFooterView = [UIView new];
}

- (void)setUpTrigger{
    [self setStatus:None];
    
    // 订阅状态变化
    [RACObserve(self, status) subscribeNext:^(NSNumber *status) {
        NSInteger statusCode = [status integerValue];

        if (statusCode == None) {
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        else if (statusCode == Waiting){
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        else if (statusCode == PayDone){
            /**
             *  隐藏菊花
             */
            [MBProgressHUD hideHUDForView:self.view animated:YES];


            //进入订单界面
            //TODO...
//            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (statusCode == PayFailed){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kPaymentDone object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        BOOL payDone = [[[notification userInfo] objectForKey:@"result"] boolValue];
        if (payDone) {
            self.status = PayDone;
        }
        else {
            self.status = PayFailed;
        }
    }];
    
    // 设置提交按钮enable属性追踪
    RACSignal *payMethodChoosed = RACObserve(self, payMethodIndex);
    RACSignal *deliveryTimeChoosed = RACObserve(self, deliveryTimeIndex);
    RAC(submitButton, enabled) = [RACSignal combineLatest:@[payMethodChoosed, deliveryTimeChoosed, RACObserve(self, addressList)] reduce:^(NSString *payMethod, NSNumber *deliveryTimeIndex, NSArray *addressList){
        return @(payMethod.integerValue >= 0 && deliveryTimeIndex.integerValue >= 0 && addressList.count > 0);
    }];
    
    [[submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        AddressModel *selectAddress = [self.addressList objectAtIndex:[[addressTableView indexPathForSelectedRow] row]];
        
                    [self.cartItems convertToArrayWithCompletionBlock:^(NSMutableArray *results) {
                        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:kOrderPlaceOrderUrl params:nil];
                        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                                     @"delivery_time": [self.availableDeliveryTime objectAtIndex:self.deliveryTimeIndex.integerValue],
                                                                                                     @"pay_method": [(PayMethodModel *)[self.availablePayMethod objectAtIndex:self.payMethodIndex.integerValue] code],
                                                                                                     @"receiver_address" :selectAddress.address,
                                                                                                     @"receiver_phone" :selectAddress.phone,
                                                                                                     @"receiver_name" :selectAddress.name,
                                                                                                     @"cart_items" : [CartItem keyValuesArrayWithObjectArray:results],
                                                                                                     @"campus" : kNullToString([Tool getUserDefaultByKey: kCampusUsedKey])
                                                                                                     }];
                        
                        if (self.coupon) {
                            [param setObject:self.coupon.id forKey:@"coupon_id"];
                        }
                        RACSignal *signal = [Tool POST:url parameters:param progressInView:self.view showNetworkError:YES];
                        [signal subscribeNext:^(id responseObject) {
                            TsaoLog(@"charge 回调:%@", responseObject);
                            if (kGetResponseCode(responseObject) == kSuccessCode){
                                // 创建成功
                                /**
                                 *  删除购物车商品
                                 */
                                RLMRealm *realm = [RLMRealm defaultRealm];
                                [realm beginWriteTransaction];
                                [realm deleteObjects:[CartItem allObjects]];
                                [realm commitWriteTransaction];

                                id charge = [kGetResponseData(responseObject) objectForKey:@"charge"];
                                
                                self.order = [OrderModel objectWithKeyValues:[kGetResponseData(responseObject) objectForKey:@"order"]];
                                
                                [[PayResultHandlerManager sharedManager] setDelegate:self];
                                
                                [Pingpp createPayment:charge
                                       viewController:nil
                                         appURLScheme:kUrlScheme
                                       withCompletion:^(NSString *result, PingppError *error) {
                                          
                                       }];
                            }
                            else if(kGetResponseMessage(responseObject)){
                                [MBProgressHUD bwm_showTitle:[NSString stringWithFormat:@"%@", kGetResponseMessage(responseObject)] toView:kKeyWindow hideAfter:2.0 msgType:BWMMBProgressHUDMsgTypeSuccessful];
                            }
                        }];
                        
                    }];
    }];
    
    // 追踪单例用户的user属性
    [RACObserve([UserSession sharedUserSession], user) subscribeNext:^(UserModel *user) {
        self.addressList = user.addresses;
    }];
    
    // 一旦数据源变化,刷新table
    [[RACObserve(self, addressList) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        [addressTableView reloadData];
        if (self.addressList.count > 0) {
            [addressTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    }];
    
    // 选择送餐时间
    RAC(deliveryTimeButton, enabled) = [RACObserve(self, availableDeliveryTime) map:^(id x) {
        return @(x != nil);
    }];
    [[[deliveryTimeButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:deliveryTimeButton.rac_willDeallocSignal]subscribeNext:^(id x) {
        ActionSheetStringPicker *specPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"明天上午" rows:self.availableDeliveryTime initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            self.deliveryTimeIndex = @(selectedIndex);
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            ;
        } origin:deliveryTimeButton];
        [specPicker setCancelButton:[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil]];
        [specPicker setDoneButton:[[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:nil action:nil]];

        [specPicker showActionSheetPicker];
    }];
    
    // 选择支付方式
    RAC(payMethodButton, enabled) = [RACObserve(self, availablePayMethod) map:^(id x) {
        return @(x != nil);
    }];
    [[[payMethodButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:deliveryTimeButton.rac_willDeallocSignal]subscribeNext:^(id x) {
        
        NSMutableArray *stringValues = [NSMutableArray new];
        
        [self.availablePayMethod enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PayMethodModel *payModel = (PayMethodModel *)obj;
            if (payModel.name) {
                [stringValues addObject:payModel.name];
            }
        }];
        
        ActionSheetStringPicker *specPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"选择支付方式" rows:stringValues initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            self.payMethodIndex = @(selectedIndex);
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            ;
        } origin:deliveryTimeButton];
        [specPicker setCancelButton:[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil]];
        [specPicker setDoneButton:[[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:nil action:nil]];
        
        [specPicker showActionSheetPicker];
    }];
    
    //绑定送餐时间和支付方式的显示
    [RACObserve(self, payMethodIndex) subscribeNext:^(NSNumber *payMethodIndex) {
        if (payMethodIndex.integerValue >= 0) {
            payMethodLabel.text = [[self.availablePayMethod objectAtIndex:payMethodIndex.integerValue] name];
        }
    }];
    [RACObserve(self, deliveryTimeIndex) subscribeNext:^(NSNumber *deliveryTimeIndex) {
        if (deliveryTimeIndex.integerValue >= 0) {
            deliveryTimelabel.text = [self.availableDeliveryTime objectAtIndex:deliveryTimeIndex.integerValue];
        }
    }];
    
    // 查看是否已经加载了BasicConfig，包含了可用的送餐时间和付款方式
    RACSignal *dtSignal = RACObserve([BasicConfigManager sharedDeliveryTimeManager], deliveryTimeSet);
    RACSignal *pmSignal = RACObserve([BasicConfigManager sharedDeliveryTimeManager], payMethodSet);
    [RACObserve(self, availableDeliveryTime) subscribeNext:^(id x) {
        if (self.availableDeliveryTime.count > 0) {
            self.deliveryTimeIndex = 0;
        }
    }];
    [RACObserve(self, availablePayMethod) subscribeNext:^(id x) {
        if (self.availablePayMethod.count > 0) {
            self.payMethodIndex = 0;
        }
    }];
    
    [[RACSignal combineLatest:@[dtSignal, pmSignal] reduce:^(NSArray *dtArray, NSArray *pmArray){
        self.availableDeliveryTime = dtArray;
        self.availablePayMethod = pmArray;
        
        return @(dtArray != nil && pmArray != nil) ;
    }] subscribeNext:^(NSNumber *dataReady) {
        if (dataReady.boolValue) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    // 优惠券监听
    [[selectCouponButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        SelectCouponViewController *controller = [kCartStoryBoard instantiateViewControllerWithIdentifier:kSelectCouponCollectionViewController];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    // 设置tableview空view
    addressTableView.emptyDataSetSource = self;
    addressTableView.emptyDataSetDelegate = self;
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:kReuseCell configuration:^(AddressListCell *cell) {
        cell.address = [self.addressList objectAtIndex:indexPath.row];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseCell];
    cell.fd_enforceFrameLayout = NO;
    cell.address = [self.addressList objectAtIndex:indexPath.row];
    return cell;
}



#pragma mark - DZNEmptyDataSource -

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:[MegaTheme fontName] size:11.0]};
    
    return [[NSAttributedString alloc] initWithString:@"添加" attributes:attributes];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有地址";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

/**
 *  添加收货地址
 *
 *  @param scrollView scrollview
 */
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView{
    AddAddressViewController *controller = [kUserStoryBoard instantiateViewControllerWithIdentifier:kAddAddressViewControllerStoryboardId];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)selectCoupon: (CouponModel *)coupon{
    // 选择了优惠券
    if (coupon) {
        currentCouponLabelView.text = [NSString stringWithFormat:@"优惠:%@元", coupon.discount];
        self.coupon = coupon;
    }
    else{
        currentCouponLabelView.text = [NSString stringWithFormat:@"不使用"];

        self.coupon = nil;
    }
}

#pragma mark - PayResultHandlerDelegate -

- (void)handle:(NSString *)result error:(PingppError *)error{
    if (self.order) {
        PayResultViewController *controller = [kCartStoryBoard instantiateViewControllerWithIdentifier:kPayResultViewControllerStoryBoardId];
        
        controller.order = self.order;
        controller.payDone = [result isEqualToString:@"success"];
        
        [self.navigationController pushViewController:controller animated:YES];
    
        if (controller.payDone) {
            [MBProgressHUD bwm_showTitle:@"支付成功" toView:kKeyWindow hideAfter:2.0 msgType:BWMMBProgressHUDMsgTypeSuccessful];
        }

    }
}

@end
