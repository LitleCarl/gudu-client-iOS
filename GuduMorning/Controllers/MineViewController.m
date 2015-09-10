//
//  MineViewController.m
//  meituan
//
//  Created by jinzelu on 15/7/6.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "MineViewController.h"

// Session
#import "UserSession.h"

// ViewController
#import "LoginViewController.h"
#import "OrderTableViewController.h"
#import "AddressManageViewController.h"
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *rowData;
}
@end

@implementation MineViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tabBarItem.title = @"我";
        
        self.tabBarItem.image = [[UIImage imageNamed:@"icon_tabbar_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[[UIImage imageNamed:@"icon_tabbar_mine_selected"] imageTintedWithColor:kGreenColor]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    [self setUpTrigger];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTrigger{

}

-(void)createUI{
    self.title = @"我的资料";
    rowData = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:@"全部订单" forKey:@"title"];
    [dic1 setObject:@"icon_mine_onsite" forKey:@"image"];
    [rowData addObject:dic1];
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
    [dic2 setObject:@"待付订单" forKey:@"title"];
    [dic2 setObject:@"icon_mine_onsite" forKey:@"image"];
    [rowData addObject:dic2];
    NSMutableDictionary *dic3 = [[NSMutableDictionary alloc] init];
    [dic3 setObject:@"待评价订单" forKey:@"title"];
    [dic3 setObject:@"icon_mine_onsite" forKey:@"image"];
    [rowData addObject:dic3];
    NSMutableDictionary *dic4 = [[NSMutableDictionary alloc] init];
    [dic4 setObject:@"已完成订单" forKey:@"title"];
    [dic4 setObject:@"icon_mine_onsite" forKey:@"image"];
    [rowData addObject:dic4];
    NSMutableDictionary *dic5 = [[NSMutableDictionary alloc] init];
    [dic5 setObject:@"我的折扣券" forKey:@"title"];
    [dic5 setObject:@"icon_mine_onsite" forKey:@"image"];
    [rowData addObject:dic5];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return rowData.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 75;
    }else{
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }else{
        return 40;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 75)];
    footerView.backgroundColor = COLOR(239, 239, 244, 1);
    return footerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
        headerView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg_login"]];
        //头像
        UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 55, 55)];
        userImage.layer.masksToBounds = YES;
        userImage.layer.cornerRadius = 27;
        [userImage setImage:[UIImage imageNamed:@"Avatar"]];
        [headerView addSubview:userImage];
        //用户名
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+55+5, 15, 200, 30)];
        userNameLabel.font = [UIFont systemFontOfSize:13];
        RAC(userNameLabel, text) = [[RACObserve([UserSession sharedUserSession], user) takeUntil:headerView.rac_willDeallocSignal] map:^id(UserModel *user) {
            TsaoLog(@"value:%@", user);
            if (user.phone == nil) {
                return @"";
            }
            else{
                return user.phone;
            }
        }];
        [headerView addSubview:userNameLabel];
//        //账户余额
//        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+55+5, 40, 200, 30)];
//        moneyLabel.font = [UIFont systemFontOfSize:13];
//        moneyLabel.text = @"账户余额：0.00元";
//        [headerView addSubview:moneyLabel];
        
        //
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-10-24, 30, 12, 24)];
        [arrowImg setImage:[UIImage imageNamed:@"icon_mine_accountViewRightArrow"]];
        [headerView addSubview: arrowImg];
        
        return headerView;
    }else{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
        headerView.backgroundColor = COLOR(239, 239, 244, 1);
        return headerView;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"mineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.text = [rowData[indexPath.row] objectForKey:@"title"];
        NSString *imgStr = [rowData[indexPath.row] objectForKey:@"image"];
        cell.imageView.image = [UIImage imageNamed:imgStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }else{
        cell.textLabel.text = @"收货地址管理";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        AddressManageViewController *controller = [kUserStoryBoard instantiateViewControllerWithIdentifier:kAddressManageViewControllerStoryboardId];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if (indexPath.row == 0 && indexPath.section == 1) {
        OrderTableViewController *controller = [kUserStoryBoard instantiateViewControllerWithIdentifier:kOrderTableViewControllerStoryboardId];
        controller.orderType = AllOrder;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.row == 1 && indexPath.section == 1) {
        OrderTableViewController *controller = [kUserStoryBoard instantiateViewControllerWithIdentifier:kOrderTableViewControllerStoryboardId];
        controller.orderType = notPaid;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.row == 2 && indexPath.section == 1) {
        OrderTableViewController *controller = [kUserStoryBoard instantiateViewControllerWithIdentifier:kOrderTableViewControllerStoryboardId];
        controller.orderType = NotCommentedOrder;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.row == 3 && indexPath.section == 1) {
        OrderTableViewController *controller = [kUserStoryBoard instantiateViewControllerWithIdentifier:kOrderTableViewControllerStoryboardId];
        controller.orderType = done;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
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
