//
//  StoreIndexViewController.h
//  GuduMorning
//
//  Created by Macbook on 15/8/24.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kStoreIndexViewControllerStoryboardId @"Store_Index_View_Controller"

@interface StoreIndexViewController : UIViewController

/**
 *  店铺id,必须参数,用于查询店铺详情
 */
@property (nonatomic, copy) NSString *store_id;

@end
