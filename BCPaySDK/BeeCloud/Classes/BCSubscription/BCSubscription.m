//
//  BCSubscription.m
//  BCPay
//
//  Created by Ewenlong03 on 16/8/4.
//  Copyright © 2016年 BeeCloud. All rights reserved.
//

#import "BCSubscription.h"


@implementation BCSubscription

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static BCSubscription *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[BCSubscription alloc] init];
    });
    return instance;
}

+ (void)setSubDelegate:(id<BCSubscriptionDelegate>)delegate {
    [BCSubscription sharedInstance].delegate = delegate;
}

+ (void)smsReq:(NSString *)phone {
    if (phone.isValidMobile) {
        NSMutableDictionary *params = [BCPayUtil prepareParametersForRequest];
        
        params[@"phone"] = phone;
        
        [BCNetworkHelper postWithUrlString:[NSString stringWithFormat:@"%@/sms",subscription_host] parameters:params success:^(NSDictionary *data) {
            NSMutableDictionary *response = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)data];
            response[@"type"] = @(BCSubTypeSMS);
            [BCSubscription doSubscriptionResponse:response];
        } failure:^(NSError *error) {
            [BCSubscription doSubscriptionErrorResponse:kNetWorkError];
        }];
    }
}

+ (void)subscriptionBanks {
    
    NSMutableDictionary *params = [BCPayUtil prepareParametersForRequest];
    
    [BCNetworkHelper getWithUrlString:[NSString stringWithFormat:@"%@/subscription_banks", subscription_host] parameters:params success:^(NSDictionary *data) {
        NSMutableDictionary *response = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)data];
        response[@"type"] = @(BCSubTypeBanks);
        [BCSubscription doSubscriptionResponse:response];
    } failure:^(NSError *error) {
        [BCSubscription doSubscriptionErrorResponse:kNetWorkError];
    }];
}

+ (void)subscriptionCancel:(NSString *)sub_id {
    //
}

+ (void)doSubscriptionErrorResponse:(NSString *)errMsg {
    NSMutableDictionary *resp = [NSMutableDictionary dictionaryWithCapacity:10];
    resp[@"resultCode"] = @(BCErrCodeCommon);
    resp[@"resultMsg"] = errMsg;
    resp[@"errDetail"] = errMsg;
    
    [BCSubscription doSubscriptionResponse:resp];
}

+ (void)doSubscriptionResponse:(NSMutableDictionary *)response {
    
    BCSubscription *shared = [BCSubscription sharedInstance];
    
    if (shared.delegate && [shared.delegate respondsToSelector:@selector(onBCSubscriptionResp:)]) {
        [shared.delegate onBCSubscriptionResp:response];
    }
}


@end
