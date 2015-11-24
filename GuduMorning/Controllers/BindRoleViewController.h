//
//  BindRoleViewController.h
//  GuduMorning
//
//  Created by Macbook on 11/13/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBindRolleViewControllerStoryBoardId @"kBindRolleViewControllerStoryBoardId"

@interface BindRoleViewController : UIViewController

/**
 *  rails服务器返回的authorization模型,用于绑定的时候作为参数
 */
@property (nonatomic, strong) id authorization;

@end
