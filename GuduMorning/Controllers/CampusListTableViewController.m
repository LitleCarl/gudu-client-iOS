//
//  CampusListTableViewController.m
//  GuduMorning
//
//  Created by Macbook on 15/8/23.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "CampusListTableViewController.h"

// View
#import "CampusListTableViewCell.h"

@interface CampusListTableViewController () <UITableViewDataSource, UITableViewDelegate>

/**
 *  学校列表
 */
@property (weak, nonatomic) IBOutlet UITableView *campusTableView;

/**
 *  搜索框
 */
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *campusList;

@end

@implementation CampusListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[RACObserve(self, campusList) skip:1] subscribeNext:^(id x) {
        [self.campusTableView reloadData];
    }];
    [self fetchData];
    // Do any additional setup after loading the view.
}

- (void)fetchData{
    NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:kCampusUrl params:nil];
    RACSignal *signal = [Tool GET:url parameters:nil progressInView:self.view showNetworkError:YES];

    [signal subscribeNext:^(id responseObject) {
        if (kGetResponseCode(responseObject) == kSuccessCode) {
            NSMutableArray *arrayOfCampus = [CampusModel objectArrayWithKeyValuesArray:kGetResponseData(responseObject)];
            self.campusList = arrayOfCampus;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CampusModel *campus = [self.campusList objectAtIndex:indexPath.row];
 
    if ([campus id]){
        [Tool setUserDefault:@{kCampusUsedKey : [campus id]}];
        // 创建成功
        /**
         *  删除购物车商品
         */
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObjects:[CartItem allObjects]];
        [realm commitWriteTransaction];

        [self backToPrv:nil];
    }
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.campusList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CampusListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"campusListCellReuseIdentifier"];
    cell.campus = [self.campusList objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - 自定义导航栏 -

- (IBAction)backToPrv:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
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
