//
//  SearchResultModel.h
//  GuduMorning
//
//  Created by Macbook on 15/8/21.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultModel : NSObject

/**
 *  搜索出的商品结果，类型为ProductModel
 */
@property (nonatomic, strong) NSMutableArray *products;

/**
 *  搜索出的店铺结果，类型为StoreModel
 */
@property (nonatomic, strong) NSMutableArray *stores;

@end
