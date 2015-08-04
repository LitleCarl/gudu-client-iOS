//
//  TsaoBackButton.h
//  GuduMorning
//
//  Created by Tsao on 15/8/1.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kBackButtonTag  87432

@interface TsaoBackButton : UIView

/**
 *  初始化一个返回按钮view
 *
 *  @param title 按钮显示的文字
 *
 *  @return 新的实例
 */
- (instancetype)initWithTitle:(NSString *)title;

/**
 *  按钮点击事件
 *
 *  @param target 绑定对象
 *  @param action 执行操作
 */
- (void)addTarget:(id)target action:(SEL)action;
@end
