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
#import "PayResultHandlerManager.h"
//Ping
#import <Pingpp.h>
@interface OrderTableViewCell () <UITableViewDataSource, UITableViewDelegate, PayResultHandlerDelegate>
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
    
    /// 订单成交时间(未支付订单隐藏)
    __weak IBOutlet UILabel *timePaidLabel;
    /// 订单编号按钮
    __weak IBOutlet UILabel *orderNumberLabel;
    
    /// 收货人地址
    __weak IBOutlet UILabel *receiverAddressLabel;
    
    /// 收货人电话
    __weak IBOutlet UILabel *receiverPhoneLabel;
    
    // 支付方式图标
    __weak IBOutlet UIImageView *payChannelImageView;
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
    NSString *itemCount = [NSString stringWithFormat:@"%lu", (unsigned long)order.order_items.count];
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
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付:¥%@", order.pay_price]];
    
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
   
    receiverAddressLabel.text = order.receiver_address;
    [receiverAddressLabel sizeToFit];
    receiverPhoneLabel.text = order.receiver_phone;
    [receiverPhoneLabel sizeToFit];
    
    if ([order.pay_method isEqualToString:kPayMethodWeixin]) {
        payChannelImageView.image = [UIImage imageNamed:@"pay_weixin"];
        payChannelImageView.hidden = NO;

    }
    else if([order.pay_method isEqualToString:kPayMethodAlipay]){
        payChannelImageView.image = [UIImage imageNamed:@"pay_ali"];
        payChannelImageView.hidden = NO;
    }
    else {
        payChannelImageView.hidden = YES;
    }

}

- (void)setUpTrigger{
    [[RACObserve(self, order) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(OrderModel *order) {
        [contentTableView reloadData];
        
        // 订单编号
        orderNumberLabel.text = [NSString stringWithFormat:@"订单编号:%@", self.order.order_number];
        
        // 成交时间
        if (self.order.payment) {
            timePaidLabel.text = [NSString stringWithFormat:@"成交时间:%@", self.order.payment.time_paid];
            timePaidLabel.hidden = NO;
        }
        else {
            timePaidLabel.hidden = YES;
        }
        
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
    
    [[[payButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:[kPayOrderUrl stringByReplacingOccurrencesOfString:@":order_id" withString:self.order.id] params:nil];
        RACSignal *signal = [Tool GET:url parameters:nil progressInView:kKeyWindow showNetworkError:YES];
        [signal subscribeNext:^(id responseObject) {
            if (kGetResponseCode(responseObject) == kSuccessCode){
                id data = kGetResponseData(responseObject);
                                
                id charge = [data objectForKey:@"charge"];
                [PayResultHandlerManager sharedManager].delegate = self;

                [Pingpp createPayment:charge
                       viewController:nil
                         appURLScheme:kUrlScheme
                       withCompletion:^(NSString *result, PingppError *error) {
                      
                       }];
            }
        }];
        

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

#pragma mark - PayResultHandlerDelegate -

- (void)handle:(NSString *)result error:(PingppError *)error{
    if ([result isEqualToString:@"success"]) {
        [MBProgressHUD bwm_showTitle:@"支付成功" toView:kKeyWindow hideAfter:2.0 msgType:BWMMBProgressHUDMsgTypeSuccessful];
    }
    else{
        [MBProgressHUD bwm_showTitle:@"支付失败" toView:kKeyWindow hideAfter:2.0 msgType:BWMMBProgressHUDMsgTypeSuccessful];
    }
}

@end
