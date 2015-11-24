//
//  UserModel.h
//  GuduMorning
//
//  Created by Macbook on 15/9/2.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, copy) NSString *id;

/**
 *  手机号
 */
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, strong) NSMutableArray *addresses;

@property (nonatomic, copy) NSString *avatar;

@end
