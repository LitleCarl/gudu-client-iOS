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


/**
 *  检测是否包含指定规格
 *
 *  @return 包含返回yes
 */
- (BOOL)hasSpecification:(NSString *)specification_id{

    BOOL has = [self.specifications containsObject:[SpecificationModel objectWithKeyValues:@{@"id":specification_id}]];
    return has;
}

- (SpecificationModel *)specificationForSpecificationId:(NSString *)specification_id{
   __block SpecificationModel *model = nil;
    [self.specifications enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj id] isEqualToString:specification_id]) {
            model = obj;
            *stop = YES;
        }
    }];
    return model;
}

@end
