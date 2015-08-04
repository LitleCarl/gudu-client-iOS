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
#import "SecondViewController.h"

@interface TsaoTabbarController ()

@end

@implementation TsaoTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabBar.translucent = NO;
    
    FirstViewController *first = [[FirstViewController alloc] init];
    first.showTsaoNavigationBar = YES;
    PopGestureRecognizerController *firstNav = [[PopGestureRecognizerController alloc] initWithRootViewController:first];
    
    SecondViewController *second = [[SecondViewController alloc] init];
    second.showTsaoNavigationBar = YES;
    PopGestureRecognizerController *secondNav = [[PopGestureRecognizerController alloc] initWithRootViewController:second];
    
    self.viewControllers = @[firstNav,secondNav];
    // Do any additional setup after loading the view.
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
