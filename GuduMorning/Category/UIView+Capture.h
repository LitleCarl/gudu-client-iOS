//
//  UIView+Capture.h
//  GuduMorning
//
//  Created by Macbook on 15/8/21.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Capture)
/**
 *  捕捉View并返回相应UIImage对象
 *
 *  @return UIView的截图
 */
- (UIImage *)captureSelf;
@end
