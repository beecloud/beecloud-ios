//
//  BCQRefundResult.h
//  BCPaySDK
//
//  Created by Ewenlong03 on 15/7/27.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "BCBaseResult.h"

#pragma mark BCQueryRefundResult

/**
 *  退款订单查询结果
 */
@interface BCQueryRefundResult : BCBaseResult
/**
 *  商户自定义退款订单号
 */
@property (nonatomic, retain) NSString *refundNo;
/**
 *  退款金额，以分为单位
 */
@property (nonatomic, assign) NSInteger refundFee;
/**
 *  退款是否结束
 */
@property (nonatomic, assign) BOOL      finish;//BOOL
/**
 *  退款结果
 */
@property (nonatomic, assign) BOOL      result;//BOOL

@end
