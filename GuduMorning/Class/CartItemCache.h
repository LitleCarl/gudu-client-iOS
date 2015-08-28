//
//  CartItemCache.h
//  GuduMorning
//
//  Created by Macbook on 15/8/28.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartItemCache : NSObject

+ (instancetype)sharedCache;

/**
 *  根据key返回key-value存储的value
 *
 *  @param key 存储的键
 *
 *  @return value
 */
- (id)objectWithKey:(NSString *)key;

/**
 *  添加缓存productModel模型
 *
 *  @param product 需要缓存的对象
 */
- (void)addItem:(ProductModel *)product;
@end
