//
//  CartItem.h
//  GuduMorning
//
//  Created by Macbook on 15/8/27.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Realm/Realm.h>

@interface CartItem : RLMObject

/**
 *  产品id
 */
@property NSString *product_id;

/**
 *  规格id
 */
@property NSString *specification_id;

/**
 *  产品数量
 */
@property NSInteger quantity;

/**
 *  给默认realm添加指定数量的item
 *
 *  @param product_id       产品id
 *  @param specification_id 规格id
 *  @param mount            数量
 *  @param increase         添加
 *
 *  @return 是否增加成功
 */
+ (void)addProductToCart:(NSString *)product_id specification:(NSString *)specification_id mount:(NSInteger)mount increase:(BOOL)increase;

/**
 *  给默认realm删除指定数量的item
 *
 *  @param product_id       产品id
 *  @param specification_id 规格id
 *  @param mount            数量
 *  @param reduce           是否减少
 */
+ (void)reduceProductToCart:(NSString *)product_id specification:(NSString *)specification_id mount:(NSInteger)mount reduce:(BOOL)reduce;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<CartItem>
RLM_ARRAY_TYPE(CartItem)
