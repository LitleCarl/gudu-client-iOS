//
//  RealmProductModel.h
//  GuduMorning
//
//  Created by Macbook on 15/8/27.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Realm/Realm.h>
#import "RealmSpecificationModel.h"

@interface RealmProductModel : RLMObject

/**
 *  商品id
 */
@property (nonatomic, copy) NSString *id;

/**
 *  产品名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  产品简介
 */
@property (nonatomic, copy) NSString *brief;

/**
 *  最低价
 */
@property (nonatomic, copy) NSString *min_price;

/**
 *  最高价
 */
@property (nonatomic, copy) NSString *max_price;

/**
 *  产品分类
 */
@property (nonatomic, copy) NSString *category;

/**
 *  商品logo
 */
@property (nonatomic, copy) NSString *logo_filename;

/**
 *  类型为Specification的数组，代表着商品规格的数组
 */
@property (nonatomic, strong) RLMArray<RealmSpecificationModel> *specifications;

/**
 *   产品拼音名
 */
@property (nonatomic, copy) NSString *pinyin;

@property (nonatomic, strong) NSArray *product_images;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RealmProductModel>
RLM_ARRAY_TYPE(RealmProductModel)
