//
//  PopGestureRecognizerController.m
//  Shops-iPhone
//
//  Created by atyun on 14-10-31.
//  Copyright (c) 2014年 net.atyun. All rights reserved.
//

#import "PopGestureRecognizerController.h"
#import "CustomPopTransition.h"

#define kDismember 0.318

@interface PopGestureRecognizerController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

/// 视图控制器之间过渡交互对象
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@property (nonatomic, assign) BOOL gestureEnabled;

@end

@implementation PopGestureRecognizerController

- (void)setPopGestureEnabled:(BOOL)enabled
{
    self.gestureEnabled = enabled;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    NSUInteger count = self.viewControllers.count;
    
    //除了NavigationController根控制器，其他全部隐藏tabbar
    if (count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    
//    if (count > 0 && [[self.viewControllers objectAtIndex:count-1] isKindOfClass:[TsaoBaseViewController class]] && [viewController isKindOfClass:[TsaoBaseViewController class]]){
//        TsaoBaseViewController *fromController = [self.viewControllers objectAtIndex:count - 1];
//        TsaoBaseViewController *toController = (TsaoBaseViewController *)viewController;
//        toController.tsaoBackNavTitle = fromController.tsaoNavTitle;
//
//    }

    
    [super pushViewController:viewController animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationBar.hidden = YES;
    
    self.gestureEnabled = YES;
    
    __weak PopGestureRecognizerController *weakSelf = self;
    
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] ) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.interactivePopGestureRecognizer.enabled = NO;
        
        UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
        popRecognizer.delegate = self;
        [self.view addGestureRecognizer:popRecognizer];
        self.delegate = self;
    }
}

/**
 *  左滑返回手势的处理方法。
 *
 *  @param recognizer 对应的滑动手势对象
 */
- (void)handlePopRecognizer:(UIPanGestureRecognizer*)recognizer
{
//    // 如果手势在导航栏 则不处理
//    if ([recognizer locationInView:self.view].y <= 64) return;
    
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        TsaoLog(@"began");
        // Create a interactive transition and pop the view controller
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        TsaoLog(@"changed");
        // Update the interactive transition's progress
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        TsaoLog(@"ended/cancelled");
        // Finish or cancel the interactive transition
        if (progress > kDismember) {
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        self.interactivePopTransition = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIGestureRecognizerDelegate -

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1 || self.gestureEnabled == NO) {
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark - UINavigationControllerDelegate -

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    CustomPopTransition *context = [[CustomPopTransition alloc] init];
    
    if (operation == UINavigationControllerOperationPop) {
        context.reverse = YES;
    }
    
    return context;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactivePopTransition;
}

# pragma mark - 状态栏文字颜色 -

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if ([[self.viewControllers lastObject] respondsToSelector:@selector(preferredStatusBarStyle)]){
        return [[self.viewControllers lastObject] preferredStatusBarStyle];
    }
    else {
        return UIStatusBarStyleDefault;
    }
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
