//
//  OrderItem.h
//  GuduMorning
//
//  Created by Macbook on 15/9/7.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItemModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, strong) ProductModel *product;

@property (nonatomic, copy) NSNumber *quantity;

@property (nonatomic, strong) OrderModel *order;

@property (nonatomic, strong) SpecificationModel *specification;

@property (nonatomic, copy) NSString *price_snapshot;

@end
