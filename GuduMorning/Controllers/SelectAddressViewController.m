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
// Category
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "RLMResults+ToArray.h"
#import "UIView+CreateBorder.h"
#import "Pingpp.h"
#define kReuseCell @"address_cell"

typedef enum : NSUInteger {
    None,    //未有任何操作
    Waiting,//支付请求等待响应
    PayDone,//支付成功
    PayFailed,//支付失败
} PayStatus;

@interface SelectAddressViewController () <UITableViewDataSource, UITableViewDelegate>{

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
            [self.navigationController popViewControllerAnimated:YES];
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
        return @(payMethod != nil && deliveryTimeIndex != nil && addressList.count > 0);
    }];
    
    [[submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        AddressModel *selectAddress = [self.addressList objectAtIndex:[[addressTableView indexPathForSelectedRow] row]];
        
                    [self.cartItems convertToArrayWithCompletionBlock:^(NSMutableArray *results) {
                        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:kOrderPlaceOrderUrl params:nil];
                        NSDictionary *param = @{
                                                @"delivery_time": [self.availableDeliveryTime objectAtIndex:self.deliveryTimeIndex.integerValue],
                                                @"pay_method": [(PayMethodModel *)[self.availablePayMethod objectAtIndex:self.payMethodIndex.integerValue] code],
                                                @"receiver_address" :selectAddress.address,
                                                @"receiver_phone" :selectAddress.phone,
                                                @"receiver_name" :selectAddress.name,
                                                @"cart_items" : [CartItem keyValuesArrayWithObjectArray:results],
                                                @"campus" : kNullToString([Tool getUserDefaultByKey: kCampusUsedKey])
                                                };
                        RACSignal *signal = [Tool POST:url parameters:param progressInView:self.view showNetworkError:YES];
                        [signal subscribeNext:^(id responseObject) {
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
                                [Pingpp createPayment:charge
                                       viewController:self
                                         appURLScheme:kUrlScheme
                                       withCompletion:^(NSString *result, PingppError *error) {
                                           if ([result isEqualToString:@"success"]) {
                                               TsaoLog(@"支付成功!!");
                                               // 支付成功
                                           } else {
                                               // 支付失败或取消
                                               NSLog(@"!!Error: code=%lu msg=%@", error.code, [error getMsg]);
                                           }
                                       }];
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
        if (payMethodIndex) {
            payMethodLabel.text = [[self.availablePayMethod objectAtIndex:payMethodIndex.integerValue] name];
        }
    }];
    [RACObserve(self, deliveryTimeIndex) subscribeNext:^(NSNumber *deliveryTimeIndex) {
        if (deliveryTimeIndex) {
            deliveryTimelabel.text = [self.availableDeliveryTime objectAtIndex:deliveryTimeIndex.integerValue];
        }
    }];
    
    // 查看是否已经加载了BasicConfig，包含了可用的送餐时间和付款方式
    RACSignal *dtSignal = RACObserve([BasicConfigManager sharedDeliveryTimeManager], deliveryTimeSet);
    RACSignal *pmSignal = RACObserve([BasicConfigManager sharedDeliveryTimeManager], payMethodSet);
    [[RACSignal combineLatest:@[dtSignal, pmSignal] reduce:^(NSArray *dtArray, NSArray *pmArray){
        self.availableDeliveryTime = dtArray;
        self.availablePayMethod = pmArray;
        
        return @(dtArray != nil && pmArray != nil) ;
    }] subscribeNext:^(NSNumber *dataReady) {
        if (dataReady.boolValue) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
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


@end
