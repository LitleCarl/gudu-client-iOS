//
//  Specification.m
//  GuduMorning
//
//  Created by Macbook on 15/8/21.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "SpecificationModel.h"

@implementation SpecificationModel

- (BOOL)isEqual:(id)object{
    if (![object isKindOfClass:[SpecificationModel class]]) {
        return NO;
    }
    else if ([[self id] isEqualToString:[object id]])
        return YES;
    else {
        return NO;
    }
}
@end
