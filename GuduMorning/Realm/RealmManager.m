//
//  RealmManager.m
//  GuduMorning
//
//  Created by Macbook on 15/8/27.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "RealmManager.h"
#import <Realm/Realm.h>

@implementation RealmManager
+ (RLMRealm *)memoryRealm{
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.inMemoryIdentifier = @"MyInMemoryRealm";
    NSError *error;
    RLMRealm *realm = [RLMRealm realmWithConfiguration:config error:&error];
    return realm;
}

@end
