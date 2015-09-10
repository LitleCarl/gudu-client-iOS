//
//  TsaoBorderViewForCode.m
//  GuduMorning
//
//  Created by Macbook on 15/9/7.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "TsaoBorderViewForCode.h"

@implementation TsaoBorderViewForCode
- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [[RACObserve(self, borderType) skip:1] subscribeNext:^(NSNumber *type) {
            [self drawBottomLine:[type integerValue] lineWidth:1/[[UIScreen mainScreen] scale] fillColor:kLineColor];
        }];
    }
    return self;
}

@end
