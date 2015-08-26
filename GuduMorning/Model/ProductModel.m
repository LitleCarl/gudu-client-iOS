//
//  ProductModel.m
//  GuduMorning
//
//  Created by Macbook on 15/8/21.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel
+ (void)initialize{
    [self setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"specifications" : @"SpecificationModel",
                 @"product_images" : @"ProductImageModel"
                 };
    }];
}
@end
