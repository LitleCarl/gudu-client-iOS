//
//  PayResultViewController.h
//  GuduMorning
//
//  Created by Macbook on 11/20/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kPayResultViewControllerStoryBoardId @"kPayResultViewControllerStoryBoardId"
@interface PayResultViewController : UIViewController

/**
 *  相关订单数据
 */
@property (nonatomic, strong) OrderModel *order;

/**
 *  支付成功/失败
 */
@property (nonatomic, assign) BOOL payDone;

@end
