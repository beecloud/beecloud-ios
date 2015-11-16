//
//  BCOfflineRevertReq.h
//  BCPay
//
//  Created by Ewenlong03 on 15/9/17.
//  Copyright © 2015年 BeeCloud. All rights reserved.
//

#import "BCBaseReq.h"

@interface BCOfflineRevertReq : BCBaseReq
/**
 *  商户自定义订单号
 */
@property (nonatomic, retain) NSString *billNo;
/**
 *  支付渠道
 */
@property (nonatomic, assign) PayChannel channel;

@end
