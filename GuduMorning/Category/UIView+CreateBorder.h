//
//  UIView+CreateBorder.h
//  GuduMorning
//
//  Created by Macbook on 15/8/21.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TopBorder = 1 << 0,
    LeftBorder = 1 << 1,
    BottomBorder = 1 << 2,
    RightBorder = 1 << 3
} BorderType;

@interface UIView (CreateBorder)

/**
 *  给view画border
 *
 *  @param typeOfBorder BorderType类型,可以是组合类型，用|组合
 *  @param lineWidth    线粗大小
 *  @param color        线颜色
 */
- (void)drawBottomLine:(BorderType)typeOfBorder lineWidth:(CGFloat)lineWidth fillColor:(UIColor *)color;
@end
