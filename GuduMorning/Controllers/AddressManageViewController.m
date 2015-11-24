//
//  AddressManageViewController.m
//  GuduMorning
//
//  Created by Macbook on 15/9/9.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "AddressManageViewController.h"

// Category
#import "UIScrollView+EmptyDataSet.h"
#import <UITableView+FDTemplateLayoutCell.h>
// View
#import "AddressListCell.h"

// ViewController
#import "AddAddressViewController.h"
#import "EditAddressViewController.h"
#define kAddressCellReuseID @"address_cell"

#import "MegaTheme.h"

@interface AddressManageViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, SWTableViewCellDelegate>
{
    /// 添加地址按钮
    __weak IBOutlet UIButton *addAddressButton;
    __weak IBOutlet UITableView *addressTableView;
}
/**
 *  用户的地址
 */
@property (nonatomic, strong) NSMutableArray *addressList;

@end

@implementation AddressManageViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initUI];
    [self setUpTrigger];
}

- (void)initUI{
    addressTableView.tableFooterView = [UIView new];
}

- (void)setUpTrigger{
    
    [[addAddressButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        AddAddressViewController *controller = [kUserStoryBoard instantiateViewControllerWithIdentifier:kAddAddressViewControllerStoryboardId];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [RACObserve([UserSession sharedUserSession], user) subscribeNext:^(UserModel *user) {
        if (user == nil) {
           MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [hud setLabelText:@"疯狂加载ing"];
        }
        else {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        self.addressList = user.addresses;
        [addressTableView reloadData];
    }];
    
    // 监听addressList的add和remove
    RACSignal *changeSignalOfAddressList = [[self rac_valuesAndChangesForKeyPath:@keypath(self, addressList) options: NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld observer:nil] takeUntil:self.rac_willDeallocSignal];
    [changeSignalOfAddressList subscribeNext:^(RACTuple *x){
        [addressTableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:kAddressCellReuseID configuration:^(AddressListCell *cell) {
        cell.address = [self.addressList objectAtIndex:indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditAddressViewController *controller = [kUserStoryBoard instantiateViewControllerWithIdentifier:kEditAddressViewControllerStoryboardId];
    controller.address = [self.addressList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableViewDataSource -

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressCellReuseID];
    cell.address = [self.addressList objectAtIndex:indexPath.row];
    cell.fd_enforceFrameLayout = NO;
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                title:@"删除"];
    cell.rightUtilityButtons = leftUtilityButtons;

    cell.delegate = self;

    return cell;
}

#pragma mark - SWTableViewCellDelegate -

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSInteger row = [addressTableView indexPathForCell:cell].row;
    NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:kdeleteAddressUrl params:nil];
    [[Tool DELETE:url parameters:@{@"address_id" : [[self.addressList objectAtIndex:row] id]} progressInView:self.view showNetworkError:YES] subscribeNext:^(id responseObject) {
        if (kGetResponseCode(responseObject) == kSuccessCode) {
            [MBProgressHUD bwm_showTitle:@"删除成功" toView:self.navigationController.view hideAfter:2.0 msgType:BWMMBProgressHUDMsgTypeSuccessful];
            NSMutableArray *mutableArray = [self mutableArrayValueForKey:@keypath(self, addressList)];
            [mutableArray removeObjectAtIndex:row];
            kSetNeedReloadUserSession;
        }
    }];

}


@end
