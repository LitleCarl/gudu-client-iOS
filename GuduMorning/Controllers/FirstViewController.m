//
//  FirstViewController.m
//  GuduMorning
//
//  Created by Tsao on 15/7/31.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

#import <RACScheduler.h>
// Library
#import "KLCPopup.h"
#import <ReactiveCocoa/UIButton+RACCommandSupport.h>

// View
#import "ChooseListView.h"
#import "TsaoSearchBar.h"
#import "TsaoStoreListTableViewCell.h"
#import "FXBlurView.h"
#import "SearchResultTableView.h"
#import <AutoScrollLabel/CBAutoScrollLabel.h>
// Category
#import "UIView+CreateBorder.h"
#import "UIView+Capture.h"

// Model
#import "SearchResultModel.h"
#import "ProductModel.h"

// ViewController
#import "StoreIndexViewController.h"


@interface FirstViewController ()<UITableViewDataSource, UITableViewDelegate>

/**
 *  商铺模型列表
 */
@property (nonatomic, strong) NSMutableArray* storeList;

/**
 *  商户列表TableView
 */
@property (nonatomic, weak) UITableView *storeTableView;

/**
 *  左上角学校选择按钮
 */
@property (nonatomic, weak) UIButton *campusButton;

@property (nonatomic, weak) CBAutoScrollLabel *campusLabel;

@end

@implementation FirstViewController

/**
 *  搜索结果TableView
 */
static SearchResultTableView *searchTableView = nil;

/**
 *  searchTableView所在的Blurview
 */
static FXBlurView *blurViewUnderSearchTableView = nil;

// 商铺列表cell重用标记
static NSString *cellIdentifier = @"store_list_cell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"首页";
        
        self.tabBarItem.image = [[UIImage imageNamed:@"index_tab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[[UIImage imageNamed:@"index_tab_select"] imageTintedWithColor:kGreenColor]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"首页";
    [self setNav];
    [self createUI];
    [self setUpTrigger];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.campusLabel scrollLabelIfNeeded];
}

- (void)createUI{
    // 添加商铺列表TableView
    UITableView *storeTableView = [[UITableView alloc] initWithFrame:(CGRect){
        CGPointMake(0, kNavBarHeight), CGSizeMake(kScreenWidth, kScreenHeight - kNavBarHeight - kTabBarHeight)
    }];
    self.storeTableView = storeTableView;
    //storeTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"restaurant_icons"]];
    storeTableView.delegate = self;
    storeTableView.dataSource = self;
    
    //设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; ++i) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd",i]];
        [idleImages addObject:image];
    }
    @weakify(storeTableView);
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        //下拉刷新回调
        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:[kCampusFindOneUrl stringByReplacingOccurrencesOfString:@":campus_id" withString:[Tool getUserDefaultByKey:kCampusUsedKey]] params:nil];
        RACSignal *getStoreSignal = [Tool GET:url parameters:nil showNetworkError:YES];
        [getStoreSignal subscribeNext:^(id response) {
            if (kGetResponseCode(response) == kSuccessCode) {
                self.storeList = [StoreModel objectArrayWithKeyValuesArray:[kGetResponseData(response) objectForKey:@"stores"]];
                [self.campusLabel setText:[kGetResponseData(response) objectForKey:@"name"]];
            }
        } error:^(NSError *error) {
            [storeTableView_weak_.header endRefreshing];
        } completed:^{
            [storeTableView_weak_.header endRefreshing];
        }];
    }];
    gifHeader.backgroundColor = [UIColor whiteColor];
    // 绑定TableView的header
    storeTableView.header = gifHeader;
    
    [gifHeader setImages:idleImages forState:MJRefreshStateIdle];
    
    //设置即将刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd",i]];
        [refreshingImages addObject:image];
    }
    [gifHeader setImages:refreshingImages forState:MJRefreshStatePulling];
    
    //设置正在刷新是的动画图片
    [gifHeader setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    //马上进入刷新状态
    [self.view addSubview:storeTableView];
    
}

/**
 *  设置一些触发器
 */
- (void)setUpTrigger{
    [[[RACObserve(self, storeList) skip:1] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        [self.storeTableView reloadData];
    }];

    // 订阅所在学校的campus_id变更
    RACChannelTerminal *campusChangeTerminal = [[NSUserDefaults standardUserDefaults] rac_channelTerminalForKey:kCampusUsedKey];
    [campusChangeTerminal subscribeNext:^(NSString *newCampusId) {
        TsaoLog(@"第一次启动，或者更新campuskey:%@",newCampusId);
        if (newCampusId == nil) {
            [[self.campusButton rac_command] execute:nil];
        }
        else{
            [self.storeTableView.header beginRefreshing];
        }
    }];
}

