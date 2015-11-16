//
//  BCQueryReq.h
//  BCPaySDK
//
//  Created by Ewenlong03 on 15/7/27.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "BCBaseReq.h"
#import "BCPayConstant.h"

#pragma mark BCQueryReq
/**
 *  根据条件查询请求支付订单记录
 */
@interface BCQueryReq : BCBaseReq 
/**
 *  支付渠道
 */
@property (nonatomic, assign) PayChannel channel;
/**
 *  商家自定义订单号
 */
@property (nonatomic, retain) NSString *billNo;
/**
 *  订单创建时间，@"yyyyMMddHHmm"格式
 */
@property (nonatomic, assign) NSString *startTime;
/**
 *  订单创建时间，@"yyyyMMddHHmm"格式
 */
@property (nonatomic, assign) NSString *endTime;
/**
 *  从第几条开始查询
 */
@property (nonatomic, assign) NSInteger skip;
/**
 *  查询多少条订单记录
 */
@property (nonatomic, assign) NSInteger limit;

@end
