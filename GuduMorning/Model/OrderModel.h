//
//  OrderModel.h
//  GuduMorning
//
//  Created by Macbook on 15/9/7.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kPayMethodWeixin @"wx"
#define kPayMethodAlipay @"alipay"

@class PaymentModel;
typedef enum : NSUInteger {
    Dead = 0 ,
    notPaid = 1,
    notDelivered = 2,
    notReceived = 3,
    notCommented = 4,
    done = 5,
} OrderStatus;

@interface OrderModel : NSObject

/**
 *  订单id
 */
@property (nonatomic, copy) NSString *id;

/**
 *  订单状态
 */
@property (nonatomic, assign) OrderStatus status;

/**
 *  关联用户
 */
@property (nonatomic, strong) UserModel *user;

/**
 *  订单价格
 */
@property (nonatomic, copy) NSString *price;

/**
 *  订单实际价格
 */
@property (nonatomic, copy) NSString *pay_price;


/**
 *  订单编号
 */
@property (nonatomic, copy) NSString *order_number;

/**
 *  送货时间
 */
@property (nonatomic, copy) NSString *delivery_time;

/**
 *  收货人
 */
@property (nonatomic, copy) NSString *receiver_name;

/**
 *  收获电话
 */
@property (nonatomic, copy) NSString *receiver_phone;

/**
 *  收货地址
 */
@property (nonatomic, copy) NSString *receiver_address;

/**
 *  所在学校
 */
@property (nonatomic, strong) CampusModel *campus;
/**
 *  关联支付信息
 */
@property (nonatomic, strong) PaymentModel *payment;

/**
 *  相关商品
 */
@property (nonatomic, strong) NSArray *order_items;

/**
 *  支付方式
 */
@property (nonatomic, copy) NSString *pay_method;

@end
