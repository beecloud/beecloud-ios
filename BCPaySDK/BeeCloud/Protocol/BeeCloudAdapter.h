//
//  BCProtocol.h
//  BeeCloud
//
//  Created by Ewenlong03 on 15/9/9.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeeCloud.h"

@interface BeeCloudAdapter : NSObject

+ (BOOL)beeCloudRegisterWeChat:(NSString *)appid;
+ (BOOL)beeCloudIsWXAppInstalled;
+ (void)beeCloudRegisterPayPal:(NSString *)clientID secret:(NSString *)secret sanBox:(BOOL)isSandBox;
+ (BOOL)beeCloud:(NSString *)object handleOpenUrl:(NSURL *)url;

+ (BOOL)beeCloudWXPay:(NSMutableDictionary *)dic;
+ (BOOL)beeCloudAliPay:(NSMutableDictionary *)dic;
+ (BOOL)beeCloudUnionPay:(NSMutableDictionary *)dic;
+ (NSString *)beeCloudBaiduPay:(NSMutableDictionary *)dic;

+ (void)beeCloudPayPal:(NSMutableDictionary *)dic;
+ (void)beeCloudPayPalVerify:(NSMutableDictionary *)dic;
+ (void)beeCloudOfflinePay:(NSMutableDictionary *)dic;
+ (void)beeCloudOfflineStatus:(NSMutableDictionary *)dic;
+ (void)beeCloudOfflineRevert:(NSMutableDictionary *)dic;


@end