//
//  CartViewController.m
//  Mega
//
//  Created by Sergey on 1/30/15.
//  Copyright (c) 2015 Sergey. All rights reserved.
//

#import "CartViewController.h"
#import "MegaTheme.h"
#import "CartCell.h"

#import "CartItemCache.h"

// Category
#import "RLMResults+ToArray.h"

// library
#import <Realm/Realm.h>

//Realm Model

@interface CartViewController ()

/**
 *  监听token
 */
@property (nonatomic, strong) RLMNotificationToken* token;

/**
 *  购物车内容
 */
@property (nonatomic, strong) RLMResults *cartItems;

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cartItems = [CartItem allObjects];
    [self setupTrigger];
    [self initUI];
    //[self fetchData];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.tabBarItem.title = @"购物车";
        
        self.tabBarItem.image = [[UIImage imageNamed:@"cart_tab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[[UIImage imageNamed:@"cart_tab_select"] imageTintedWithColor:kGreenColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (void)setupTrigger{
    
    // 监听cartItems并刷新table
    [RACObserve(self, cartItems) subscribeNext:^(RLMResults *results) {
        [cartItemTableView reloadData];
    }];
    
    // 监听购物车变化
    RLMRealm *realm = [RLMRealm defaultRealm];
    self.token = [realm addNotificationBlock:^(NSString *note, RLMRealm * realm) {
        self.cartItems = [CartItem allObjects];
    }];
    
    // 监听cartItems变化,更新总计价格
    [RACObserve(self, cartItems) subscribeNext:^(RLMResults *result) {
        __block NSDecimalNumber *total = [NSDecimalNumber decimalNumberWithString:@"0.0"];
        for (int i =0; i < self.cartItems.count; i++) {
            CartItem *item = [self.cartItems objectAtIndex:i];
            NSDecimalNumber *perPrice = [NSDecimalNumber decimalNumberWithString:item.price];
            NSDecimalNumber *qty = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", (long)item.quantity]];
            NSDecimalNumber *all = [perPrice decimalNumberByMultiplyingBy:qty];
            total = [total decimalNumberByAdding:all];
        }
        totalLabel.text = [NSString stringWithFormat:@"¥%@", [total stringValue]];
    }];
    
    RAC(orderButton, enabled) = [[RACObserve(self, cartItems) takeUntil:self.rac_willDeallocSignal] map:^id(id value) {
        RLMResults *result = value;
        if (result.count > 0) {
            return @YES;
        }
        else {
            return @NO;
        }
    }];
    
    [[[orderButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:orderButton.rac_willDeallocSignal] subscribeNext:^(id x) {
        [self.cartItems convertToArrayWithCompletionBlock:^(NSMutableArray *results) {
            NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:kOrderPlaceOrderUrl params:nil];
            NSDictionary *param = @{@"cart_items" : [CartItem keyValuesArrayWithObjectArray:results]};
            RACSignal *signal = [Tool POST:url parameters:param progressInView:self.view showNetworkError:YES];
            [signal subscribeNext:^(id responseObject) {
                if (kGetResponseCode(responseObject) == kSuccessCode){
                    // 创建成功
                }
            }];

        }];
        
    }];
}

- (void)initUI{
    
    self.title = @"购物篮";
   
    totalTitle.font =  [UIFont fontWithName:[MegaTheme fontName] size:15];
    
    totalTitle.textColor = [UIColor blackColor];
    
    totalTitle.text = @"总计";
    
    totalLabel.font = [UIFont fontWithName:[MegaTheme fontName] size:15];
    
    totalLabel.textColor = [UIColor blackColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CartCell"];

    CartItem *item = [self.cartItems objectAtIndex:indexPath.row];

    //if ([cacheManager objectWithKey:item.product_id]) {
        //内存中已缓存
        [cell.productImageView sd_setImageWithURL:kUrlFromString(item.logo_filename) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                cell.productImageView.contentMode = UIViewContentModeScaleAspectFit;
            }
        }];
        
        cell.titleLabel.text = item.name;
        cell.detailsLabel.text = item.specificationBrief;
        cell.priceLabel.text = [NSString stringWithFormat:@"单价:¥%@", item.price];
    
        cell.quantityTextField.text = [NSString stringWithFormat:@"%ld", (long)item.quantity];
    
        [[[[cell.quantityTextField rac_signalForControlEvents:UIControlEventEditingDidEnd] takeUntil:cell.rac_prepareForReuseSignal] map:^id(UITextField *field) {
            return field.text;
        }] subscribeNext:^(NSString *newQty) {
            if (newQty.length == 0 || !newQty){
                newQty = @"1";
            }
            if (item) {
                [CartItem setItemWithProductId:item.product_id specification_id:item.specification_id quantity:[newQty integerValue]];
            }
        }];
        
        return cell;

//    }
//    else {
//        //未缓存
//        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:[kProductFindOneUrl stringByReplacingOccurrencesOfString:@":product_id" withString:item.product_id] params:nil];
//        RACSignal *signal = [Tool GET:url parameters:nil showNetworkError:YES];
//        [signal subscribeNext:^(id responseObject) {
//            
//            if (kGetResponseCode(responseObject) == kSuccessCode) {
//                ProductModel *model = [ProductModel objectWithKeyValues:kGetResponseData(responseObject)];
//                [cacheManager addItem:model];
//                [cartItemTableView reloadData];
//            }
//        }];
//        return cell;
//    }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.cartItems.count;
    
}

#pragma mark - UIScrollViewDelegate -

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    kDismissKeyboard;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
