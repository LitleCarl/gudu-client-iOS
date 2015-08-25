//
//  GeoJSONModel.h
//  GuduMorning
//
//  Created by Macbook on 15/8/25.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeoJSONModel : NSObject

/**
 *  geo类型
 */
@property (nonatomic, copy) NSString *type;

/**
 *  坐标数组
 */
@property (nonatomic, strong) NSArray *coordinates;

@end
