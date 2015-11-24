//
//  PayResultHandlerManager.h
//  GuduMorning
//
//  Created by Macbook on 11/20/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Pingpp.h>

@protocol PayResultHandlerDelegate <NSObject>

/**
 *  处理支付结果
 *
 *  @param result 支付结果
 *  @param error  错误信息
 */
- (void)handle:(NSString *)result error:(PingppError *)error;

@end

@interface PayResultHandlerManager : NSObject
+ (instancetype)sharedManager;

@property (nonatomic, assign) id<PayResultHandlerDelegate> delegate;

/**
 *  将控制权转移给delegate
 *
 *  @param result 支付结果
 *  @param error  错误信息
 */
- (void)giveHandleToDelegate:(NSString *)result error:(PingppError *)error;

@end
