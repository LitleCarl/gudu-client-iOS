//
//  TsaoCodeSenderButton.h
//  GuduMorning
//
//  Created by Macbook on 15/9/1.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TsaoCodeSenderButton : UIButton
/**
 *  enable时候的color,默认黑色
 */
@property UIColor *enabledColor;
/**
 *  disable时候的color,默认灰色
 */
@property UIColor *disabledColor;

/**
 *  是否在等待下一次可发送验证码的时间
 */
@property (nonatomic, assign) BOOL waiting;
@end
