//
//  StoreModel.m
//  GuduMorning
//
//  Created by Macbook on 15/8/19.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "StoreModel.h"

@implementation StoreModel
+ (void)initialize{
    [self setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"products" : @"ProductModel"
                 };
    }];
}

@end
