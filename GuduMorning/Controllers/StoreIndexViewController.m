//
//  StoreIndexViewController.m
//  GuduMorning
//
//  Created by Macbook on 15/8/24.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "StoreIndexViewController.h"

// ViewController
#import "MenuViewController.h"
#import "ProductTableViewController.h"
#import "MapEventController.h"
#define  kMapViewControllerSegue @"Map_View_Controller"
#define kMenuViewControllerSegue @"menuViewController"

@interface StoreIndexViewController () <MDTabBarViewControllerDelegate>

/**
 *  顶部的segmentcontrol,用于切换菜谱,地图,评价
 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

/**
 *  菜单segment中的MenuViewController
 */
@property (nonatomic, weak) MenuViewController *menuViewController;

/**
 *  菜单segment中的MapViewController
 */
@property (nonatomic, weak) MapEventController *mapViewController;

/**
 *  MDTabbar的items
 */
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) StoreModel *store;

/**
 *  导航栏titleLabel
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 *  菜单ContainerView
 */
@property (weak, nonatomic) IBOutlet UIView *menuContainerView;

/**
 *  地图ContainerView
 */
@property (weak, nonatomic) IBOutlet UIView *mapContainerView;

@end

@implementation StoreIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.store_id) {
        [self setUpTrigger];
        [self initBasicInfo];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  触发器,用于ui已经创建,数据后来的情况重新加载ui中的数据
 */
- (void)setUpTrigger{
    RACChannelTerminal *segmentTerminal = [self.segmentControl rac_newSelectedSegmentIndexChannelWithNilValue:@0];
    [segmentTerminal subscribeNext:^(NSNumber *index) {
        switch (index.integerValue) {
            case 0:
                self.menuContainerView.hidden = NO;
                self.mapContainerView.hidden = YES;
                break;
            case 1:
                self.menuContainerView.hidden = YES;
                self.mapContainerView.hidden = NO;
                break;
            default:
                break;
        }
    }];
}

- (void)loadDataIntoUI{
    self.titleLabel.text = self.store.name;
    NSMutableArray *products = self.store.products;
    NSArray *categories = [products valueForKeyPath:@"@distinctUnionOfObjects.category"];
    self.items = categories;
    [self.menuViewController setItems:categories];
    
    // 设置mapViewController的store
    self.mapViewController.store = self.store;
}

/**
 *  加载初始化信息，只拉取店铺简单信息
 */
- (void)initBasicInfo{
    
    NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:[kStoreFindOneUrl stringByReplacingOccurrencesOfString:@":store_id" withString:self.store_id] params:nil];

    RACSignal *signal = [Tool GET:url parameters:nil progressInView:self.view showNetworkError:YES];
    [signal subscribeNext:^(id responseObject) {
        if (kGetResponseCode(responseObject) == kSuccessCode) {
            self.store = [StoreModel objectWithKeyValues:kGetResponseData(responseObject)];
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:kMenuViewControllerSegue]) {
        MenuViewController *controller =     [segue destinationViewController];
        controller.delegate = self;
        controller.tabBar.backgroundColor = kDarkColor;
        controller.tabBar.indicatorColor = kGreenColor;
        [controller setItems:@[@"加载中..."]];
        self.menuViewController = controller;
    }
    else if ([[segue identifier] isEqualToString:kMapViewControllerSegue]) {
        self.mapViewController = [segue destinationViewController];
    }
}

#pragma mark - MDTabbarViewControllerDelegate -

- (UIViewController *)tabBarViewController:
(MDTabBarViewController *)viewController
                     viewControllerAtIndex:(NSUInteger)index{
    NSArray *products = [self.store.products filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
        return [[object category] isEqualToString: [self.items objectAtIndex:index]];
    }]];
    ProductTableViewController *tableViewController = [kMainStoryBoard instantiateViewControllerWithIdentifier:kProductTableViewControllerStoryboardId];
    tableViewController.products = products;
    
    if (index == 0) {
        @weakify(tableViewController)
        
        [[[RACObserve(self, store) skip:1] takeUntil:tableViewController_weak_.rac_willDeallocSignal] subscribeNext:^(StoreModel *store) {
            
            //更新UI中的信息
            [self loadDataIntoUI];
            NSArray *products = [self.store.products filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
                return [[object category] isEqualToString: [self.items objectAtIndex:index]];
            }]];
            tableViewController_weak_.products = products;
        }];
    }
    tableViewController.automaticallyAdjustsScrollViewInsets = NO;
      return tableViewController;
}

/**
 *  statusbar tint
 *
 *  @return <#return value description#>
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)backToPre:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
