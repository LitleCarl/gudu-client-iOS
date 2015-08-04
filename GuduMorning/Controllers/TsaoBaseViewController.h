//
//  TsaoBaseViewController.h
//  GuduMorning
//
//  Created by Tsao on 15/7/31.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TsaoBaseViewController : UIViewController

/**
 *  如果为YES,则显示导航栏
 */
@property (nonatomic, assign) BOOL showTsaoNavigationBar;

/**
 *  导航栏 bar
 */
@property (nonatomic, weak) UIView *tsaoNavigationBar;

/**
 *  导航栏标题(后面push的controller将以此作为backNavTitle)
 */
@property (nonatomic, copy) NSString *tsaoNavTitle;

/**
 *  左上角返回键的标题
 */
@property (nonatomic, copy) NSString *tsaoBackNavTitle;

/**
 *  导航栏以下的view
 */
@property (nonatomic, weak) UIView *tsaoContentView;

@end
