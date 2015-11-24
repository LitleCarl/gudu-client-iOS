//
//  SelectCouponViewController.m
//  GuduMorning
//
//  Created by Macbook on 11/7/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import "SelectCouponViewController.h"
#import "SelectCouponCollectionViewCell.h"
@interface SelectCouponViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *couponCollectionView;
@property (nonatomic, strong) NSMutableArray *models;

/**
 *  监听token
 */
@property (nonatomic, strong) RLMNotificationToken* token;

/**
 *  购物车内容
 */
@property (nonatomic, strong) RLMResults *cartItems;

@property (nonatomic, copy) NSNumber *totalPrice;

@end
static NSString *reuseIdentifier = @"coupon_cell";
@implementation SelectCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self setUpTrigger];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"不使用" style:UIBarButtonItemStylePlain target:self action:@selector(cancel_usage)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpTrigger{
    [self fetchData: NO];
    self.cartItems = [CartItem allObjects];
    // 监听购物车变化
    RLMRealm *realm = [RLMRealm defaultRealm];
    self.token = [realm addNotificationBlock:^(NSString *note, RLMRealm * realm) {
        self.cartItems = [CartItem allObjects];
    }];
    
    // 监听cartItems变化,更新总计价格
    [RACObserve(self, cartItems) subscribeNext:^(RLMResults *result) {
        __block NSDecimalNumber *total = [NSDecimalNumber decimalNumberWithString:@"0.0"];
        for (int i = 0; i < self.cartItems.count; i++) {
            CartItem *item = [self.cartItems objectAtIndex:i];
            NSDecimalNumber *perPrice = [NSDecimalNumber decimalNumberWithString:item.price];
            NSDecimalNumber *qty = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", (long)item.quantity]];
            NSDecimalNumber *all = [perPrice decimalNumberByMultiplyingBy:qty];
            total = [total decimalNumberByAdding:all];

        }
        self.totalPrice = [NSNumber numberWithFloat:total.floatValue];
        
    }];
    
    [RACObserve(self, totalPrice) subscribeNext:^(NSNumber *total) {
        [self.couponCollectionView reloadData];
    }];

}

- (void)fetchData:(BOOL)loadMore{
    NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:[kCouponsUrl stringByReplacingOccurrencesOfString:@":user_id" withString:[[UserSession sharedUserSession] user].id] params:NULL];
    [[Tool GET:url parameters:nil progressInView:self.view showNetworkError:YES] subscribeNext:^(id responseObject) {
        if (kGetResponseCode(responseObject) == kSuccessCode) {
            self.models = [CouponModel objectArrayWithKeyValuesArray:[kGetResponseData(responseObject) objectForKey:@"coupons"]];
        }
        
    }];
    
    [RACObserve(self, models) subscribeNext:^(NSArray *x) {
        if (x) {
            [self.couponCollectionView reloadData];
        }
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectCouponCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.coupon = [self.models objectAtIndex:indexPath.row];
    cell.currentPrice = self.totalPrice;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL valid = [[[self.models objectAtIndex:indexPath.row] least_price] floatValue] <= self.totalPrice.floatValue;
    
    if (valid) {
        if (self.delegate) {
            [self.delegate selectCoupon:[self.models objectAtIndex:indexPath.row]];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [MBProgressHUD bwm_showTitle:@"无法使用" toView:kKeyWindow hideAfter:2.0 msgType:BWMMBProgressHUDMsgTypeSuccessful];
    }
}
#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */


 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     return YES;
 }
 

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenSize.width * 0.4, kScreenSize.width * 0.4);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kScreenWidth * 0.05;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kScreenWidth * 0.05;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kScreenWidth * 0.05, kScreenWidth * 0.05, kScreenWidth * 0.05, kScreenWidth * 0.05);
}

/**
 *  不使用优惠
 */
- (void)cancel_usage{
    if (self.delegate) {
        [self.delegate selectCoupon:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];

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
