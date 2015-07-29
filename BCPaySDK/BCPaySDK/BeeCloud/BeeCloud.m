//
//  BeeCloud.m
//  BeeCloud SDK
//
//  Created by Junxian Huang on 2/6/14.
//  Copyright (c) 2014 BeeCloud Inc. All rights reserved.
//

#import "BeeCloud.h"

#import "BCUtilPrivate.h"

// This is to enable connecting to beecloud servers with HTTPS.
//@implementation NSURLRequest(DataController)
//
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
//    if ([host hasSuffix:@"beecloud.cn"] || [host hasSuffix:@"beexcloud.com"])
//        return YES;
//    else
//        return NO;
//}
//
//@end

@implementation BeeCloud

//  @attention: this function should not contain any parts that blocks the main thread!
+ (void)initWithAppID:(NSString *)appId andAppSecret:(NSString *)appSecret {

    [BCCache sharedInstance].appId = appId;
    [BCCache sharedInstance].appSecret = appSecret;
    
  //  [BCStatus startMeasurement];
}

+ (void)setMasterKey:(NSString *)key {
    [BCCache sharedInstance].masterKey = key;
}

+ (void)setNetworkTimeout:(NSTimeInterval)timeout {
    [BCCache sharedInstance].networkTimeout = timeout;
}

+ (void)clearAllCache {
    [BCCache clearAllCache];
}

+ (void)setWillPrintLog:(BOOL)bLog {
    [BCCache sharedInstance].willPrintLogMsg = bLog;
}

+ (BOOL)getWillPrintLog {
    return [BCCache sharedInstance].willPrintLogMsg;
}

@end
