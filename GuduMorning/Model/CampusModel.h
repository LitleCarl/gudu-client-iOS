//
//  CampusModel.h
//  GuduMorning
//
//  Created by Tsao on 15/8/1.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CampusModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *logo_filename;

@property (nonatomic, strong) NSMutableArray *stores;

@end
