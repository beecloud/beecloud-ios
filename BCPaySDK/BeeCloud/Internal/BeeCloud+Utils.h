//
//  BeeCloud+Utils.h
//  BCPay
//
//  Created by joseph on 15/11/6.
//  Copyright © 2015年 BeeCloud. All rights reserved.
//

#import "BeeCloud.h"

@interface BeeCloud (Utils)

/**
 *  微信、支付宝、银联、百度钱包支付
 *
 *  @param req 支付请求
 */
- (void)reqPay:(BCPayReq *)req;

/**
 *  线下支付事件。支持WX_NATIVE、WX_SCAN、ALI_OFFLINE_QRCODE、ALI_SCAN
 *
 *  @param req 线下支付请求
 */
- (void)reqOfflinePay:(id)req;

/**
 *  线下支付订单状态查询
 *
 *  @param req 线下支付订单查询请求
 */
- (void)reqOfflineBillStatus:(id)req;

/**
 *  线下支付订单撤消。支持WX_SCAN、ALI_OFFLINE_QRCODE、ALI_SCAN
 *
 *  @param req 线下支付订单撤消请求
 */
- (void)reqOfflineBillRevert:(id)req;

/**
 *  PayPal支付
 *
 *  @param req PayPal支付请求
 */
- (void)reqPayPal:(BCPayPalReq *)req;

/**
 *  PayPal验证
 *
 *  @param req PayPal验证请求
 */
- (void)reqPayPalVerify:(BCPayPalVerifyReq *)req;

/**
 *  查询支付/退款订单
 *
 *  @param req 查询订单请求
 */
- (void)reqQueryOrder:(BCQueryReq *)req;

/**
 *  查询退款状态。目前仅支持WX_APP
 *
 *  @param req 查询退款状态请求
 */
- (void)reqRefundStatus:(BCRefundStatusReq *)req;

/**
 *  检查reqPay时参数是否合法
 *
 *  @param request BCPayReq
 *
 *  @return 合法返回 YES;不合法返回 NO;
 */
- (BOOL)checkParametersForReqPay:(BCBaseReq *)request;

/**
 *  获得支付参数成功，发起渠道支付。支持WX_APP\ALI_APP\UN_APP\BD_APP
 *
 *  @param channel 支付渠道
 *  @param dic     支付参数
 */
- (void)doPayAction:(PayChannel)channel source:(NSMutableDictionary *)dic;

#pragma mark - doResponse
/**
 *  执行错误回调
 *
 *  @param errMsg 错误信息
 */
- (void)doErrorResponse:(NSString *)errMsg;

/**
 *  服务端返回错误，执行错误回调
 *
 *  @param response 服务端返回参数
 */
- (void)getErrorInResponse:(id)response;

#pragma mark - QueryBill
/**
 *  查询支付\退款订单的回调
 *
 *  @param dic 订单列表数据
 */
- (void)doQueryResponse:(NSDictionary *)dic;

/**
 *  解析订单列表数据
 *
 *  @param dic 订单列表数据
 *
 *  @return 本地化后的订单列表，查询支付订单元素为BCQueryBillResult；查询退款订单元素为BCQueryRefundResult
 */
- (NSMutableArray *)parseResults:(NSDictionary *)dic;

/**
 *  解析单条订单数据
 *
 *  @param dic 单挑订单数据
 *
 *  @return BCQueryBillResult或BCQueryRefundResult
 */
- (BCBaseResult *)parseQueryResult:(NSDictionary *)dic;

#pragma mark - RefundStatus

/**
 *  退款状态查询回调
 *
 *  @param dic 退款状态信息
 */
- (void)doQueryRefundStatus:(NSDictionary *)dic;

@end
