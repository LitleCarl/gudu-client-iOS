//
//  ProductWrapperViewController.m
//  GuduMorning
//
//  Created by Macbook on 15/8/26.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "ProductWrapperViewController.h"

#import "ProductScrollViewController.h"

#import "UIViewController+CustomNavLeftItem.h"

#define kProductScrollViewControllerSegueID @"Product_Scroll_View_Segue_Id"

@interface ProductWrapperViewController ()

@end

@implementation ProductWrapperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBarItemWithColor:kDarkColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kProductScrollViewControllerSegueID]) {
        ProductScrollViewController *productScroll = [segue destinationViewController];
        productScroll.product_id = self.product_id;
    }
}


@end
