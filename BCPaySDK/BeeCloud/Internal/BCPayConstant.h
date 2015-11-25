//
//  BCPayConstant.h
//  BCPaySDK
//
//  Created by Ewenlong03 on 15/7/21.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BCPaySDK_BCPayConstant_h
#define BCPaySDK_BCPayConstant_h

static NSString * const kApiVersion = @"3.3.2";//api版本号

static NSString * const kNetWorkError = @"网络请求失败";
static NSString * const kUnknownError = @"未知错误";
static NSString * const kKeyResponseResultCode = @"result_code";
static NSString * const kKeyResponseResultMsg = @"result_msg";
static NSString * const kKeyResponseErrDetail = @"err_detail";

static NSString * const kKeyResponseCodeUrl = @"code_url";
static NSString * const KKeyResponsePayResult = @"pay_result";
static NSString * const kKeyResponseRevertResult = @"revert_status";

static NSUInteger const kBCHostCount = 4;
static NSString * const kBCHosts[] = {@"https://apisz.beecloud.cn",
    @"https://apiqd.beecloud.cn",
    @"https://apibj.beecloud.cn",
    @"https://apihz.beecloud.cn"};

static NSString * const reqApiVersion = @"/2";

//rest api online
static NSString * const kRestApiPay = @"%@/rest/bill";
static NSString * const kRestApiRefund = @"%@/rest/refund";
static NSString * const kRestApiQueryBills = @"%@/rest/bills";
static NSString * const kRestApiQueryRefunds = @"%@/rest/refunds";
static NSString * const kRestApiRefundState = @"%@/rest/refund/status";
static NSString * const kRestApiQueryBillById = @"%@/rest/bill/";
static NSString * const kRestApiQueryRefundById = @"%@/rest/refund/";

//rest api offline
static NSString * const kRestApiOfflinePay = @"%@/rest/offline/bill";
static NSString * const kRestApiOfflineBillStatus = @"%@/rest/offline/bill/status";
static NSString * const kRestApiOfflineBillRevert = @"%@/rest/offline/bill/";

//paypal accesstoken
static NSString * const kPayPalAccessTokenProduction = @"https://api.paypal.com/v1/oauth2/token";
static NSString * const kPayPalAccessTokenSandBox = @"https://api.sandbox.paypal.com/v1/oauth2/token";

//Adapter
static NSString * const kAdapterWXPay = @"BCWXPayAdapter";
static NSString * const kAdapterAliPay = @"BCAliPayAdapter";
static NSString * const kAdapterUnionPay = @"BCUnionPayAdapter";
static NSString * const kAdapterPayPal = @"BCPayPalAdapter";
static NSString * const kAdapterOffline = @"BCOfflineAdapter";
static NSString * const kAdapterBaidu = @"BCBaiduAdapter";

/**
 *  BCPay URL type for handling URLs.
 */
typedef NS_ENUM(NSInteger, BCPayUrlType) {
    /**
     *  Unknown type.
     */
    BCPayUrlUnknown,
    /**
     *  WeChat pay.
     */
    BCPayUrlWeChat,
    /**
     *  Alipay.
     */
    BCPayUrlAlipay
};


typedef NS_ENUM(NSInteger, PayChannel) {
    PayChannelNone = 0,
    
    PayChannelWx = 10, //微信
    PayChannelWxApp,//微信APP
    PayChannelWxNative,//微信扫码
    PayChannelWxJsApi,//微信JSAPI(H5)
    PayChannelWxScan,
    
    PayChannelAli = 20,//支付宝
    PayChannelAliApp,//支付宝APP
    PayChannelAliWeb,//支付宝网页即时到账
    PayChannelAliWap,//支付宝手机网页
    PayChannelAliQrCode,//支付宝扫码即时到帐
    PayChannelAliOfflineQrCode,//支付宝线下扫码
    PayChannelAliScan,
    
    PayChannelUn = 30,//银联
    PayChannelUnApp,//银联APP
    PayChannelUnWeb,//银联网页
    
    PayChannelPayPal = 40,
    PayChannelPayPalLive,
    PayChannelPayPalSanBox,
    
    PayChannelBaidu = 50,
    PayChannelBaiduApp,
    PayChannelBaiduWeb,
    PayChannelBaiduWap
};

typedef NS_ENUM(NSInteger, BCErrCode) {
    BCErrCodeSuccess    = 0,    /**< 成功    */
    BCErrCodeCommon     = -1,   /**< 参数错误类型    */
    BCErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    BCErrCodeSentFail   = -3,   /**< 发送失败    */
    BCErrCodeUnsupport  = -4,   /**< BeeCloud不支持 */
};

typedef NS_ENUM(NSInteger, BCObjsType) {
    BCObjsTypeBaseReq = 100,
    BCObjsTypePayReq,
    BCObjsTypeQueryReq,
    BCObjsTypeQueryRefundReq,
    BCObjsTypeRefundStatusReq,
    BCObjsTypeOfflinePayReq,
    BCObjsTypeOfflineBillStatusReq,
    BCObjsTypeOfflineRevertReq,
    
    BCObjsTypeBaseResp = 200,
    BCObjsTypePayResp,
    BCObjsTypeQueryResp,
    BCObjsTypeRefundStatusResp,
    BCObjsTypeOfflinePayResp,
    BCObjsTypeOfflineBillStatusResp,
    BCObjsTypeOfflineRevertResp,
    
    BCObjsTypeBaseResults = 300,
    BCObjsTypeBillResults,
    BCObjsTypeRefundResults,
    
    BCObjsTypePayPal = 400,
    BCObjsTypePayPalVerify
};

static NSString * const kBCDateFormat = @"yyyy-MM-dd HH:mm";

#endif
