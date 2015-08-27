//
//  CartItem.m
//  GuduMorning
//
//  Created by Macbook on 15/8/27.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "CartItem.h"




@implementation CartItem
+ (void)addProductToCart:(NSString *)product_id specification:(NSString *)specification_id mount:(NSInteger)mount increase:(BOOL)increase{

    RLMRealm *realm = [RLMRealm defaultRealm];

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"product_id = %@ AND specification_id = %@",
                         product_id, specification_id];

    RLMResults *results = [[CartItem allObjects] objectsWithPredicate:pred];
    CartItem *item = [results firstObject];
    if (item) {
        [realm beginWriteTransaction];
        if (increase) {
            item.quantity += mount;
        }
        else{
            item.quantity = mount;
        }
        [CartItem createOrUpdateInDefaultRealmWithValue:item];
        [realm commitWriteTransaction];
    }
    else {
        [realm beginWriteTransaction];
        CartItem *item = [[CartItem alloc] init];
        item.product_id = product_id;
        item.specification_id = specification_id;
        item.quantity = mount;
        [CartItem createOrUpdateInDefaultRealmWithValue:item];
        [realm commitWriteTransaction];
    }
}

+ (void)reduceProductToCart:(NSString *)product_id specification:(NSString *)specification_id mount:(NSInteger)mount reduce:(BOOL)reduce{
    
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"product_id = %@ AND specification_id = %@",
                         product_id, specification_id];
    
    RLMResults *results = [[CartItem allObjects] objectsWithPredicate:pred];
    CartItem *item = [results firstObject];
    if (item) {
        [realm beginWriteTransaction];
        if (reduce) {
            item.quantity -= mount;
        }
        else{
            item.quantity = mount;
        }
        [CartItem createOrUpdateInDefaultRealmWithValue:item];
        [realm commitWriteTransaction];
    }
}

+ (NSString *)primaryKey{
    return @"product_id";
}

// Specify default values for properties
//
//+ (NSDictionary *)defaultPropertyValues
//{
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
