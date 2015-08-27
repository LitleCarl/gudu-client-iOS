//
//  RealmManager.h
//  GuduMorning
//
//  Created by Macbook on 15/8/27.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RealmManager : NSObject
/**
 *  返回内存存储式realm
 *
 *  @return realm instance
 */
+ (RLMRealm *)memoryRealm;
@end
