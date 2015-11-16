//
//  BCOfflineStatusReq.h
//  BCPay
//
//  Created by Ewenlong03 on 15/9/17.
//  Copyright © 2015年 BeeCloud. All rights reserved.
//

#import "BCBaseReq.h"

@interface BCOfflineStatusReq : BCBaseReq
/**
 *  商户自定义订单号
 */
@property (nonatomic, retain) NSString *billno;
/**
 *  支付渠道
 */
@property (nonatomic, assign) PayChannel channel;

@end
