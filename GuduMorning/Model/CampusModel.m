//
//  CampusModel.m
//  GuduMorning
//
//  Created by Tsao on 15/8/1.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "CampusModel.h"

@implementation CampusModel
+ (void)initialize{
    [self setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"stores" : @"StoreModel"
                 };
    }];
}
@end
