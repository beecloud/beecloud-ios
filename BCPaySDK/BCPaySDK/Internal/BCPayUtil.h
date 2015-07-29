//
//  BCPayUtil.h
//  BCPay
//
//  Created by Ewenlong03 on 15/7/9.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPayObject.h"
#import "AFNetworking.h"
#import "BCPayConstant.h"
#import "BCPayCache.h"
#import "BCUtil.h"


@interface BCPayUtil : NSObject

/** @name util functions*/

/*!
 A wrapper for AFHTTPRequestOperationManager.
 */
+ (AFHTTPRequestOperationManager *)getAFHTTPRequestOperationManager;

/**
 *  Get wrapped parameters in the format of "para" to a map for GET REST APIs.
 *
 *  @param parameters map
 *
 *  @return new map
 */
+ (NSMutableDictionary *)getWrappedParametersForGetRequest:(NSDictionary *) parameters;

/**
 *  prepare parameters
 *
 *  @param block result block
 *
 *  @return default request map
 */
+ (NSMutableDictionary *)prepareParametersForPay;

/**
 *  获取url的类型，微信或者支付宝
 *
 *  @param url 渠道返回的url
 *
 *  @return 微信或者支付宝
 */
+ (BCPayUrlType)getUrlType:(NSURL *)url;

/**
 *  getBestHost
 *
 *  @param format url
 *
 *  @return url
 */
+ (NSString *)getBestHostWithFormat:(NSString *)format;

@end

FOUNDATION_EXPORT void BCPayLog(NSString *format,...) NS_FORMAT_FUNCTION(1,2) ;
