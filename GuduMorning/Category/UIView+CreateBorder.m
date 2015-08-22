//
//  UIView+CreateBorder.m
//  GuduMorning
//
//  Created by Macbook on 15/8/21.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "UIView+CreateBorder.h"

@implementation UIView (CreateBorder)

- (void)drawBottomLine:(BorderType)typeOfBorder lineWidth:(CGFloat)lineWidth fillColor:(UIColor *)color{
    CGRect frame = self.frame;
    if (0 < (TopBorder & typeOfBorder)) {
        CALayer *layer = [self generateLayer:lineWidth fillColor:color];
        CGRect layerFrame = CGRectZero;
        layerFrame.origin = CGPointZero ;
        layerFrame.size = CGSizeMake(CGRectGetWidth(frame), lineWidth);
        layer.frame = layerFrame;
        [self.layer addSublayer:layer];
    }
    if (0 < (LeftBorder & typeOfBorder)) {
        CALayer *layer = [self generateLayer:lineWidth fillColor:color];
        CGRect layerFrame = CGRectZero;
        layerFrame.origin = CGPointZero ;
        layerFrame.size = CGSizeMake(lineWidth, CGRectGetHeight(frame));
        layer.frame = layerFrame;
        [self.layer addSublayer:layer];
    }
    if (0 < (BottomBorder & typeOfBorder)) {
        CALayer *layer = [self generateLayer:lineWidth fillColor:color];
        CGRect layerFrame = CGRectZero;
        layerFrame.origin = CGPointMake(0, CGRectGetHeight(frame) - lineWidth) ;
        layerFrame.size = CGSizeMake(CGRectGetWidth(frame), lineWidth);
        layer.frame = layerFrame;
        [self.layer addSublayer:layer];
    }
    if (0 < (RightBorder & typeOfBorder)) {
        CALayer *layer = [self generateLayer:lineWidth fillColor:color];
        CGRect layerFrame = CGRectZero;
        layerFrame.origin = CGPointMake(CGRectGetWidth(frame) - lineWidth, 0) ;
        layerFrame.size = CGSizeMake(lineWidth, CGRectGetHeight(frame));
        layer.frame = layerFrame;
        [self.layer addSublayer:layer];
    }

}

- (CALayer *)generateLayer:(CGFloat)lineWidth fillColor:(UIColor *)color{
    CALayer *layer = [CALayer layer];
    layer.borderWidth = lineWidth;
    layer.borderColor = color.CGColor;
    return layer;
}

@end
