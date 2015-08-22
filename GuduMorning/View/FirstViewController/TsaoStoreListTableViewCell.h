//
//  TsaoStoreListTableViewCell.h
//  GuduMorning
//
//  Created by Macbook on 15/8/20.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TsaoStoreListTableViewCell : UITableViewCell

/**
 *  cell对应的store模型
 */
@property (nonatomic, weak) StoreModel *store;

/**
 *  Cell高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

/**
 *  边距
 */
@property (nonatomic, assign) CGFloat padding;

/**
 *  自定义初始化方法
 *
 *  @param style           cell style
 *  @param reuseIdentifier 重用标示
 *  @param cellHeight      cell高度
 *  @param padding         cell内边距
 *
 *  @return 实例化后的对象
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(CGFloat)cellHeight padding:(CGFloat)padding;

@end
