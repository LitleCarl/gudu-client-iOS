//
//  OrderTableViewController.h
//  GuduMorning
//
//  Created by Macbook on 15/9/7.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kOrderTableViewControllerStoryboardId @"order_table_view_storyboard_id"
typedef enum : NSUInteger {
    AllOrder = 0,
    NotPaidOrder = 1,
    NotDeliveredOrder = 2,
    NotReceivedOrder = 3,
    NotCommentedOrder = 4,
} OrderType;

@interface OrderTableViewController : UIViewController

@property (nonatomic, assign) OrderType orderType;

@end
