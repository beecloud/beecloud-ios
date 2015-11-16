//
//  BCOfflineRevertResp.h
//  BCPay
//
//  Created by Ewenlong03 on 15/9/17.
//  Copyright © 2015年 BeeCloud. All rights reserved.
//

#import "BCBaseResp.h"
#import "BCOfflineRevertReq.h"

@interface BCOfflineRevertResp : BCBaseResp
/**
 *  订单撤销状态
 */
@property (nonatomic, assign) BOOL revertStatus;

@end
