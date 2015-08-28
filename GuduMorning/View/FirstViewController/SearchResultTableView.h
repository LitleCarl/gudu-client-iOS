//
//  SearchResultTableView.h
//  GuduMorning
//
//  Created by Macbook on 15/8/21.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResultModel;

@interface SearchResultTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
/**
 *  模型类型为SearchResultModel
 */
@property (nonatomic, strong) SearchResultModel *searchResult;

/**
 *  所属ViewController
 */
@property (nonatomic, weak) UIViewController *sourceController;

@end
