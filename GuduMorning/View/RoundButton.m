//
//  RoundButton.m
//  GuduMorning
//
//  Created by Macbook on 15/8/27.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "RoundButton.h"
#import "MegaTheme.h"
@implementation RoundButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self= [super initWithCoder:aDecoder]) {
        
        self.titleLabel.font = [UIFont fontWithName:[MegaTheme boldFontName] size:18];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.contentEdgeInsets = UIEdgeInsetsMake(4, 20, 4, 20);
        self.titleLabel.font = [UIFont fontWithName:[MegaTheme fontName] size:12.0];
        self.backgroundColor = [UIColor colorWithRed:0.14 green:0.71 blue:0.32 alpha:1.0];
        self.layer.cornerRadius = 20;
        self.layer.borderWidth = 0;
        self.clipsToBounds = true;

    }
    return self;
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (enabled) {
        self.backgroundColor = [UIColor colorWithRed:0.14 green:0.71 blue:0.32 alpha:1.0];
    }
    else {
        self.backgroundColor = ColorFromRGB(0xbdc3c7);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
