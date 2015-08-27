//
//  ADVProgressLayer.m
//  Mega
//
//  Created by Sergey on 2/4/15.
//  Copyright (c) 2015 Sergey. All rights reserved.
//

#import "ADVProgressLayer.h"

@implementation ADVProgressLayer


-(CABasicAnimation*) makeAnimationForKey:(NSString*)key
{
    
    CABasicAnimation*  animation = [CABasicAnimation animationWithKeyPath:key];
    animation.fromValue = [self.presentationLayer valueForKey:key];
    
    animation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.duration = 1.5;
    
    return animation;
    
}

-(id<CAAction>)actionForKey:(NSString *)event
{
    
    if ([event isEqualToString:@"progress"] && self.presentationLayer != nil) {
        return [self makeAnimationForKey:event];
    }
    
    return [super actionForKey:event];
}

+(BOOL)needsDisplayForKey:(NSString *)key
{
    
    if ([key isEqualToString:@"progress"] || [key isEqualToString:@"gradientStart"] || [key isEqualToString:@"gradientEnd"] || [key isEqualToString:@"strokeWidth"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

-(void)drawInContext:(CGContextRef)context
{
    
    float radius = MIN(self.bounds.size.width, self.bounds.size.height)/2.0;
    
    radius -= (self.strokeWidth/2);
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
//    CGFloat arc = M_PI * 2.0;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    CGContextRef imageCtx = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(imageCtx, width/2, height/2, radius, 0,[self toRadians:self.progress*360], 0);
    
    [UIColor.redColor set];
    
    CGContextSetLineWidth(imageCtx, self.strokeWidth);
    CGContextDrawPath(imageCtx, kCGPathStroke);
    
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, self.bounds, mask);
    
    NSArray* arrComponents = [self getAllComponents];

    CGFloat components[arrComponents.count];
    
    for (int i = 0; i < arrComponents.count; i++) {
        components[i] = [arrComponents[i] floatValue];
    }
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, components, nil, 2);
    
    CGRect rect = self.bounds;
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGContextRestoreGState(context);
    
}
-(CGFloat)toRadians:(CGFloat)angleToConvert
{
    return (M_PI * angleToConvert) / 180.0;
}

-(NSArray*)getAllComponents
{
    
    NSMutableArray* components = [NSMutableArray arrayWithArray:[self getComponentsFromColor:self.gradientStart]];
    [components addObjectsFromArray:[self getComponentsFromColor:self.gradientEnd]];
    
    return components;
    
}


-(NSArray*)getComponentsFromColor:(UIColor*)color
{
    
    size_t count = CGColorGetNumberOfComponents(color.CGColor);
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    
    if (count == 2) {
        
        return @[[NSNumber numberWithFloat:components[0]],[NSNumber numberWithFloat:components[0]],[NSNumber numberWithFloat: components[0]], [NSNumber numberWithFloat:components[1]]];
        
    }else{
        return @[[NSNumber numberWithFloat:components[0]],[NSNumber numberWithFloat:components[1]], [NSNumber numberWithFloat:components[2]], [NSNumber numberWithFloat:components[3]]];
    }
}


@end
