//
//  PayResultViewController.m
//  GuduMorning
//
//  Created by Macbook on 11/20/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import "PayResultViewController.h"
#import <Pingpp.h>
#import "PayResultHandlerManager.h"
#import "WXApi.h"
#import "WXApiObject.h"

@interface PayResultViewController () <PayResultHandlerDelegate>

/**
 *  心情图像
 */
@property (weak, nonatomic) IBOutlet UIImageView *emotionImageView;

/**
 *  重新支付按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *repay_button;

/**
 *  红包分享按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *share_red_pack_button;

@end

@implementation PayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTrigger];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTrigger{
    
    [RACObserve(self, payDone) subscribeNext:^(NSNumber *done) {
        if ([done boolValue]) {
            self.emotionImageView.image = [UIImage imageNamed:@"Laugh-256"];
            self.repay_button.hidden = YES;
        }
        else {
            self.emotionImageView.image = [UIImage imageNamed:@"Confused-256"];
            self.repay_button.hidden = NO;
        }
    }];
    
    
    // 红包发送按钮可用性检测
    RAC(self.share_red_pack_button, hidden) = [RACSignal combineLatest:@[RACObserve(self, order), RACObserve([BasicConfigManager sharedDeliveryTimeManager], red_pack_available), RACObserve(self, payDone)] reduce:^(OrderModel *order, NSNumber *red_pack_available, NSNumber *payed){
        return @(!(payed.boolValue && order && [red_pack_available boolValue]));
    }];
    
    [[self.share_red_pack_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        WXWebpageObject *web = [WXWebpageObject object];
        web.webpageUrl = [NSString stringWithFormat:@"%@/authorizations/get_coupon?order_number=%@", kHostBaseUrl, self.order.order_number];
        
        web.webpageUrl = [NSString stringWithFormat:@"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx98e5b3cd70319417&redirect_uri=%@&response_type=code&scope=snsapi_userinfo&state=zaocan84#wechat_redirect", web.webpageUrl];
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"早餐巴士";
        message.mediaObject = web;
        message.description =  @"点击直接领取早餐红包啦~";;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.text = @"免费获取早餐红包啦";
        req.bText = NO;
        req.scene = WXSceneSession;
        req.message = message;
        [WXApi sendReq:req];
    }];
    
    [[self.repay_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:[kPayOrderUrl stringByReplacingOccurrencesOfString:@":order_id" withString:self.order.id] params:nil];
        RACSignal *signal = [Tool GET:url parameters:nil progressInView:kKeyWindow showNetworkError:YES];
        [signal subscribeNext:^(id responseObject) {
            if (kGetResponseCode(responseObject) == kSuccessCode){
                id data = kGetResponseData(responseObject);
            
                id charge = [data objectForKey:@"charge"];
                [PayResultHandlerManager sharedManager].delegate = self;
                
                [Pingpp createPayment:charge
                       viewController:nil
                         appURLScheme:kUrlScheme
                       withCompletion:^(NSString *result, PingppError *error) {
                           
                       }];
            }
        }];
    }];
    
}

#pragma mark - PayResultHandlerDelegate -

- (void)handle:(NSString *)result error:(PingppError *)error{
    if ([result isEqualToString:@"success"]) {
        self.payDone = YES;
    } else {
        self.payDone = NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
