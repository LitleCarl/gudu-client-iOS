//
//  OrderTableViewController.m
//  GuduMorning
//
//  Created by Macbook on 15/9/7.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "OrderTableViewController.h"

// Category
#import "UIView+CreateBorder.h"
#import "MegaTheme.h"
// View
#import "OrderTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"
static NSString *cellReuseId = @"order_cell_reuse_id";

@interface OrderTableViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
{
    __weak IBOutlet UIButton *allOrderButton;

    __weak IBOutlet UIButton *notPaidOrderButton;
    __weak IBOutlet UIButton *notDeliveredOrderButton;
    __weak IBOutlet UIButton *notReceivedOrderButton;
    __weak IBOutlet UIButton *notCommentedOrderButton;
    __weak IBOutlet NSLayoutConstraint *indicatorLeadingContraint;
    __weak IBOutlet UIView *indicatorView;
    __weak IBOutlet UIView *tabView;
    
    /// 订单tableView
    __weak IBOutlet UITableView *orderTableView;
}

/**
 *  当前页
 */
@property (nonatomic, assign) NSInteger page;
/**
 *  当前页显示数量
 */
@property (nonatomic, assign) NSInteger limit;
/**
 *  显示的order数据源
 */
@property (nonatomic, strong) NSMutableArray *orderList;

@end

@implementation OrderTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initUI];
    [self setUpTrigger];
}

- (void)initUI{
    self.title = @"订单";
    orderTableView.emptyDataSetDelegate = self;
    orderTableView.emptyDataSetSource = self;
    orderTableView.tableFooterView = [UIView new];
    [tabView drawBottomLine:BottomBorder lineWidth:1/[[UIScreen mainScreen] scale] fillColor:kLineColor];
    orderTableView.backgroundColor = ColorFromRGB(0xeeeeee);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

/**
 *  重新拉取数据
 */
- (void)fetchData:(BOOL) loadMore{
    
    if (loadMore == NO) {
        self.page = 0;
    }
    
    NSNumber *order_status = nil;
    if (self.orderType == AllOrder) {
        order_status = nil;
    }
    else if (self.orderType == NotPaidOrder){
        order_status = @(notPaid);
    }
    else if (self.orderType == NotDeliveredOrder){
        order_status = @(notDelivered);
    }
    else if (self.orderType == NotReceivedOrder){
        order_status = @(notReceived);
    }
    else if (self.orderType == NotCommentedOrder){
        order_status = @(notCommented);
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                 @"page": @(self.page + 1),
                                                                                 @"limit": @(self.limit)
                                                                                 }];;
    if (order_status != nil) {
        [param setValue:order_status forKey:@"status"];
    }
    NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:kGetOrdersUrl params:param];
    RACSignal *signal = [Tool GET:url parameters:nil progressInView:self.view showNetworkError:YES];
    [signal subscribeNext:^(id responseObject) {
        if (kGetResponseCode(responseObject) == kSuccessCode) {
            NSDictionary *data = kGetResponseData(responseObject);
           NSMutableArray *newOrderList  = [OrderModel objectArrayWithKeyValuesArray:[data objectForKey:@"orders"]];
            self.page = [[data objectForKey:@"page"] integerValue];

            if (loadMore) {
                [self.orderList addObjectsFromArray:newOrderList];
                [orderTableView reloadData];
                [orderTableView.footer endRefreshing];

            }else{
                
                self.orderList = newOrderList;
                TsaoLog(@"新数据的数量:%lu", (unsigned long)self.orderList.count);
                [orderTableView.header endRefreshing];

            }

        }
    }];
}

- (void)setUpTrigger{
    
    self.page = 0;
    self.limit = 10;
    
    MJRefreshNormalHeader *gifHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchData:NO];
    }];
//    //设置普通状态的动画图片
//    NSMutableArray *idleImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i<=60; ++i) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd",i]];
//        [idleImages addObject:image];
//    }
    orderTableView.header = gifHeader;
    //[gifHeader setImages:idleImages forState:MJRefreshStateIdle];

    orderTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self fetchData:YES];
    }];
    
    [RACObserve(self, orderType) subscribeNext:^(NSNumber *type) {
        [@[allOrderButton, notPaidOrderButton, notDeliveredOrderButton, notReceivedOrderButton, notCommentedOrderButton] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj setTitleColor:kMidNightBlue forState:UIControlStateNormal];
        }];
        
        CGFloat indicatorOffset = kScreenWidth / 5 *type.integerValue + kScreenWidth * 0.2 * 0.1;
        
        if ([type integerValue] == AllOrder) {
            [allOrderButton setTitleColor:kGreenColor forState:UIControlStateNormal];
        }
        else if ([type integerValue] == NotPaidOrder) {
            [notPaidOrderButton setTitleColor:kGreenColor forState:UIControlStateNormal];
        }
        else if ([type integerValue] == NotDeliveredOrder) {
            [notDeliveredOrderButton setTitleColor:kGreenColor forState:UIControlStateNormal];
        }
        else if ([type integerValue] == NotReceivedOrder) {
            [notReceivedOrderButton setTitleColor:kGreenColor forState:UIControlStateNormal];
        }
        else if ([type integerValue] == NotCommentedOrder) {
            [notCommentedOrderButton setTitleColor:kGreenColor forState:UIControlStateNormal];
        }
        
        indicatorLeadingContraint.constant = indicatorOffset;
        
        [self fetchData: NO];
    }];
    
    [[RACObserve(indicatorLeadingContraint, constant) skip:1] subscribeNext:^(id x) {
        [UIView animateWithDuration:0.22 animations:^{
            [indicatorView layoutIfNeeded];
        }];
    }];
    
    // 监听数据源的变化并重新加载数据
    [[RACObserve(self, orderList) skip:1] subscribeNext:^(id x) {
        [orderTableView reloadData];
        TsaoLog(@"列表刷新了");
    }];
    
}


/**
 *  tab按钮点击后的触发事件
 *
 *  @param sender 点击的按钮
 */
- (IBAction)tabButtonSelected:(UIButton *)sender {
    self.orderType = sender.tag;
}


#pragma mark - UITableViewDataSource -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
    cell.order = [self.orderList objectAtIndex:indexPath.row];
    cell.cellOwnerController = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderList.count;
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *order = [self.orderList objectAtIndex:indexPath.row];
    return 151 + 70 * order.order_items.count + 88;
}

#pragma mark - DZNEmptyDataSource -

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:[MegaTheme fontName] size:11.0]};
    
    return [[NSAttributedString alloc] initWithString:@"重新加载" attributes:attributes];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有订单记录";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

/**
 *  重新加载按钮被点击
 *
 *  @param scrollView scrollview
 */
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [self fetchData:NO];
}

@end
