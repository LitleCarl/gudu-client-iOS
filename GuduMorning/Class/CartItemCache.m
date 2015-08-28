//
//  CartItemCache.m
//  GuduMorning
//
//  Created by Macbook on 15/8/28.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "CartItemCache.h"

@interface CartItemCache ()
@property (nonatomic, strong) NSDictionary *cache;
@end

@implementation CartItemCache
+ (instancetype)sharedCache{
    static CartItemCache *instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[CartItemCache alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]){
        self.cache = [NSMutableDictionary new];
    }
    return self;
}

- (id)objectWithKey:(NSString *)key{
    if ([self.cache objectForKey:key]) {
        return [self.cache objectForKey:key];
    }
    else {
        return nil;
    }
}

- (void)addItem:(ProductModel *)product{
    if (product) {
        [self.cache setValue:product forKey:product.id];
    }
}

@end
