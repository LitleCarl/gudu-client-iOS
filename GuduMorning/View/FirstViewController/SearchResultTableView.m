//
//  SearchResultTableView.m
//  GuduMorning
//
//  Created by Macbook on 15/8/21.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "SearchResultTableView.h"

// Model
#import "SearchResultModel.h"

// View
#import "SearchResultTableViewCell.h"

// Category
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

// ViewController
#import "StoreIndexViewController.h"
#import "ProductScrollViewController.h"

#define kSectionHeaderPaddingLeft 8

typedef enum : NSUInteger {
    店铺,
    商品
} SectionType;

static NSString *reuseIdetifier = @"reuseForSearchResult";

@interface SearchResultTableView () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@end

@implementation SearchResultTableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.searchResult = [[SearchResultModel alloc] init];
        
        [[[RACObserve(self, searchResult) skip:1] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
            [self reloadData];
            [self reloadEmptyDataSet];
        }];
        
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [UIView new];
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
    }
    return self;
}

#pragma mark - UITableViewDelegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sourceController) {

        if ([self detectTypeOfSection:indexPath.section] == 店铺){
        
            StoreIndexViewController *storeController = [kMainStoryBoard instantiateViewControllerWithIdentifier:kStoreIndexViewControllerStoryboardId];
            storeController.store_id = [[self.searchResult.stores objectAtIndex:indexPath.row] id];
            
            [self.sourceController.navigationController pushViewController:storeController animated:YES];
        
            }
        else {
            ProductScrollViewController *productController = [kMainStoryBoard instantiateViewControllerWithIdentifier:kProductViewControllerStoryboardId];
            productController.product_id = [[self.searchResult.products objectAtIndex:indexPath.row] id];
            [self.sourceController.navigationController pushViewController:productController animated:YES];
        
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    kDismissKeyboard
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [self tableView:tableView heightForHeaderInSection:section])];
    sectionHeader.backgroundColor = COLOR(71, 85, 94, 0.4);
    UILabel *title = [[UILabel alloc] init];
    title.text = [self tableView:tableView titleForHeaderInSection:section];
    title.font = kSmallFont;
    title.textColor = COLOR(250, 245, 221, 1);
    [title sizeToFit];
    title.center = CGPointMake(kSectionHeaderPaddingLeft + CGRectGetWidth(title.frame) * 0.5, [self tableView:tableView heightForHeaderInSection:section] * 0.5);
    [sectionHeader addSubview:title];
    return sectionHeader;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    // 有商品也有店铺,店铺section排0,商品section排1
    if ([self detectTypeOfSection:section] == 店铺){
    
        return [NSString stringWithFormat:@"店铺(%lu)",(unsigned long)self.searchResult.stores.count];

    }
    else{
        return [NSString stringWithFormat:@"早餐(%lu)",(unsigned long)self.searchResult.products.count];;

    }
//    if ([self numberOfSections] > 1) {
//        if (section == 0) {
//            return [NSString stringWithFormat:@"店铺(%lu)",(unsigned long)self.searchResult.stores.count];
//        }
//        else {
//            return [NSString stringWithFormat:@"早餐(%lu)",(unsigned long)self.searchResult.products.count];;
//        }
//    }
//    else if ([self numberOfSections] == 1){
//        if (self.searchResult.products.count > 0) {
//            return [NSString stringWithFormat:@"早餐(%lu)",(unsigned long)self.searchResult.products.count];;
//        }
//        else{
//            return [NSString stringWithFormat:@"店铺(%lu)",(unsigned long)self.searchResult.stores.count];
//        }
//    }
//    else{
//        return @"opps!";
//    }
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSUInteger total = 0;
    if (self.searchResult.products.count > 0) {
        total++;
    }
    if (self.searchResult.stores.count > 0) {
        total++;
    }
    return total;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self numberOfSections] > 1) {
        if (section == 0) {
            return self.searchResult.stores.count;
        }
        else {
            return self.searchResult.products.count;
        }
    }
    else if ([self numberOfSections] == 1){
        if (self.searchResult.products.count > 0) {
            return self.searchResult.products.count;
        }
        else{
            return self.searchResult.stores.count;
        }
    }
    else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetifier];
    if (cell == nil) {
        cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetifier cellHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath] padding:12];
    }
    
    if ([self numberOfSections] > 1) {
        if (indexPath.section == 0) {
            cell.model = [self.searchResult.stores objectAtIndex:indexPath.row];
        }
        else {
            cell.model = [self.searchResult.products objectAtIndex:indexPath.row];
        }
    }
    else if ([self numberOfSections] == 1){
        if (self.searchResult.products.count > 0) {
            cell.model = [self.searchResult.products objectAtIndex:indexPath.row];
        }
        else{
            cell.model = [self.searchResult.stores objectAtIndex:indexPath.row];
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (SectionType)detectTypeOfSection:(NSInteger)section{
    if ([self numberOfSections] > 1) {
        if (section == 0) {
            return 店铺;
        }
        else {
            return 商品;
        }
    }
    else if ([self numberOfSections] == 1){
        if (self.searchResult.products.count > 0) {
            return 商品;
        }
        else{
            return 店铺;
        }
    }
    else{
        return 商品;
    }

}

#pragma mark - DNZEmptyDataSet -

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, scrollView.bounds.size.height)];
    emptyView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    emptyView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.6];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.8 * kScreenWidth, 40)];
    [titleLabel setNumberOfLines:2];
    titleLabel.text = @"可以在附近搜索";
    titleLabel.font = kBigBoldFont;
    titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    titleLabel.layer.shadowColor = [titleLabel.textColor CGColor];
    titleLabel.layer.shadowOffset = CGSizeMake(0.0, 0.2);
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(kScreenWidth * 0.5, 20 + CGRectGetHeight(titleLabel.frame));
    [emptyView addSubview:titleLabel];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleLabel.frame) + 40, 1 / [[UIScreen mainScreen] scale])];
    separator.backgroundColor = [titleLabel textColor];
    separator.center = CGPointMake(CGRectGetMidX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame) + 8);
    [emptyView addSubview:separator];
    
    return emptyView;
}
//- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
//{
//    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
//    back.backgroundColor = kGreenColor;
//    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [activityView startAnimating];
//    [back addSubview:activityView];
//    return back;
//}
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return [UIImage imageNamed:@"restaurant_icons"];
//}

//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text = @"Please Allow Photo Access";
//    
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
//                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
//    
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

#pragma mark - DNZEmptyDataDelegate -

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
