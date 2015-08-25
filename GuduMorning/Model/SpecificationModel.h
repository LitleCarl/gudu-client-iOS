//
//  Specification.h
//  GuduMorning
//
//  Created by Macbook on 15/8/21.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProductModel;
@interface SpecificationModel : NSObject

/**
 *  规格id
 */
@property (nonatomic, copy) NSString *id;

/**
 *  规格名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  规格值
 */
@property (nonatomic, copy) NSString *value;

/**
 *  此规格价格
 */
@property (nonatomic, strong) NSDecimalNumber *price;

/**
 *  关联商品
 */
@property (nonatomic, strong) ProductModel *product;

/**
 *  产品库存
 */
@property (nonatomic, copy) NSNumber *stock;
@end
