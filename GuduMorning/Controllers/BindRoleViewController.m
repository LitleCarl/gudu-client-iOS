//
//  BindRoleViewController.m
//  GuduMorning
//
//  Created by Macbook on 11/13/15.
//  Copyright © 2015 FinalFerrumbox. All rights reserved.
//

#import "BindRoleViewController.h"

#import "TsaoCodeSenderButton.h"

@interface BindRoleViewController (){

    __weak IBOutlet UITextField *codeField;
    __weak IBOutlet UITextField *phoneTextField;
    __weak IBOutlet UIButton *bindButton;
    __weak IBOutlet TsaoCodeSenderButton *sendCodeButton;
    
}

/**
 *  验证码token
 */
@property NSString *smsToken;

@end

@implementation BindRoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self setUpTrigger];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI{

}

- (void)setUpTrigger{
    // 隐藏键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:tapGesture];
    [[[tapGesture rac_gestureSignal] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        kDismissKeyboard;
    }];
    
    [[sendCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        kDismissKeyboard
        sendCodeButton.waiting = YES;
        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:kSendSmsUrl params:nil];
        NSDictionary *params = @{
                                 @"phone" : phoneTextField.text
                                 };
        RACSignal *sendSmsSignal = [Tool POST:url parameters:params progressInView:self.view showNetworkError:YES];
        [sendSmsSignal subscribeNext:^(id responseObject) {
            if (kGetResponseCode(responseObject) == kSuccessCode) {
                self.smsToken = [kGetResponseData(responseObject) objectForKey:@"token"];
            }
            else {
                TsaoLog(@"failure");
                [Tool showSnackBarWithText:kGetResponseMessage(responseObject) title:@"阿喔" duration:2.0];
                sendCodeButton.waiting = NO;
            }
        }];
    }];
    
    RAC(codeField, enabled) = [RACObserve(self, smsToken) map:^id(id value) {
        return [NSNumber numberWithBool:value != nil];
    }];
    
    RAC(bindButton, enabled) = [RACSignal combineLatest:@[RACObserve(codeField, enabled), RACObserve(self, authorization)] reduce:^(NSNumber *codeFieldEnabled, id authorization){
        return @(codeFieldEnabled.boolValue && authorization != nil && [authorization objectForKey:@"union_id"] != nil);
    }];
    
    [[[bindButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id x) {
        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:kBindWeixinUrl params:nil];
        
        NSDictionary *params = @{
                                 @"union_id": [self.authorization objectForKey:@"union_id"],
                                 @"phone": phoneTextField.text,
                                 @"smsCode": codeField.text,
                                 @"smsToken": self.smsToken
                                 };
        
        RACSignal *loginSignal = [Tool POST:url parameters:params progressInView:self.view showNetworkError:YES];
        [loginSignal subscribeNext:^(id responseObject) {
            if (kGetResponseCode(responseObject) == kSuccessCode) {
                [[UserSession sharedUserSession] setSessionToken:[kGetResponseData(responseObject) objectForKey:@"token"]];
//                if (self.needDismiss){
//                    [self dismissViewControllerAnimated:YES completion:NULL];
//                }
                TsaoLog(@"登录成功");
            }
            else {
                TsaoLog(@"登录失败");
                [MBProgressHUD bwm_showTitle:[NSString stringWithFormat:@"%@", kGetResponseMessage(responseObject)] toView:kKeyWindow hideAfter:2.0 msgType:BWMMBProgressHUDMsgTypeSuccessful];
                
            }
        }];
        
    }];
    

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
