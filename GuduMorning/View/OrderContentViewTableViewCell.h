//
//  OrderContentViewTableViewCell.h
//  GuduMorning
//
//  Created by Macbook on 15/9/9.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kOrderContentCellReuseID @"order_content_cell"
@interface OrderContentViewTableViewCell : UITableViewCell
/**
 *  某个order_item
 */
@property (nonatomic, strong) OrderItemModel *order_item;
@end
