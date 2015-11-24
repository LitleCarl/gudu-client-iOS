//
//  LoginViewController.m
//  GuduMorning
//
//  Created by Macbook on 15/9/1.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "LoginViewController.h"
#import "BindRoleViewController.h"

// Views
#import "TsaoCodeSenderButton.h"

#import "UserSession.h"

#import "WXApi.h"
#import "WXApiObject.h"
#import "WXApiManager.h"

static NSString *kAuthScope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
static NSString *kAuthOpenID = @"0c806938e2413ce73eef92cc3";
static NSString *kAuthState = @"xxx";


@interface LoginViewController () <UITextFieldDelegate, WXApiManagerDelegate>

{
    /// 验证码发送按钮
    __weak IBOutlet TsaoCodeSenderButton *sendCodeButton;
    
    /// 手机号TextField
    __weak IBOutlet UITextField *phoneTextField;
    
    /// 验证码TextField
    __weak IBOutlet UITextField *codeTextfield;
    
    /// 返回按钮
    __weak IBOutlet UIButton *backButton;
}
/**
 *  验证码token
 */
@property NSString *smsToken;
@end

@implementation LoginViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if ([super initWithCoder:aDecoder]) {
        self.tabBarItem.title = @"我";
        
        self.tabBarItem.image = [[UIImage imageNamed:@"icon_tabbar_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[[UIImage imageNamed:@"icon_tabbar_mine_selected"] imageTintedWithColor:kGreenColor]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTrigger];
    // Do any additional setup after loading the view.
}

/**
 *  设置触发器
 */
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
    
    RAC(codeTextfield, enabled) = [RACObserve(self, smsToken) map:^id(id value) {
        return [NSNumber numberWithBool:value != nil];
    }];
    
    [[codeTextfield rac_signalForControlEvents:UIControlEventEditingDidEndOnExit] subscribeNext:^(id x) {
        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:kLoginUrl params:nil];
        
        NSDictionary *params = @{
                                 @"phone": phoneTextField.text,
                                 @"smsCode": codeTextfield.text,
                                 @"smsToken": self.smsToken
                                 };
        
        RACSignal *loginSignal = [Tool POST:url parameters:params progressInView:self.view showNetworkError:YES];
        [loginSignal subscribeNext:^(id responseObject) {
            if (kGetResponseCode(responseObject) == kSuccessCode) {
                [self handleLoginResult:[kGetResponseData(responseObject) objectForKey:@"token"]];
                TsaoLog(@"登录成功");
            }
            else {
                TsaoLog(@"登录失败");
                [MBProgressHUD bwm_showTitle:[NSString stringWithFormat:@"%@", kGetResponseMessage(responseObject)] toView:kKeyWindow hideAfter:2.0 msgType:BWMMBProgressHUDMsgTypeSuccessful];

            }
        }];
        
    }];
    
    RAC(backButton, hidden) = [RACObserve(self, needDismiss) map:^id(id value) {
        return @(![value boolValue]);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)dismissSelf:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)weixin_login:(id)sender {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = kAuthScope; // @"post_timeline,sns"
    req.state = @"zaocan84";
    req.openID = kAuthOpenID;
    [WXApiManager sharedManager].delegate = self;
    [WXApi sendAuthReq:req
               viewController:self
                     delegate:[WXApiManager sharedManager]];

}
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response{
    SendAuthResp *authResp = (SendAuthResp *)response;
//    NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
//    NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", authResp.code, authResp.state, authResp.errCode];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
//                                                    message:strMsg
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil, nil];
//    [alert show];
    
    NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:kWeixinLoginUrl params:NULL];
    [[Tool POST:url parameters:@{
                                @"code": authResp.code
                                } progressInView:self.view showNetworkError:YES] subscribeNext:^(id responseObject) {
        TsaoLog(@"返回:%@", responseObject);
        if (kGetResponseCode(responseObject) == kSuccessCode) {
            if ([kGetResponseData(responseObject) objectForKey:@"token"]) {
                [self handleLoginResult:[kGetResponseData(responseObject) objectForKey:@"token"]];
            }
            else if([kGetResponseData(responseObject) objectForKey:@"auth"]){
                BindRoleViewController *controller = [kUserStoryBoard instantiateViewControllerWithIdentifier:kBindRolleViewControllerStoryBoardId];
                controller.authorization = [kGetResponseData(responseObject) objectForKey:@"auth"];
                [self.navigationController pushViewController:controller animated:YES];
            }
            else{
                [MBProgressHUD bwm_showTitle:@"登录异常" toView:kKeyWindow hideAfter:2.0 msgType:BWMMBProgressHUDMsgTypeSuccessful];
            }
        }
     
        
    } error:^(NSError *error) {

    }];
    
}

- (void)handleLoginResult:(NSString *)token{
    if (token != nil) {
        [[UserSession sharedUserSession] setSessionToken:token];
        if (self.needDismiss){
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }
    
}

@end
