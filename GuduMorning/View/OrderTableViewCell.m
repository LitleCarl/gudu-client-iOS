//
//  OrderTableViewCell.m
//  GuduMorning
//
//  Created by Macbook on 15/9/7.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "OrderTableViewCell.h"
//View
#import "OrderContentViewTableViewCell.h"
#import "ThemeButton.h"
//View Controller
#import "ProductScrollViewController.h"

//Ping
#import <Pingpp.h>
@interface OrderTableViewCell () <UITableViewDataSource, UITableViewDelegate>
{
    /// 学校名称显示label
    __weak IBOutlet UILabel *campusNameLabel;
    /// 订单状态显示label
    __weak IBOutlet UILabel *orderStatusLabel;
    /// 共一件商品
    __weak IBOutlet UILabel *itemsAmountLabel;
    /// 实付:¥10.00
    __weak IBOutlet UILabel *totalPriceLabel;
    
    /// order item的展示列表
    __weak IBOutlet UITableView *contentTableView;
    
    /// 付款按钮
    __weak IBOutlet ThemeButton *payButton;
    __weak IBOutlet ThemeButton *waitingProductButton;
    /// 评论按钮
    __weak IBOutlet ThemeButton *commentButton;
}
@end

@implementation OrderTableViewCell

- (void)setOrder:(OrderModel *)order{
    _order = order;
    
    [self setUpTrigger];
    contentTableView.tableFooterView = [UIView new];

    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    NSString *statusMessage = nil;
    if (order.status == Dead){
        statusMessage = @"已取消";
    }
    else if (order.status == notPaid) {
        statusMessage = @"待付款";
    }
    else if (order.status == notDelivered){
        statusMessage = @"待发货";
    }
    else if (order.status == notReceived){
        statusMessage = @"待收货";
    }
    else if (order.status == notCommented){
        statusMessage = @"未评价";
    }
    else {
        statusMessage = @"交易成功";
    }
    orderStatusLabel.text = statusMessage;
    
    if (order.campus){
        campusNameLabel.text = order.campus.name;
    }
    
    // 设置商品总数
    NSString *itemCount = [NSString stringWithFormat:@"%d", (long)order.order_items.count];
    NSMutableAttributedString *attStringOfItemCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@个商品", itemCount]];
    
    [attStringOfItemCount addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:10.0]
                      range:NSMakeRange(0, attStringOfItemCount.length)];
    [attStringOfItemCount addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithWhite:0.37 alpha:1]
                      range:NSMakeRange(0, attStringOfItemCount.length)];
    [attStringOfItemCount addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:12.0]
                      range:NSMakeRange(1, attStringOfItemCount.length - 4)];//
    [attStringOfItemCount addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithWhite:0 alpha:1]
                      range:NSMakeRange(1, attStringOfItemCount.length - 4)];
    
    [itemsAmountLabel setAttributedText:attStringOfItemCount];

    // 设置付款金额
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付:¥%@", order.price]];
    
    [attString addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:10.0]
                  range:NSMakeRange(0, 3)];
    [attString addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithWhite:0.37 alpha:1]
                      range:NSMakeRange(0, 3)];
    [attString addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:12.0]
                      range:NSMakeRange(3, attString.length - 3)];//
    [attString addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithWhite:0 alpha:1]
                      range:NSMakeRange(3, attString.length - 3)];
    [totalPriceLabel setAttributedText:attString];
   
}

- (void)setUpTrigger{
    [[RACObserve(self, order) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(OrderModel *order) {
        [contentTableView reloadData];
        if (order.status > notPaid) {
            payButton.maxWidthConstaint.constant = 0;
        }
        else {
            payButton.maxWidthConstaint.constant = kScreenWidth;
        }
        if (order.status == notCommented) {
            commentButton.maxWidthConstaint.constant = kScreenWidth;
        }
        else {
            commentButton.maxWidthConstaint.constant = 0;
        }
        if (order.status == notDelivered || order.status == notReceived) {
            waitingProductButton.maxWidthConstaint.constant = kScreenWidth;
        }
        else {
            waitingProductButton.maxWidthConstaint.constant = 0;
        }
    }];
    
    [[payButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:kPayOrderUrl params:nil];
        NSDictionary *param = @{@"order" : [self.order keyValues]};
        RACSignal *signal = [Tool POST:url parameters:param progressInView:kKeyWindow showNetworkError:YES];
        [signal subscribeNext:^(id responseObject) {
            TsaoLog(@"responseObject:%@", responseObject);
            if (kGetResponseCode(responseObject) == kSuccessCode){
                // 创建成功
                /**
                 *  删除购物车商品
                 */
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                [realm deleteObjects:[CartItem allObjects]];
                [realm commitWriteTransaction];
                
                id charge = kGetResponseData(responseObject);
                [Pingpp createPayment:charge
                       viewController:nil
                         appURLScheme:kUrlScheme
                       withCompletion:^(NSString *result, PingppError *error) {
                           if ([result isEqualToString:@"success"]) {
                               TsaoLog(@"支付成功!!");
                               // 支付成功
                           } else {
                               // 支付失败或取消
                               NSLog(@"!!Error: code=%lu msg=%@", error.code, [error getMsg]);
                           }
                       }];
            }
        }];
        
//        [Pingpp createPayment:charge
//               viewController:self
//                 appURLScheme:kUrlScheme
//               withCompletion:^(NSString *result, PingppError *error) {
//                   if ([result isEqualToString:@"success"]) {
//                       TsaoLog(@"支付成功!!");
//                       // 支付成功
//                   } else {
//                       // 支付失败或取消
//                       NSLog(@"!!Error: code=%lu msg=%@", error.code, [error getMsg]);
//                   }
//               }];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *product_id = [[[self.order.order_items objectAtIndex:indexPath.row] product] id];
    ProductScrollViewController *controller = [kMainStoryBoard instantiateViewControllerWithIdentifier:kProductViewControllerStoryboardId];
    controller.product_id = product_id;
    if (self.cellOwnerController){
        [self.cellOwnerController.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.order.order_items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderContentViewTableViewCell *orderContentViewCell = [tableView dequeueReusableCellWithIdentifier:kOrderContentCellReuseID];
    orderContentViewCell.order_item = [self.order.order_items objectAtIndex:indexPath.row];
    return orderContentViewCell;
}

@end
