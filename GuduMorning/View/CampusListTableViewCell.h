//
//  CampusListTableViewCell.h
//  GuduMorning
//
//  Created by Macbook on 15/8/23.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CampusListTableViewCell : UITableViewCell
/**
 *  学校名称label
 */
@property (weak, nonatomic) IBOutlet UILabel *campusNameLabel;

/**
 *  学校地址Label
 */
@property (weak, nonatomic) IBOutlet UILabel *campusAddressLabel;

/**
 *  学校模型
 */
@property (nonatomic, weak) CampusModel *campus;

@end
