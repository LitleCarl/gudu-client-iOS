//
//  UserSession.m
//  GuduMorning
//
//  Created by Macbook on 15/9/2.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "UserSession.h"
#define kSessionUserDefaultKey @"user_session_key"
@implementation UserSession

+ (instancetype)sharedSession{
    static UserSession *session;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        session = [[UserSession alloc] init];
    });
    return session;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setUpTrigger];
    }
    return self;
}

- (void)setUpTrigger{
    RACChannelTerminal *sessionChangeTerminal = [[NSUserDefaults standardUserDefaults] rac_channelTerminalForKey:kSessionUserDefaultKey];
    // 双向绑定user default
    [RACObserve(self, sessionToken) subscribeNext:^(id x) {
        if (x != nil) {
            [Tool setUserDefault:@{kSessionUserDefaultKey : x}];
        }
    }];
    RAC(self, sessionToken) = [sessionChangeTerminal map:^id(NSString *token) {
        return token;
    }];
    RAC(self, isLogin) = [sessionChangeTerminal map:^id(NSString *token) {
        TsaoLog(@"登录成功：%d", token != nil);
        return [NSNumber numberWithBool:token != nil];
    }];
}



@end
