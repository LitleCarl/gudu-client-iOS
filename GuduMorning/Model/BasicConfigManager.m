//
//  DeliveryTimeManager.m
//  GuduMorning
//
//  Created by Macbook on 15/9/5.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "BasicConfigManager.h"

@implementation PayMethodModel
@end

@interface BasicConfigManager ()
@end

@implementation BasicConfigManager

+ (instancetype)sharedDeliveryTimeManager{
    static dispatch_once_t token;
    static BasicConfigManager *instance;
    dispatch_once(&token, ^{
        instance = [[BasicConfigManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        [self loadConfig];
    }
    return self;
}

- (void)loadConfig{
        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:kBasicConfig params:nil];
        RACSignal *signal = [Tool GET:url parameters:nil progressInView:nil showNetworkError:NO];
        
        [signal subscribeNext:^(id responseObject) {
            if (kGetResponseCode(responseObject) == kSuccessCode) {
                self.deliveryTimeSet = [kGetResponseData(responseObject) objectForKey:@"availableDeliveryTime"];
                self.payMethodSet = [PayMethodModel objectArrayWithKeyValuesArray:[kGetResponseData(responseObject) objectForKey:@"availablePayMethod"]];
            }
            else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self loadConfig];
                });
            }
        } error:^(NSError *error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self loadConfig];
            });
        }];
}

@end
