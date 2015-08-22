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

#define kSectionHeaderPaddingLeft 8

static NSString *reuseIdetifier = @"reuseForSearchResult";

@implementation SearchResultTableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.searchResult = [[SearchResultModel alloc] init];
        [[[RACObserve(self, searchResult) skip:1] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
            [self reloadData];
        }];
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - UITableViewDelegate -

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
    if ([self numberOfSections] > 1) {
        if (section == 0) {
            return [NSString stringWithFormat:@"店铺(%d)",self.searchResult.stores.count];
        }
        else {
            return [NSString stringWithFormat:@"早餐(%d)",self.searchResult.products.count];;
        }
    }
    else if ([self numberOfSections] == 1){
        if (self.searchResult.products.count > 0) {
            return [NSString stringWithFormat:@"早餐(%d)",self.searchResult.products.count];;
        }
        else{
            return [NSString stringWithFormat:@"店铺(%d)",self.searchResult.stores.count];
        }
    }
    else{
        return @"opps!";
    }
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
            TsaoLog(@"获取商品数量");
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