/**
 *  设置导航条
 */
- (void)setNav{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
    backView.backgroundColor = kGreenColor;
    [self.view addSubview:backView];
    //学校label
    CBAutoScrollLabel *campusLabel = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(10, 28, 40, 25)];
    campusLabel.textColor = [UIColor whiteColor];
    campusLabel.labelSpacing = 35; // distance between start and end labels
    campusLabel.pauseInterval = 1.7; // seconds of pause before scrolling starts again
    campusLabel.scrollSpeed = 30; // pixels per second
    campusLabel.textAlignment = NSTextAlignmentCenter; // centers text when no auto-scrolling is applied
    campusLabel.fadeLength = 12.f; // length of the left and right edge fade, 0 to disable
    self.campusLabel = campusLabel;
    [backView addSubview:campusLabel];
    
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame = CGRectMake(10, 28, 40, 25);
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.campusButton = cityBtn;
    
    [cityBtn setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        UIViewController *campusListTableViewController = [kMainStoryBoard instantiateViewControllerWithIdentifier:@"CampusListTabelView"];
        [self presentViewController:campusListTableViewController animated:YES completion:NULL];
        return [RACSignal empty];
    }]];
    [backView addSubview:cityBtn];
    //
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cityBtn.frame), 36, 13, 10)];
    [arrowImage setImage:[UIImage imageNamed:@"icon_homepage_downArrow"]];
    [backView addSubview:arrowImage];
    //地图
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame = CGRectMake(kScreenWidth - 42, 30, 42, 30);
    [mapBtn setImage:[UIImage imageNamed:@"icon_homepage_map_old"] forState:UIControlStateNormal];
    [backView addSubview:mapBtn];
    
    // 搜索框
    TsaoSearchBar *searchView = [[TsaoSearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(arrowImage.frame), 20 + 6, kScreenWidth - 40 - CGRectGetMaxX(arrowImage.frame), 31)];
    searchView.barTintColor = COLOR(7, 170, 153, 1);
    searchView.placeholder = @"豆浆油条";
    [backView addSubview:searchView];
    
    UIButton *cancelSearchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [cancelSearchButton setTitle:@"返回" forState:UIControlStateNormal];
    [backView addSubview:cancelSearchButton];
    [cancelSearchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelSearchButton.alpha = 0;
    cancelSearchButton.center = CGPointMake(kScreenWidth - 20, 40);
    cancelSearchButton.titleLabel.font = [UIFont fontWithName:kFontFamily size:kFontNormalSize];
    [cancelSearchButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        [UIView animateWithDuration:0.2 animations:^{
            searchView.frame = CGRectMake(CGRectGetMaxX(arrowImage.frame),  20 + 6, kScreenWidth - 40 - CGRectGetMaxX(arrowImage.frame), 31);
            cityBtn.alpha = 1;             // 显示地区按钮
            arrowImage.alpha = 1;          // 显示下拉箭头
            cancelSearchButton.alpha = 0;  // 隐藏取消按钮
            self.campusLabel.alpha = 1;
            blurViewUnderSearchTableView.hidden = YES;
            self.tabBarController.tabBar.hidden = NO;
        }];

        return [RACSignal empty];
    }]];

    
    // 焦点信号
    [[[searchView.tsaoTextField rac_signalForControlEvents:UIControlEventEditingDidBegin] takeUntil:searchView.rac_willDeallocSignal]
     subscribeNext:^(UITextField *textField) {
         [UIView animateWithDuration:0.2 animations:^{
             searchView.frame = CGRectMake(10,  20 + 6, kScreenWidth - 40 - 10, 31);
             cityBtn.alpha = 0;             // 隐藏地区按钮
             arrowImage.alpha = 0;          // 隐藏下拉箭头
             cancelSearchButton.alpha = 1;  // 显示取消按钮
             self.campusLabel.alpha = 0;
         }];
        
         if (blurViewUnderSearchTableView == nil){
             blurViewUnderSearchTableView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight)];
             blurViewUnderSearchTableView.dynamic = NO;
             blurViewUnderSearchTableView.underlyingView = self.storeTableView;
             blurViewUnderSearchTableView.blurRadius = 45;
             [self.view addSubview:blurViewUnderSearchTableView];
             
             searchTableView = [[SearchResultTableView alloc] initWithFrame:blurViewUnderSearchTableView.bounds];
             searchTableView.sourceController = self;
             [blurViewUnderSearchTableView addSubview:searchTableView];
         }
         else {
             blurViewUnderSearchTableView.hidden = NO;
         }
         self.tabBarController.tabBar.hidden = YES;
        }
     ];
    
    // 输入新的关键字
    [[[searchView.tsaoTextField rac_signalForControlEvents:UIControlEventEditingChanged] takeUntil:searchView.rac_willDeallocSignal] subscribeNext:^(UITextField *textField) {
        NSString *searchText = textField.text;
        
        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:kSearchUrl params:
                            @{
                              @"keyword" : searchText,
                              @"campus_id" : [Tool getUserDefaultByKey:kCampusUsedKey]
                              }
                         ];
        [[[[Tool GET:url parameters:nil showNetworkError:NO] map:^id(id response) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:response];
                return nil;
            }];
        }] switchToLatest] subscribeNext:^(id response) {
            if (kGetResponseCode(response) == kSuccessCode) {
                SearchResultModel *newResult = [[SearchResultModel alloc] init];
                newResult.stores = [StoreModel objectArrayWithKeyValuesArray:[kGetResponseData(response) objectForKey:@"stores"]];
                newResult.products = [ProductModel objectArrayWithKeyValuesArray:[kGetResponseData(response) objectForKey:@"products"]];
                searchTableView.searchResult = newResult;
            }
            else {
                searchTableView.searchResult = nil;
            }
        }];
        
    }];
    
    // 失去焦点信号
    [[[searchView.tsaoTextField rac_signalForControlEvents:UIControlEventEditingDidEnd] takeUntil:searchView.rac_willDeallocSignal]
     subscribeNext:^(UITextField *textField) {
     }
     ];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 学校相关 -

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/**
 *  加载首页数据
 */
