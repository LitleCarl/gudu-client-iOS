//
//  AddAddressViewController.m
//  GuduMorning
//
//  Created by Macbook on 15/9/10.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController ()
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *phoneField;
    __weak IBOutlet UITextField *addressField;
    
    __weak IBOutlet UIButton *submitButton;
}
@end

@implementation AddAddressViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initUI];
    [self setUpTrigger];
}

- (void)initUI{
    self.tableView.tableFooterView = [UIView new];
}

- (void)setUpTrigger{
    RACSignal *nameValid = [nameField.rac_textSignal map:^id(NSString *text) {
        if (text.length >= 1) {
            return @YES;
        }
        else {
            return @NO;
        }
    }];
    RACSignal *addressValid = [addressField.rac_textSignal map:^id(NSString *text) {
        if (text.length >= 5) {
            return @YES;
        }
        else {
            return @NO;
        }
    }];
    RACSignal *phoneValid = [phoneField.rac_textSignal map:^id(NSString *text) {
        
        NSString *someRegexp = @"^0?1[3|4|5|8][0-9]\\d{8}$";
        NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", someRegexp];
        
        if ([myTest evaluateWithObject: text]){
            return @YES;
        }
        else {
            return @NO;
        }
    }];
    
    RAC(submitButton, enabled) = [RACSignal combineLatest:@[nameValid, phoneValid, addressValid] reduce:^(NSNumber *nameOK, NSNumber *phoneOK, NSNumber *addressOK){
        return @(nameOK.boolValue && phoneOK.boolValue && addressOK.boolValue);
    }];
    
    [[submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        kDismissKeyboard
        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:kAddAddressUrl params:nil];
        NSDictionary *params = @{
                                 @"name": nameField.text,
                                 @"phone": phoneField.text,
                                 @"address": addressField.text
                                 };
        RACSignal *signal = [Tool POST:url parameters:params progressInView:self.view showNetworkError:YES];
        [signal subscribeNext:^(id responseObject) {
            if (kGetResponseCode(responseObject) == kSuccessCode) {
                [MBProgressHUD bwm_showTitle:@"保存成功" toView:kKeyWindow hideAfter:2.0 msgType:BWMMBProgressHUDMsgTypeSuccessful];
                //发送需要重新获取用户信息请求
                kSetNeedReloadUserSession;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
    
}

@end
