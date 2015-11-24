//
//  EditAddressViewController.m
//  GuduMorning
//
//  Created by Macbook on 15/9/10.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "EditAddressViewController.h"
@interface EditAddressViewController ()
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *addressField;
    __weak IBOutlet UITextField *phoneField;
    __weak IBOutlet UIButton *submitButton;
}

@end
@implementation EditAddressViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initUI];
    [self setUpTrigger];
}

- (void)initUI{
    self.tableView.tableFooterView = [UIView new];
}

- (void)setUpTrigger{
    [RACObserve(self, address) subscribeNext:^(AddressModel *address) {
        nameField.text = address.name;
        phoneField.text = address.phone;
        addressField.text = address.address;
    }];
    
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
        AddressModel *temp = [AddressModel new];
        temp.address = addressField.text;
        temp.name = nameField.text;
        temp.phone = phoneField.text;
        temp.id = self.address.id;
        
        NSString *url = [Tool buildRequestURLHost:kHostBaseUrl APIVersion:nil requestURL:[kUpdateAddressUrl stringByReplacingOccurrencesOfString:@":address_id" withString: temp.id] params:nil];
        
        NSDictionary *params = @{
                                 @"address" : [temp keyValues]                                };
        RACSignal *signal = [Tool PUT:url parameters:params progressInView:self.view showNetworkError:YES];
        [signal subscribeNext:^(id responseObject) {
            if (kGetResponseCode(responseObject) == kSuccessCode) {
                [MBProgressHUD bwm_showTitle:@"更新成功" toView:kKeyWindow hideAfter:2.0 msgType:BWMMBProgressHUDMsgTypeSuccessful];
                self.address.name = temp.name;
                self.address.address = temp.address;
                self.address.phone = temp.phone;
                    
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
    
}

@end
