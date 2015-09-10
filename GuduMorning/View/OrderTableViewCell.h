//
//  OrderTableViewCell.h
//  GuduMorning
//
//  Created by Macbook on 15/9/7.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell

/**
 *  用于在cell被点击后跳转响应产品界面
 */
@property (nonatomic, assign) UIViewController *cellOwnerController;

/**
 *  关联的订单
 */
@property (nonatomic, weak) OrderModel *order;
@end
