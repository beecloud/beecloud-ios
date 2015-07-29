//
//  BeeCloud.h
//  BeeCloud SDK
//
//  Copyright (c) 2014 BeeCloud Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BCConstants.h"
#import "BCUtil.h"

/**
 *  BeeCloud SDK release version.
 */
static NSString * const kBeeCloudVersionString = @"2.4.1";
static double const kBeeCloudVersionNumber = 2.4;

/**
 *  Global configuration and control methods for BeeCloud.
 */
@interface BeeCloud : NSObject

/**
 *  Set the app key obtained after registering this app in BeeCloud website. Also takes care of all initialization tasks
 *  for different BeeCloud services. This must be called before using any BeeCloud functions.
 *
 *  Notice that this function returns immediately and does not block the UI thread.
 *
 *  @param key Appid and appSecret obtained from BeeCloud dashborad website.
 */
+ (void)initWithAppID:(NSString *)appId andAppSecret:(NSString *)appSecret;

/**
 *  Change the default network timeout in seconds for all network requests.
 *
 *  @param timeout Seconds in double for default network timeout value, such as 3.5.
 */
+ (void)setNetworkTimeout:(NSTimeInterval)timeout;

/**
 *  Clear all cached copies of BCObjects.
 */
+ (void)clearAllCache;

/**
 *  This is a switch to print log message.Default NO.
 *
 *  @param bLog YES will print log message on console.
 */
+ (void)setWillPrintLog:(BOOL)bLog;

/**
 *  get the value of print log.
 *
 *  @return YES if you will print log.
 */
+ (BOOL)getWillPrintLog;

@end
