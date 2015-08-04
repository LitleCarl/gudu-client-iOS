//
//  Tool.m
//  GuduMorning
//
//  Created by Tsao on 15/8/1.
//  Copyright (c) 2015年 FinalFerrumbox. All rights reserved.
//

#import "Tool.h"

@implementation Tool

#pragma mark - URL Builder

+ (NSString *)buildRequestURLHost:(NSString *)host
                       APIVersion:(NSString *)APIVersion
                       requestURL:(NSString *)requestURL
                           params:(NSDictionary *)params
{
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
    
    string = [string stringByAppendingFormat:@"platform=iOS&app_version=%@",kAppVersion];
    
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

+ (RACSignal *)GET:(NSString *)url parameters:(NSDictionary *)parameters{
    
    return [RACSignal createSignal:^RACDisposable *(id subscriber){
        TsaoLog(@"GET QUERY");
        AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager singleton];
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:responseObject];
            
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
    
    
}

@end
