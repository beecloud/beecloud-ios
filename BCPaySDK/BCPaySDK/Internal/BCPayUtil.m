//
//  BCPayUtil.m
//  BCPay
//
//  Created by Ewenlong03 on 15/7/9.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "BCPayUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "BCPayCache.h"

@implementation BCPayUtil

+ (AFHTTPRequestOperationManager *)getAFHTTPRequestOperationManager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = NO;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    return manager;
}

+ (NSMutableDictionary *)getWrappedParametersForGetRequest:(NSDictionary *) parameters {
    NSData *parameterData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *parameterString = [[NSString alloc] initWithBytes:[parameterData bytes] length:[parameterData length]
                                                       encoding:NSUTF8StringEncoding];
    NSMutableDictionary *paramWrapper = [NSMutableDictionary dictionary];
    [paramWrapper setObject:parameterString forKey:@"para"];
    return paramWrapper;
}

+ (NSMutableDictionary *)prepareParametersForPay {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSNumber *timeStamp = [BCUtil getTimeStampFromDate:[NSDate date]];
    NSString *appSign = [BCPayUtil getAppSignature:[NSString stringWithFormat:@"%@",timeStamp]];
    if(appSign) {
        [parameters setObject:[BCPayCache sharedInstance].appId forKey:@"app_id"];
        [parameters setObject:timeStamp forKey:@"timestamp"];
        [parameters setObject:appSign forKey:@"app_sign"];
        return parameters;
    }
    return nil;
}

+ (NSDate *)stringToDate:(NSString *)string {
    if (string == nil || string.length == 0) return nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kBCDateFormat];
    return [dateFormatter dateFromString:string];
}

+ (NSString *)getAppSignature:(NSString *)timeStamp {
    NSString *appid = [BCPayCache sharedInstance].appId;
    NSString *appsecret = [BCPayCache sharedInstance].appSecret;
    
    if (![BCUtil isValidString:appid] || ![BCUtil isValidString:appsecret])
        return nil;
    
    NSString *input = [appid stringByAppendingString:timeStamp];
    input = [input stringByAppendingString:appsecret];
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

+ (BCPayUrlType)getUrlType:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"])
        return BCPayUrlAlipay;
    else if ([url.scheme hasPrefix:@"wx"] && [url.host isEqualToString:@"pay"])
        return BCPayUrlWeChat;
    else
        return BCPayUrlUnknown;
}


+ (NSString *)getBestHostWithFormat:(NSString *)format {
    NSString *verHost = [NSString stringWithFormat:@"%@%@",kBCHosts[arc4random()%kBCHostCount],reqApiVersion]; //2015.07.09
    verHost = @"http://58.211.191.123:8080/1";
    return [NSString stringWithFormat:format, verHost];
}

@end

void BCPayLog(NSString *format,...) {
    if ([BCPayCache sharedInstance].willPrintLogMsg) {
        va_list list;
        va_start(list,format);
        NSLogv(format, list);
        va_end(list);
    }
}
