//
//  CouponCollectionViewController.m
//  GuduMorning
//
//  Created by Macbook on 11/6/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import "CouponCollectionViewController.h"
#import "CouponModel.h"
#import "CouponCollectionViewCell.h"

@interface CouponCollectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *couponCollectionView;

@property (nonatomic, strong) NSMutableArray *models;
@end

@implementation CouponCollectionViewController

static NSString * const reuseIdentifier = @"coupon_cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTrigger];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTrigger{
    [self fetchData: NO];
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
    CouponCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.coupon = [self.models objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

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

@end
