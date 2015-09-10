//
//  LoginViewController.m
//  GuduMorning
//
//  Created by Macbook on 15/9/1.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "LoginViewController.h"

// Views
#import "TsaoCodeSenderButton.h"

#import "UserSession.h"

@interface LoginViewController () <UITextFieldDelegate>

{
    /// 验证码发送按钮
    __weak IBOutlet TsaoCodeSenderButton *sendCodeButton;
    
    /// 手机号TextField
    __weak IBOutlet UITextField *phoneTextField;
    
    /// 验证码TextField
    __weak IBOutlet UITextField *codeTextfield;
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
                [[UserSession sharedUserSession] setSessionToken:[kGetResponseData(responseObject) objectForKey:@"token"]];
                if (self.needDismiss){
                    [self dismissViewControllerAnimated:YES completion:NULL];
                }
                TsaoLog(@"登录成功");
            }
            else {
                TsaoLog(@"登录失败");
            }
        }];
        
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

@end