- (void)fetchData{
    
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StoreIndexViewController *storeIndexViewController = [kMainStoryBoard instantiateViewControllerWithIdentifier:kStoreIndexViewControllerStoryboardId];
    storeIndexViewController.store_id = [[self.storeList objectAtIndex:indexPath.row] id];
    [self.navigationController pushViewController:storeIndexViewController animated:YES];
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.storeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoreModel *store = [self.storeList objectAtIndex:indexPath.row];
    TsaoStoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TsaoStoreListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier cellHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath] padding:12];
    }        
    cell.store = store;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static UIView *headerForFilter = nil;
    if (section == 0) {
        if (headerForFilter == nil) {
            headerForFilter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [self tableView:tableView heightForHeaderInSection:section])];
            headerForFilter.backgroundColor = [UIColor whiteColor];
            [headerForFilter drawBottomLine:BottomBorder|TopBorder lineWidth:1 fillColor:[UIColor colorWithWhite:0.96 alpha:1]];
            
            //筛选
            NSArray *filterName = @[@"口味",@"最受欢迎",@"价格排序"];
            static UIView *_maskView = nil;
            for (int i = 0; i < 3; i++) {
                //文字
                UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                filterBtn.frame = CGRectMake(i*kScreenWidth / filterName.count, 0, kScreenWidth / filterName.count - 15, 40);
                filterBtn.tag = 100 + i;
                filterBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [filterBtn setTitle:filterName[i] forState:UIControlStateNormal];
                [filterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [filterBtn setTitleColor:kGreenColor forState:UIControlStateSelected];
                //[filterBtn addTarget:self action:@selector(OnFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
                [headerForFilter addSubview:filterBtn];
                [[[filterBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:filterBtn.rac_willDeallocSignal] subscribeNext:^(id x) {
                    
                    //                    for (int i = 0; i < 3; i++) {
//                        UIButton *btn = (UIButton *)[self.view viewWithTag:100+i];
//                        UIButton *sanjiaoBtn = (UIButton *)[self.view viewWithTag:120+i];
//                        btn.selected = NO;
//                        sanjiaoBtn.selected = NO;
//                    }
//                    sender.selected = YES;
//                    UIButton *sjBtn = (UIButton *)[self.view viewWithTag:sender.tag+20];
//                    sjBtn.selected = YES;
//                    _maskView.hidden = NO;
                }];
                //三角
                UIButton *sanjiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                sanjiaoBtn.frame = CGRectMake((i+1)*kScreenWidth/3-15, 16, 8, 7);
                sanjiaoBtn.tag = 120+i;
                [sanjiaoBtn setImage:[UIImage imageNamed:@"icon_arrow_dropdown_normal"] forState:UIControlStateNormal];
                [sanjiaoBtn setImage:[UIImage imageNamed:@"icon_arrow_dropdown_selected"] forState:UIControlStateSelected];
                [headerForFilter addSubview:sanjiaoBtn];
            }
        }
        return headerForFilter;
    }
    return [[UIView alloc] init];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

/**
 *  隐藏导航栏
 *
 *  @return  返回yes则隐藏
 */
- (BOOL)hideNavBar{
    return YES;
}

@end
