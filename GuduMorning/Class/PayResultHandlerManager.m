//
//  PayResultHandlerManager.m
//  GuduMorning
//
//  Created by Macbook on 11/20/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import "PayResultHandlerManager.h"

@implementation PayResultHandlerManager

+ (instancetype)sharedManager{
    static PayResultHandlerManager *manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[PayResultHandlerManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)giveHandleToDelegate:(NSString *)result error:(PingppError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handle:error:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate handle:result error:error];
        });
    }
}

@end
