//
//  AddressModel.h
//  GuduMorning
//
//  Created by Macbook on 15/9/5.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, strong) UserModel *user;

@end
