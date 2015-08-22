//
//  TsaoBackButton.m
//  GuduMorning
//
//  Created by Tsao on 15/8/1.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "TsaoBackButton.h"

@interface TsaoBackButton ()

@property (nonatomic, weak) UIButton *backButton;

@end

@implementation TsaoBackButton

- (instancetype)initWithTitle:(NSString *)title{
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.3, kNavBarHeight - kStatusBarHeight)]) {
        self.tag = kBackButtonTag;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        self.backButton = button;
        
        button.frame = CGRectMake(0, 0, 25, 25);
        button.center = CGPointMake(button.frame.size.width * 0.5, self.frame.size.height * 0.5);
        
        [button setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        [button setTitleColor:kGreenColor forState:UIControlStateNormal];
    
        CGFloat backTitleWidth = self.frame.size.width - button.frame.size.width;
        UILabel *backTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backTitleWidth, self.frame.size.height)];
        [backTitleLabel setTextColor:kGreenColor];
        backTitleLabel.center = CGPointMake(CGRectGetMaxX(button.frame) + backTitleLabel.frame.size.width * 0.5, self.frame.size.height * 0.5);
        backTitleLabel.text = title;
        backTitleLabel.font = [UIFont fontWithName:kFontFamily size:kFontNormalSize];
        [self addSubview:backTitleLabel];
        
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action{
    [self.backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
