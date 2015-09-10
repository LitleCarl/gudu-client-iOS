//
//  AppDelegate.m
//  GuduMorning
//
//  Created by Tsao on 15/7/31.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "AppDelegate.h"
#import "TsaoTabbarController.h"
#import <Pingpp.h>
@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self customizeUIAppearance];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [Pingpp handleOpenURL:url
           withCompletion:^(NSString *result, PingppError *error) {
               if ([result isEqualToString:@"success"]) {
                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付成功" message:@"" delegate:self cancelButtonTitle:@"" otherButtonTitles:@"查看订单", nil];
                   [alert show];
                  [[NSNotificationCenter defaultCenter] postNotificationName:kPaymentDone object:nil userInfo:@{@"result": @YES}];
               } else {
                   // 支付失败或取消
                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付失败" message:@"" delegate:self cancelButtonTitle:@"" otherButtonTitles:@"好的", nil];
                   [alert show];
                   NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
                   [[NSNotificationCenter defaultCenter] postNotificationName:kPaymentDone object:nil userInfo:@{@"result": @NO}];
               }
           }];
    return  YES;
}

/**
 *  定制ui
 */
- (void)customizeUIAppearance{

    [[UINavigationBar appearance] setTintColor:kWetAsphaltColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}
                                             forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kGreenColor}
                                             forState:UIControlStateSelected];

}

@end
