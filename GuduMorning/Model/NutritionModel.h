//
//  NutritionModel.h
//  GuduMorning
//
//  Created by Macbook on 15/8/21.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProductModel;
@interface NutritionModel : NSObject

/**
 *  营养元素id
 */
@property (nonatomic, copy) NSString *id;

/**
 *  能量(千焦)
 */
@property (nonatomic, copy) NSNumber *energy;

/**
 *  脂肪(克)
 */
@property (nonatomic, copy) NSNumber *fat;

/**
 *  碳水化合物(克)
 */
@property (nonatomic, copy) NSNumber *carbohydrate;

/**
 *  糖(克)
 */
@property (nonatomic, copy) NSNumber *sugar;

/**
 *  盐(毫克)
 */
@property (nonatomic, copy) NSNumber *natrium;

/**
 *  所属商品
 */
@property (nonatomic, copy) ProductModel *product;

@end
