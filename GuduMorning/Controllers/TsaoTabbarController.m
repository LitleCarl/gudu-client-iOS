//
//  TsaoTabbarController.m
//  GuduMorning
//
//  Created by Tsao on 15/7/31.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "TsaoTabbarController.h"
#import "PopGestureRecognizerController.h"
#import "FirstViewController.h"
#import "CartViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"

// Session
#import "UserSession.h"
@interface TsaoTabbarController ()

@end

@implementation TsaoTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabBar.translucent = YES;
    
    self.tabBar.barTintColor = COLOR(71, 85, 94, 1);
    
    FirstViewController *first = [[FirstViewController alloc] init];
    PopGestureRecognizerController *firstNav = [[PopGestureRecognizerController alloc] initWithRootViewController:first];
    
    CartViewController *second = [kCartStoryBoard instantiateViewControllerWithIdentifier:kCartViewControllerStoryBoardId];
    PopGestureRecognizerController *secondNav = [[PopGestureRecognizerController alloc] initWithRootViewController:second];
    secondNav.navigationBarHidden = NO;
    
    MineViewController *mineController = [[MineViewController alloc] init];
    PopGestureRecognizerController *mineNav = [[PopGestureRecognizerController alloc] initWithRootViewController:mineController];

    
    self.viewControllers = @[firstNav, secondNav, mineNav];
    // Do any additional setup after loading the view.
    [self setUpTrigger];
}

- (void)setUpTrigger{
    [RACObserve([UserSession sharedSession], isLogin) subscribeNext:^(NSNumber *isLogin) {
        if (![isLogin boolValue]) {
            LoginViewController *loginViewController = [kUserStoryBoard instantiateViewControllerWithIdentifier:kLoginViewControllerStoryBoardId];
            PopGestureRecognizerController *loginController = [[PopGestureRecognizerController alloc] initWithRootViewController:loginViewController];

            self.viewControllers = @[self.viewControllers[0], self.viewControllers[1], loginController];
        }
        else {
            MineViewController *mineController = [[MineViewController alloc] init];
            PopGestureRecognizerController *mineNav = [[PopGestureRecognizerController alloc] initWithRootViewController:mineController];
            self.viewControllers = @[self.viewControllers[0], self.viewControllers[1], mineNav
                                     ];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
