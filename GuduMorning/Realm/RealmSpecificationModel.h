//
//  RealmSpecificationModel.h
//  GuduMorning
//
//  Created by Macbook on 15/8/27.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Realm/Realm.h>

@interface RealmSpecificationModel : RLMObject
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
 *  产品库存
 */
@property (nonatomic, copy) NSNumber *stock;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<RealmSpecificationModel>
RLM_ARRAY_TYPE(RealmSpecificationModel)
