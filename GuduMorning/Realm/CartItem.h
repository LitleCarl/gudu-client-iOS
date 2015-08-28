//
//  CartItem.h
//  GuduMorning
//
//  Created by Macbook on 15/8/27.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Realm/Realm.h>

@interface CartItem : RLMObject

@property NSString *productAndSpecification;

/**
 *  产品id
 */
@property NSString *product_id;

/**
 *  规格id
 */
@property NSString *specification_id;

/**
 *  logo地址
 */
@property (nonatomic, copy) NSString *logo_filename;

/**
 *  产品数量
 */
@property NSInteger quantity;

/**
 *  产品名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  规格描述,'颜色:红'
 */
@property (nonatomic, copy) NSString *specificationBrief;

/**
 *  单价
 */
@property (nonatomic, copy) NSString *price;

/**
 *  给默认realm添加指定数量的item
 *
 *  @param product          产品
 *  @param specification_id 规格id
 *  @param mount            数量
 *  @param increase         添加
 *
 *  @return 是否增加成功
 */
+ (void)addProductToCart:(ProductModel *)product specification:(NSString *)specification_id mount:(NSInteger)mount increase:(BOOL)increase;

/**
 *  给默认realm删除指定数量的item
 *
 *  @param product       产品
 *  @param specification_id 规格id
 *  @param mount            数量
 *  @param reduce           是否减少
 */
+ (void)reduceProductToCart:(ProductModel *)product specification:(NSString *)specification_id mount:(NSInteger)mount reduce:(BOOL)reduce;

/**
 *  直接设置某个商品数量
 *
 *  @param product_id       product_id
 *  @param specification_id specification_id
 *  @param quantity         数量
 */
+ (void)setItemWithProductId:(NSString *)product_id specification_id:(NSString *)specification_id quantity:(NSInteger)quantity;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<CartItem>
RLM_ARRAY_TYPE(CartItem)
