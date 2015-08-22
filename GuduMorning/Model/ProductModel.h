//
//  ProductModel.h
//  GuduMorning
//
//  Created by Macbook on 15/8/21.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NutritionModel;

@interface ProductModel : NSObject

/**
 *  产品名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  产品简介
 */
@property (nonatomic, copy) NSString *brief;

/**
 *  商品logo
 */
@property (nonatomic, copy) NSString *logo_filename;

/**
 *  营养元素模型
 */
@property (nonatomic, strong) NutritionModel *nutrition;

/**
 *  类型为Specification的数组，代表着商品规格的数组
 */
@property (nonatomic, strong) NSMutableArray *specifications;

/**
 *   产品拼音名
 */
@property (nonatomic, copy) NSString *pinyin;

@end
