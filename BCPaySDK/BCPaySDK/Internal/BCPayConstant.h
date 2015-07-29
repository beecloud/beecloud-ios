//
//  BCPayConstant.h
//  BCPaySDK
//
//  Created by Ewenlong03 on 15/7/21.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#ifndef BCPaySDK_BCPayConstant_h
#define BCPaySDK_BCPayConstant_h

static NSString * const kApiVersion = @"3.0";//api版本号

static NSString * const kNetWorkError = @"网络请求失败";
static NSString * const kKeyResponseResultCode = @"result_code";
static NSString * const kKeyResponseResultMsg = @"result_msg";
static NSString * const kKeyResponseErrDetail = @"err_detail";


static NSUInteger const kBCHostCount = 4;
static NSString * const kBCHosts[] = {@"https://apisz.beecloud.cn",
    @"https://apiqd.beecloud.cn",
    @"https://apibj.beecloud.cn",
    @"https://apihz.beecloud.cn"};

static NSString * const reqApiVersion = @"/1";

//rest api
static NSString * const kRestApiPay = @"%@/rest/bill";
static NSString * const kRestApiRefund = @"%@/rest/refund";
static NSString * const kRestApiQueryBills = @"%@/rest/bills";
static NSString * const kRestApiQueryRefunds = @"%@/rest/refunds";

//wechat
//API
static NSString * const kApiPayWeChatNewPrepare = @"%@/pay/wxmp/prepare";
static NSString * const kApiPayWeChatNewQueryOrder = @"%@/pay/wxmp/query";
static NSString * const kApiPayWeChatNewStartRefund = @"%@/pay/wx/refund/startRefund";
static NSString * const kApiPayWeChatNewQueryRefund = @"%@/pay/wx/refund/queryRefund";
static NSString * const kApiPayWeChatConfirmRefund =  @"%@/pay/wx/refund/confirmRefund";
//Tables
static NSString * const kBCWeChatPayClassName = @"wechat_pay_result__";
static NSString * const KBCWeChatRefundClassName = @"wx_pre_refund__";

//alipay
//API
static NSString * const kApiPayAliPreSign = @"%@/pay/ali/sign";
static NSString * const kApiPayAliStartRefund = @"%@/pay/ali/refund/startRefund";
//Tables
static NSString * const kBCAliPayClassName = @"ali_pay_result__";
static NSString * const kBCAliRefundClassName = @"ali_pre_refund__";

//unionPay
//API
static NSString * const kApiPayUnionPayGetTN = @"%@/pay/un/sign";
static NSString * const kApiPayUnionPayRefund = @"%@/pay/un/refund/startRefund";
//Table
static NSString * const kBCUPPayClassName = @"un_pay_result__";
static NSString * const kBCUPRefundClassName = @"un_pre_refund__";

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

static NSString * const kBCDateFormat = @"yyyyMMddHHmm";

#endif
