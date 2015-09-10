//
//  OrderModel.m
//  GuduMorning
//
//  Created by Macbook on 15/9/7.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
+ (void)initialize{
    [self setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"order_items" : @"OrderItemModel"
                 };
    }];
}

@end
