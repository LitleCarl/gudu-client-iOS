//
//  Tool.m
//  GuduMorning
//
//  Created by Tsao on 15/8/1.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "Tool.h"

// View
#import <MDSnackbar.h>

@implementation Tool

#pragma mark - URL Builder

+ (NSString *)buildRequestURLHost:(NSString *)host
                       APIVersion:(NSString *)APIVersion
                       requestURL:(NSString *)requestURL
                           params:(NSDictionary *)params
{
    if (APIVersion == nil) {
        APIVersion = @"";
    }
    TsaoLog(@"host = %@, APIVersion = %@, requestURL = %@, params = %@", host, APIVersion, requestURL, params);
    
    NSString *string = [NSString stringWithFormat:@"%@%@%@?", host, APIVersion, requestURL];
    
    NSEnumerator *keyEnumerator = [params keyEnumerator];
    
    NSEnumerator *objectEnumerator = [params objectEnumerator];
    
    id key;
    
    while (key = [keyEnumerator nextObject]) {
        NSString *obj = [NSString stringWithFormat:@"%@", [objectEnumerator nextObject]];
        //        obj = [obj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        obj = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)obj, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
        
        string = [string stringByAppendingFormat:@"%@=%@&", key, obj];
    }
    
   // string = [string stringByAppendingFormat:@"platform=iOS&app_version=%@",kAppVersion];
    
    return string;
}

#pragma mark - UserDefault -

+ (void)setUserDefault:(NSDictionary *)dict{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isKindOfClass:[NSString class]]) {
            [userDefault setObject:obj forKey:key];
        }
    }];
    [userDefault synchronize];
}

+ (void)resetUserDefautsForKeys:(NSArray *)keys{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [userDefault setObject:obj forKey:obj];
        }
    }];
    [userDefault synchronize];
}

+ (id)getUserDefaultByKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - HTTP -

+ (RACSignal *)GET:(NSString *)url parameters:(NSDictionary *)parameters showNetworkError:(BOOL)showNetWorkError{
    
    return [self GET:url parameters:parameters progressInView:nil showNetworkError:showNetWorkError];
    
}

+ (RACSignal *)GET:(NSString *)url parameters:(NSDictionary *)parameters progressInView:(__weak UIView *)view showNetworkError:(BOOL)showNetWorkError{
    
    return [RACSignal createSignal:^RACDisposable *(id subscriber){
        TsaoLog(@"GET QUERY");
        // 显示progressView
        if (view) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
            [hud show:YES];
        }
        AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager singleton];
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
            if (view) {
                [MBProgressHUD hideAllHUDsForView:view animated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (view) {
                [MBProgressHUD hideAllHUDsForView:view animated:YES];
            }
            if (showNetWorkError) {
                MDSnackbar *snackBar = [[MDSnackbar alloc] initWithText:@"oops,网线被拔掉啦～😢" actionTitle:@"异常" duration:2.0f];
                snackBar.actionTitleColor = kGreenColor;
                snackBar.multiline = YES;
                [snackBar show];
            }
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

@end
