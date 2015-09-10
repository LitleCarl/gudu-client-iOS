//
//  ThemeButton.m
//  GuduMorning
//
//  Created by Macbook on 15/9/7.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "ThemeButton.h"
#import "MegaTheme.h"
@implementation ThemeButton
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        UIImage* background = [[UIImage imageNamed:@"border-button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        
        UIImage* backgroundTemplate = [background imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [self setBackgroundImage:backgroundTemplate forState: UIControlStateNormal];
        
        self.titleLabel.font = [UIFont fontWithName:MegaTheme.fontName size: 11];
        self.tintColor = kWetAsphaltColor;
        
        NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kScreenWidth];
        self.maxWidthConstaint = constaint;
        [self addConstraint:constaint];
        
        RAC(self, hidden) = [[RACObserve(self.maxWidthConstaint, constant) takeUntil:self.rac_willDeallocSignal] map:^(id x) {
            return @([x floatValue] < 1);
        }];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        UIImage* background = [[UIImage imageNamed:@"border-button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        
        UIImage* backgroundTemplate = [background imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [self setBackgroundImage:backgroundTemplate forState: UIControlStateNormal];
        
        self.titleLabel.font = [UIFont fontWithName:MegaTheme.fontName size: 11];
        self.tintColor = kWetAsphaltColor;
    }
    return self;
}

@end
