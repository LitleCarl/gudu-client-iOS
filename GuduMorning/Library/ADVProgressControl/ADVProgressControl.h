//
//  ADVProgressControl.h
//  Mega
//
//  Created by Sergey on 2/4/15.
//  Copyright (c) 2015 Sergey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADVProgressLayer.h"

IB_DESIGNABLE
@interface ADVProgressControl : UIControl

@property(nonatomic, strong) UILabel* label;
@property(nonatomic, strong) ADVProgressLayer* progressLayer;

@property(nonatomic, strong) NSLayoutConstraint* labelConstraintTop;
@property(nonatomic, strong) NSLayoutConstraint* labelConstraintBottom;
@property(nonatomic, strong) NSLayoutConstraint* labelConstraintLeft;
@property(nonatomic, strong) NSLayoutConstraint* labelConstraintRight;

@property(nonatomic) IBInspectable CGFloat strokeWidth ;

@property(nonatomic) IBInspectable CGFloat progress;

@property(nonatomic,strong) IBInspectable UIColor* gradientStart;

@property(nonatomic, strong) IBInspectable UIColor* gradientEnd;

@property(nonatomic, strong) IBInspectable UIFont* labelFont;

@property(nonatomic, strong) IBInspectable UIColor* labelTextColor;

@property(nonatomic, strong) IBInspectable NSString* labelText;

@end
