//
//  StoreModel.h
//  GuduMorning
//
//  Created by Macbook on 15/8/19.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OwnerModel, GeoJSONModel;

@interface StoreModel : NSObject

@property (nonatomic, copy) NSString *id;

/**
 *  校名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  地址
 */
@property (nonatomic, copy) NSString *address;

/**
 *  店铺简介
 */
@property (nonatomic, copy) NSString *brief;

/**
 *  店铺logo
 */
@property (nonatomic, copy) NSString *logo_filename;

/**
 *  店铺状态
 */
@property (nonatomic, copy) NSNumber *status;

/**
 *  关联商户拥有人
 */
@property (nonatomic, strong) OwnerModel *owner;

/**
 *  商铺的商品数组
 */
@property (nonatomic, strong) NSMutableArray *products;

/**
 *  Geo类型数据
 */
@property (nonatomic, strong) GeoJSONModel *location;

/**
 *  店铺签名
 */
@property (nonatomic, copy) NSString *signature;

/**
 *  店铺月售
 */
@property (nonatomic, copy) NSString *month_sale;

/**
 *  店铺回头率
 */
@property (nonatomic, copy) NSNumber *back_ratio;

/**
 *  店铺主打菜单
 */
@property (nonatomic, copy) NSString *main_food_list;


@end
