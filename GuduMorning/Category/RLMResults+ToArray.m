//
//  RLMResults+ToArray.m
//  GuduMorning
//
//  Created by Macbook on 15/8/29.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "RLMResults+ToArray.h"

@implementation RLMResults (ToArray)
- (void)convertToArrayWithCompletionBlock:(ConvertCompletionBlock)completionBlock{
      NSMutableArray *array = [NSMutableArray new];
        for (int i = 0; i < self.count; i++) {
            [array addObject:[self objectAtIndex:i]];
        }
        if (completionBlock) {
                completionBlock(array);
        }
}
@end
