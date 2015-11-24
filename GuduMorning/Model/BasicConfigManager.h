//
//  DeliveryTimeManager.h
//  GuduMorning
//
//  Created by Macbook on 15/9/5.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayMethodModel : NSObject

/**
 *  支付方式名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  支付方式代号
 */
@property (nonatomic, copy) NSString *code;

@end

@interface BasicConfigManager : NSObject

+ (instancetype)sharedDeliveryTimeManager;

/**
 *  可用的送货时间
 */
@property (nonatomic, strong) NSArray *deliveryTimeSet;

/**
 *  可用的支付方式
 */
@property (nonatomic, strong) NSArray *payMethodSet;

/**
 *  红包启用
 */
@property (nonatomic, assign) BOOL red_pack_available;

@end
