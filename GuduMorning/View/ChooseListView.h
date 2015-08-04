//
//  ChooseCampusView.h
//  GuduMorning
//
//  Created by Tsao on 15/7/31.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseListModel : NSObject

/**
 *  item的id
 */
@property (nonatomic, copy) NSString *itemId;

/**
 *  文字描述,用于显示
 */
@property (nonatomic, copy) NSString *itemDesc;

/**
 *  图片路径
 */
@property (nonatomic, copy) NSString *imageUrl;

@end


@class ChooseListView;

@protocol ChooseListViewDelegate <NSObject>

- (void)chooseListViewDidSelectItem:(ChooseListView *)chooseListView atIndex:(NSInteger)index;

@end

typedef void(^ChooseListViewCompletionBlock)(NSInteger index);

@interface ChooseListView : UIView

/// 提示框标题
@property (nonatomic, copy) NSString *title;

/// 提示框默认单元格高度
@property (nonatomic, assign) CGFloat cellHeight;

/// 单元格数据
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, copy) ChooseListViewCompletionBlock completionBlock;

@property (nonatomic, assign) id<ChooseListViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title dataSource:(NSArray *)dataSource cellHeight:(CGFloat)cellHeight;

@end
