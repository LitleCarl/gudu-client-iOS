//
//  CouponModel.h
//  GuduMorning
//
//  Created by Macbook on 11/6/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Unused = 1 ,
    Used = 2,
} CouponStatus;

@interface CouponModel : NSObject

/**
 *  优惠券id
 */
@property (nonatomic, copy) NSString *id;

/**
 *  优惠金额
 */
@property (nonatomic, copy) NSNumber *discount;

/**
 *  生效日期
 */
@property (nonatomic, strong) NSString *activated_date;

/**
 *  失效日期
 */
@property (nonatomic, strong) NSString *expired_date;

/**
 *  状态
 */
@property (nonatomic, assign) CouponStatus status;

/**
 *  最低消费
 */
@property (nonatomic, copy) NSNumber *least_price;

@end
