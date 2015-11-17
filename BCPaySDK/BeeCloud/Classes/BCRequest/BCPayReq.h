//
//  BCPayReq.h
//  BCPaySDK
//
//  Created by Ewenlong03 on 15/7/27.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "BCBaseReq.h"
#import "BCPayConstant.h"
#import <UIKit/UIKit.h>

#pragma mark BCPayReq
/**
 *  Pay Request请求结构体
 */
@interface BCPayReq : BCBaseReq //type=101
/**
 *  支付渠道(WX,Ali,Union)
 */
@property (nonatomic, assign) PayChannel channel;
/**
 *  订单描述,32个字节内,最长16个汉字。必填
 */
@property (nonatomic, retain) NSString *title;
/**
 *  支付金额,以分为单位,必须为正整数,100表示1元。必填
 */
@property (nonatomic, retain) NSString *totalFee;
/**
 *  商户系统内部的订单号,8~32位数字和/或字母组合,确保在商户系统中唯一。必填
 */
@property (nonatomic, retain) NSString *billNo;
/**
 *  订单失效时间,必须为非零正整数，单位为秒，建议不小于300。选填
 */
@property (nonatomic, assign) NSInteger billTimeOut;
/**
 *  调用支付的app注册在info.plist中的scheme,支付宝支付必填
 */
@property (nonatomic, retain) NSString *scheme;
/**
 *  调起银联支付的页面，银联支付必填
 */
@property (nonatomic, retain) UIViewController *viewController;
/**
 *  扩展参数,可以传入任意数量的key/value对来补充对业务逻辑的需求;此参数会在webhook回调中返回;
 */
@property (nonatomic, retain) NSMutableDictionary *optional;

@end
