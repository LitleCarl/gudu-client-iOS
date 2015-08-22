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

// Category
#import "UIView+CreateBorder.h"
#import "UIView+Capture.h"

// Model
#import "SearchResultModel.h"
#import "ProductModel.h"
@interface FirstViewController ()<UITableViewDataSource, UITableViewDelegate>

/**
 *  商铺模型列表
 */
@property (nonatomic, strong) NSMutableArray* storeList;

/**
 *  商户列表TableView
 */
@property (nonatomic, weak) UITableView *storeTableView;

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
    [self setUpTrigger];
    [self setNav];
    [self createUI];
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
        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:[kCampusFindOneUrl stringByReplacingOccurrencesOfString:@":campus_id" withString:@"55ced5a104c32d1b6ab0101b"] params:nil];
        RACSignal *getStoreSignal = [Tool GET:url parameters:nil showNetworkError:YES];
        [getStoreSignal subscribeNext:^(id response) {
            if (kGetResponseCode(response) == kSuccessCode) {
                self.storeList = [StoreModel objectArrayWithKeyValuesArray:[kGetResponseData(response) objectForKey:@"stores"]];
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
    [gifHeader beginRefreshing];
    [self.view addSubview:storeTableView];
    
}

/**
 *  设置一些触发器
 */
- (void)setUpTrigger{
    [[[RACObserve(self, storeList) skip:1] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        [self.storeTableView reloadData];
    }];

}

/**
 *  设置导航条
 */
- (void)setNav{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
    backView.backgroundColor = kGreenColor;
    [self.view addSubview:backView];
    //城市
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame = CGRectMake(10, 28, 40, 25);
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cityBtn setTitle:@"北京" forState:UIControlStateNormal];
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
            cityBtn.alpha = 1;             // 隐藏地区按钮
            arrowImage.alpha = 1;          // 隐藏下拉箭头
            cancelSearchButton.alpha = 0;  // 显示取消按钮
            
            blurViewUnderSearchTableView.hidden = YES;
            
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
         }];
        
         if (blurViewUnderSearchTableView == nil){
             blurViewUnderSearchTableView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight)];
             blurViewUnderSearchTableView.dynamic = NO;
             blurViewUnderSearchTableView.underlyingView = self.storeTableView;
             blurViewUnderSearchTableView.blurRadius = 45;
             [self.view addSubview:blurViewUnderSearchTableView];
             
             searchTableView = [[SearchResultTableView alloc] initWithFrame:blurViewUnderSearchTableView.bounds];
             [blurViewUnderSearchTableView addSubview:searchTableView];
         }
         else {
             blurViewUnderSearchTableView.hidden = NO;
         }
        }
     ];
    
    // 输入新的关键字
    [[[searchView.tsaoTextField rac_signalForControlEvents:UIControlEventEditingChanged] takeUntil:searchView.rac_willDeallocSignal] subscribeNext:^(UITextField *textField) {
        NSString *searchText = textField.text;
        
        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:kSearchUrl params:@{@"keyword" : searchText}];
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
        } error:^(NSError *error) {
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

/**
 *  检测是否之前选择过学校,若没选择则强制用户选择
 */
- (void)checkCampusExist{
    ChooseListModel *model = [Tool getUserDefaultByKey:@"Campus"];
    if (model == nil) {
        [self toggleCampus];    // 让用户选择学校
    }
}

/**
 *  切换学校
 */
- (void)toggleCampus{
    ASImageNode *node = [[ASImageNode alloc] init];
    node.frame = CGRectMake(0, 0, 25, 25);
    node.image = [UIImage imageNamed:@"back_button"];
    [self.view addSubview:node.view];
    
    
    UIButton *click = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 100, 50)];
    [click setTitle:@"click" forState:UIControlStateNormal];
    [self.view addSubview:click];
    [click setTitleColor:kGreenColor forState:UIControlStateNormal];

    click.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:kAPIVersion1 requestURL:kCampusUrl params:@{@"campus_city" : @"上海市"}];
    
    RACSignal *getCampusSignal = [Tool GET:url parameters:nil showNetworkError:YES];
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];

  //  [getCampusSignal subscribeNext:^(id responseObject) {
//        NSString *code = kGetResponseCode(responseObject);
//        if ([code isEqualToString:kSuccessCode]) {
//            NSArray *data = kGetResponseData(responseObject);
//            NSMutableArray *dataSource = [CampusModel objectArrayWithKeyValuesArray:data];
//            NSMutableArray *modelData = [NSMutableArray new];
//                for (int i = 0; i < dataSource.count; i++) {
//                    ChooseListModel *model = [[ChooseListModel alloc] init];
////                    model.itemDesc = [[dataSource objectAtIndex:i] campus_name];
////                    model.imageUrl = [[dataSource objectAtIndex:i] campus_logo_url];
////                    model.itemId = [[dataSource objectAtIndex:i] campus_id].stringValue;
////                    [modelData addObject:model];
//                }
//            
//                ChooseListView *listView = [[ChooseListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth *0.88, kScreenHeight * 0.68) title:@"学校" dataSource:modelData cellHeight:60];
//                __weak typeof(listView) weakListView = listView;
//                listView.completionBlock = ^(NSInteger index){
//                    [weakListView dismissPresentingPopup];
//            
//                };
//            
//                KLCPopup *popup = [KLCPopup popupWithContentView:listView showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
//                [popup show];
//        }
//    }
//     error:^(NSError *error) {
//        [hud hide:YES];
//    }
//     completed:^{
//         TsaoLog(@"completed");
//        [hud hide:YES];
//    }];
    
}

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

@end
