//
//  BCBaiduAdapter.m
//  BCPay
//
//  Created by Ewenlong03 on 15/9/23.
//  Copyright © 2015年 BeeCloud. All rights reserved.
//

#import "BCBaiduAdapter.h"
#import "BeeCloudAdapterProtocol.h"
#import "BCPayUtil.h"
#import "BDWalletSDKMainManager.h"

static NSString * const kBaiduOrderInfo = @"orderInfo";

@interface BCBaiduAdapter ()<BeeCloudAdapterDelegate>
@end

@implementation BCBaiduAdapter

- (void)baiduPay:(NSMutableDictionary *)dic {
    BCPayResp *resp = (BCPayResp *)[BCPayCache sharedInstance].bcResp;
    resp.resultCode = [dic integerValueForKey:kKeyResponseResultCode defaultValue:BCErrCodeCommon];
    resp.resultMsg = [dic stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
    resp.errDetail = [dic stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
    resp.paySource = @{kBaiduOrderInfo:[dic stringValueForKey:kBaiduOrderInfo defaultValue:@""]};
    [BCPayCache beeCloudDoResponse];
}

@end
