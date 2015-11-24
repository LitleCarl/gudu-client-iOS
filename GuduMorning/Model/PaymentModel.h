//
//  PaymentModel.h
//  GuduMorning
//
//  Created by Macbook on 15/9/7.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentModel : NSObject

/**
 *  支付信息id
 */
@property (nonatomic, copy) NSString *id;

/**
 *  支付方式
 */
@property (nonatomic, copy) NSString *payment_method;

/**
 *  支付时间
 */
@property (nonatomic, strong) NSString *time_paid;

/**
 *  关联订单
 */
@property (nonatomic, strong) OrderModel *order;

/**
 *  支付的价格
 */
@property (nonatomic, copy) NSString *amount;

/**
 *  交易号
 */
@property (nonatomic, copy) NSString *transaction_no;

/**
 *  charge id
 */
@property (nonatomic, copy) NSString *charge_id;

@end
