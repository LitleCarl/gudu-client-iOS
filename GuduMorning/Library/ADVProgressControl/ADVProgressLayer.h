//
//  ADVProgressLayer.h
//  Mega
//
//  Created by Sergey on 2/4/15.
//  Copyright (c) 2015 Sergey. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface ADVProgressLayer : CALayer

@property(nonatomic) CGFloat strokeWidth;
@property(nonatomic, strong) UIColor* gradientStart;
@property(nonatomic, strong) UIColor* gradientEnd;
@property(nonatomic) CGFloat progress;

@end
