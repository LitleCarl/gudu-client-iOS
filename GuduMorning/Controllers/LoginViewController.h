//
//  LoginViewController.h
//  GuduMorning
//
//  Created by Macbook on 15/9/1.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kLoginViewControllerStoryBoardId @"Login_View_Controller_Storyboard_id"
@interface LoginViewController : UIViewController

/**
 *  登录成功后自动dismiss
 */
@property (nonatomic, assign) BOOL needDismiss;

@end
