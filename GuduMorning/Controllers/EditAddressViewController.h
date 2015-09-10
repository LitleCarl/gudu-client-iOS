//
//  EditAddressViewController.h
//  GuduMorning
//
//  Created by Macbook on 15/9/10.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kEditAddressViewControllerStoryboardId @"edit_address_view_controller_stroyboard_id"
@interface EditAddressViewController : UITableViewController

@property (nonatomic, strong) AddressModel *address;

@end
