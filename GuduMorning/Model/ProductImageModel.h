//
//  ProductImage.h
//  GuduMorning
//
//  Created by Macbook on 15/8/26.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductImageModel : NSObject
/**
 *  图片name
 */
@property (nonatomic, copy) NSString *image_name;

/**
 *  关联商品
 */
@property (nonatomic, strong) ProductModel *product;

/**
 *  优先级
 */
@property (nonatomic, copy) NSNumber *priority;

@end
