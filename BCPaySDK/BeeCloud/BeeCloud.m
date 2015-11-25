//
//  BeeCloud.m
//  BeeCloud
//
//  Created by Ewenlong03 on 15/9/7.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//
#import "BeeCloud.h"

#import "BCPayCache.h"
#import "BeeCloudAdapter.h"
#import "BeeCloud+Utils.h"

@interface BeeCloud ()
@property (nonatomic, weak) id<BeeCloudDelegate> delegate;
@end


@implementation BeeCloud

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static BeeCloud *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[BeeCloud alloc] init];
    });
    return instance;
}

+ (BOOL)initWithAppID:(NSString *)appId andAppSecret:(NSString *)appSecret {
    BCPayCache *instance = [BCPayCache sharedInstance];
    if (appId.isValid && appSecret.isValid) {
        instance.appId = appId;
        instance.appSecret = appSecret;
        return YES;
    }
    return NO;
}

+ (BOOL)initWeChatPay:(NSString *)wxAppID {
    if (!wxAppID.isValid) {
        return NO;
    }
    return [BeeCloudAdapter beeCloudRegisterWeChat:wxAppID];
}

+ (BOOL)initPayPal:(NSString *)clientID secret:(NSString *)secret sanBox:(BOOL)isSandBox {
    
    if(clientID.isValid && secret.isValid) {
        BCPayCache *instance = [BCPayCache sharedInstance];
        instance.payPalClientID = clientID;
        instance.payPalSecret = secret;
        instance.isPayPalSandBox = isSandBox;
        
        [BeeCloudAdapter beeCloudRegisterPayPal:clientID secret:secret sanBox:isSandBox];
        return YES;
    }
    return NO;
}

+ (void)setBeeCloudDelegate:(id<BeeCloudDelegate>)delegate {
    [BeeCloud sharedInstance].delegate = delegate;
}

+ (id<BeeCloudDelegate>)getBeeCloudDelegate {
    return [BeeCloud sharedInstance].delegate;
}

+ (BOOL)handleOpenUrl:(NSURL *)url {
    if (BCPayUrlWeChat == [BCPayUtil getUrlType:url]) {
        return [BeeCloudAdapter beeCloud:kAdapterWXPay handleOpenUrl:url];
    } else if (BCPayUrlAlipay == [BCPayUtil getUrlType:url]) {
        return [BeeCloudAdapter beeCloud:kAdapterAliPay handleOpenUrl:url];
    }
    return NO;
}

+ (NSString *)getBCApiVersion {
    return kApiVersion;
}

+ (void)setWillPrintLog:(BOOL)flag {
    [BCPayCache sharedInstance].willPrintLogMsg = flag;
}

+ (void)setNetworkTimeout:(NSTimeInterval)time {
    [BCPayCache sharedInstance].networkTimeout = time;
}

+ (BOOL)sendBCReq:(BCBaseReq *)req {
    BeeCloud *instance = [BeeCloud sharedInstance];
    BOOL bSend = YES;
    switch (req.type) {
        case BCObjsTypePayReq:
            [instance reqPay:(BCPayReq *)req];
            break;
        case BCObjsTypeQueryReq:
            [instance reqQueryOrder:(BCQueryReq *)req];
            break;
        case BCObjsTypeQueryRefundReq:
            [instance reqQueryOrder:(BCQueryRefundReq *)req];
            break;
        case BCObjsTypeRefundStatusReq:
            [instance reqRefundStatus:(BCRefundStatusReq *)req];
            break;
        case BCObjsTypePayPal:
            [instance  reqPayPal:(BCPayPalReq *)req];
            break;
        case BCObjsTypePayPalVerify:
            [instance reqPayPalVerify:(BCPayPalVerifyReq *)req];
            break;
        case BCObjsTypeOfflinePayReq:
            [instance reqOfflinePay:req];
            break;
        case BCObjsTypeOfflineBillStatusReq:
            [instance reqOfflineBillStatus:req];
            break;
        case BCObjsTypeOfflineRevertReq:
            [instance reqOfflineBillRevert:req];
            break;
        default:
            bSend = NO;
            break;
    }
    return bSend;
}

@end
