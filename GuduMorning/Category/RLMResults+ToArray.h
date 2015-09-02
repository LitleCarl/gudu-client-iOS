//
//  RLMResults+ToArray.h
//  GuduMorning
//
//  Created by Macbook on 15/8/29.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Realm/Realm.h>
typedef void(^ConvertCompletionBlock)(NSMutableArray *results);
@interface RLMResults (ToArray)

/**
 *  (后台线程,async执行)将RLMResults类型转换为数组,并且执行转换完成后的block,block在main线程执行
 *
 *  @param completionBlock 转换完成后执行的代码块
 */
- (void)convertToArrayWithCompletionBlock:(ConvertCompletionBlock)completionBlock;

@end
