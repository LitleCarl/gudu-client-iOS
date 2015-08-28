//
//  CartItem.m
//  GuduMorning
//
//  Created by Macbook on 15/8/27.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "CartItem.h"

#import "CartItemCache.h"

@implementation CartItem
+ (void)addProductToCart:(ProductModel *)product specification:(NSString *)specification_id mount:(NSInteger)mount increase:(BOOL)increase{
        
    RLMRealm *realm = [RLMRealm defaultRealm];

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"productAndSpecification = %@",
                         [NSString stringWithFormat:@"%@-%@", product.id, specification_id]];

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
        
        SpecificationModel *selectSpecification = [product specificationForSpecificationId:specification_id];
        [realm beginWriteTransaction];
        CartItem *item = [[CartItem alloc] init];
        item.productAndSpecification = [NSString stringWithFormat:@"%@-%@", product.id, specification_id];
        item.product_id = product.id;
        item.specification_id = specification_id;
        item.quantity = mount;
        item.name = product.name;
        item.logo_filename = product.logo_filename;
        item.specificationBrief = [NSString stringWithFormat:@"%@: %@",selectSpecification.name, selectSpecification.value];
        item.price = selectSpecification.price.stringValue;
        [CartItem createOrUpdateInDefaultRealmWithValue:item];
        [realm commitWriteTransaction];
    }
}

+ (void)reduceProductToCart:(ProductModel *)product specification:(NSString *)specification_id mount:(NSInteger)mount reduce:(BOOL)reduce{
    
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"productAndSpecification = %@",
                         [NSString stringWithFormat:@"%@-%@", product.id, specification_id]];
    
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
        if (item.quantity <= 0) {
            [realm deleteObject:item];
        }
        else{
            [CartItem createOrUpdateInDefaultRealmWithValue:item];
        }
        [realm commitWriteTransaction];
    }
}

+ (void)setItemWithProductId:(NSString *)product_id specification_id:(NSString *)specification_id quantity:(NSInteger)quantity{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"productAndSpecification = %@",
                         [NSString stringWithFormat:@"%@-%@", product_id, specification_id]];
    
    RLMResults *results = [[CartItem allObjects] objectsWithPredicate:pred];
    CartItem *item = [results firstObject];
    if (item) {
        [realm beginWriteTransaction];
        item.quantity = quantity;
        if (item.quantity <= 0) {
            [realm deleteObject:item];
        }
        else{
            [CartItem createOrUpdateInDefaultRealmWithValue:item];
        }
        [realm commitWriteTransaction];
    }
}

+ (NSString *)primaryKey{
    return @"productAndSpecification";
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
