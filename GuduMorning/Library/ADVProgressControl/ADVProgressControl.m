//
//  ADVProgressControl.m
//  Mega
//
//  Created by Sergey on 2/4/15.
//  Copyright (c) 2015 Sergey. All rights reserved.
//

#import "ADVProgressControl.h"
#import "MegaTheme.h"
@implementation ADVProgressControl


-(instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupView];

    }
    
    return self;
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self setupView];
        
    }
    
    return self;
}


-(void)setStrokeWidth:(CGFloat)strokeWidth
{
    _strokeWidth = strokeWidth;
    _progressLayer.strokeWidth = strokeWidth;
    [_progressLayer setNeedsDisplay];
    
}

-(void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _progressLayer.progress = progress;
    [_progressLayer setNeedsDisplay];
    
    
}

-(void)setGradientStart:(UIColor *)gradientStart
{
    
    _gradientStart = gradientStart;
    _progressLayer.gradientStart = gradientStart;
    [_progressLayer setNeedsDisplay];
    
}

-(void)setGradientEnd:(UIColor *)gradientEnd
{
    _gradientEnd = gradientEnd;
    _progressLayer.gradientEnd = gradientEnd;
    [_progressLayer setNeedsDisplay];
    
}
-(void)setLabelFont:(UIFont *)labelFont
{
    
    _labelFont = labelFont;
    
    _label.font = labelFont;
    
}

-(void)setLabelTextColor:(UIColor *)labelTextColor
{
    _labelTextColor = labelTextColor;
    _label.textColor = labelTextColor;
}

-(void)setLabelText:(NSString *)labelText
{
    _labelText = labelText;
    
    _label.text = labelText;
    
}

-(void)setupView
{
    
    
    self.label = [[UILabel alloc] init];
    self.progressLayer = [[ADVProgressLayer alloc] init];
    self.strokeWidth = 15;
    self.progress = 0.75;
    self.gradientStart = UIColor.blackColor;
    self.gradientEnd = UIColor.whiteColor;
    self.labelFont = [UIFont fontWithName:[MegaTheme semiBoldFontName] size:14];
    self.labelTextColor = UIColor.lightGrayColor;
    self.labelText = @"STATS 2015";
    
    [self.layer addSublayer:self.progressLayer];
    [self.progressLayer setNeedsDisplay];
    
    self.backgroundColor = UIColor.clearColor;
    
    self.label.numberOfLines = 0;
    [self.label setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.label.backgroundColor = UIColor.clearColor;
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    
    CGFloat spacing = self.strokeWidth + (self.strokeWidth/2);
    

    self.labelConstraintTop = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeTop multiplier: 1.0 constant: spacing];
    
    self.labelConstraintBottom = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier: 1.0 constant: -spacing];
    
    self.labelConstraintLeft = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeLeft multiplier: 1.0 constant: spacing];
    
    self.labelConstraintRight = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeRight multiplier: 1.0 constant: -spacing];
    
    [self addConstraints:@[self.labelConstraintTop, self.labelConstraintBottom, self.labelConstraintLeft, self.labelConstraintRight]];
}

-(void)updateProgress
{
    self.progressLayer.progress = self.progress;
    [self.progressLayer setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    
    self.progressLayer.frame = rect;
    
    self.label.font = self.labelFont;
    self.label.text = self.labelText;
    self.label.textColor = self.labelTextColor;
    
    CGFloat spacing = self.strokeWidth + (self.strokeWidth/2);
    self.labelConstraintTop.constant = spacing;
    self.labelConstraintBottom.constant = -spacing;
    self.labelConstraintLeft.constant = spacing;
    self.labelConstraintRight.constant = -spacing;
    
}

@end
