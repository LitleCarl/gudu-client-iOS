//
//  RealmProductModel.m
//  GuduMorning
//
//  Created by Macbook on 15/8/27.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "RealmProductModel.h"

@implementation RealmProductModel

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}
+ (NSString *)primaryKey{
    return @"id";
}
// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
