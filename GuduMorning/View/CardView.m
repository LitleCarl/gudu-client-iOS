//
//  CardView.m
//  GuduMorning
//
//  Created by Macbook on 10/31/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import "CardView.h"

@interface CardView ()
@property (assign, nonatomic) CGFloat radius;
@end

@implementation CardView

- (instancetype)init{
    if (self = [super init]) {
        self.radius = 2;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.radius = 2;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.radius = 2;
    }
    return self;
}

- (void)layoutSubviews{
    self.layer.cornerRadius = self.radius;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.radius];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowPath = shadowPath.CGPath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
