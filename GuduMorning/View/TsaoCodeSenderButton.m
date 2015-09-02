//
//  TsaoCodeSenderButton.m
//  GuduMorning
//
//  Created by Macbook on 15/9/1.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "TsaoCodeSenderButton.h"

@implementation TsaoCodeSenderButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        self.enabledColor = kRedColor;
        self.disabledColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        
        RAC(self, backgroundColor) = [[RACObserve(self, enabled) takeUntil:self.rac_willDeallocSignal] map:^id(NSNumber *enabled) {
            if (enabled.boolValue) {
                return self.enabledColor;
            }
            else {
                return self.disabledColor;
            }
        }];
        
        RAC(self, enabled) = [[RACObserve(self, waiting) skip:1] map:^id(NSNumber *waiting) {
//            if (!waiting.boolValue) {
//                [self setTitle:@"验证码" forState:UIControlStateNormal];
//            }
            return [NSNumber numberWithBool:!waiting.boolValue];
        }];
        
    }
    return self;
}

- (void)setWaiting:(BOOL)waiting{
    _waiting = waiting;
    if (waiting) {
        __block NSInteger count = 30;
        [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] takeUntilBlock:^BOOL(id x) {
            return !(count >= 1 && _waiting == YES);
        }] subscribeNext:^(id x) {
            count--;
            [self setTitle:[NSString stringWithFormat:@"%d", count] forState:UIControlStateDisabled];
            if (count <= 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.waiting = NO;
                });
            }
        }];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
