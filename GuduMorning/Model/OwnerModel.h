//
//  OwnerModel.h
//  GuduMorning
//
//  Created by Macbook on 15/8/19.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OwnerModel : NSObject

/**
 *  店主id
 */
@property (nonatomic, copy) NSString *id;

/**
 *  商家联系人
 */
@property (nonatomic, copy) NSString *contact_name;

/**
 *  商家联系电话
 */
@property (nonatomic, copy) NSString *contact_phone;


@end
