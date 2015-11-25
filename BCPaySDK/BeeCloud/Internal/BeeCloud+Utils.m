//
//  BeeCloud+Utils.m
//  BCPay
//
//  Created by joseph on 15/11/6.
//  Copyright © 2015年 BeeCloud. All rights reserved.
//

#import "BeeCloud+Utils.h"
#import "BeeCloudAdapter.h"

@implementation BeeCloud (Utils)

#pragma mark private class functions

#pragma mark Pay Request

- (void)reqPay:(BCPayReq *)req {
    [BCPayCache sharedInstance].bcResp = [[BCPayResp alloc] initWithReq:req];
    if (![self checkParametersForReqPay:req]) return;
    
    NSString *cType = [BCPayUtil getChannelString:req.channel];
    
    NSMutableDictionary *parameters = [BCPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [self doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    
    parameters[@"channel"] = cType;
    parameters[@"total_fee"] = [NSNumber numberWithInteger:[req.totalFee integerValue]];
    parameters[@"bill_no"] = req.billNo;
    parameters[@"title"] = req.title;
    if (req.billTimeOut > 0) {
        parameters[@"bill_timeout"] = @(req.billTimeOut);
    }
    if (req.optional) {
        parameters[@"optional"] = req.optional;
    }
    
    AFHTTPRequestOperationManager *manager = [BCPayUtil getAFHTTPRequestOperationManager];
    __weak BeeCloud *weakSelf = [BeeCloud sharedInstance];
    
    [manager POST:[BCPayUtil getBestHostWithFormat:kRestApiPay] parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id response) {
              if ([response integerValueForKey:kKeyResponseResultCode defaultValue:BCErrCodeCommon] != 0) {
                  [weakSelf getErrorInResponse:(NSDictionary *)response];
              } else {
                  BCPayLog(@"channel=%@,resp=%@", cType, response);
                  [weakSelf doPayAction:req source:(NSDictionary *)response];
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [weakSelf doErrorResponse:kNetWorkError];
          }];
}

#pragma mark - Offline Pay

- (void)reqOfflinePay:(id)req {
    [BeeCloudAdapter beeCloudOfflinePay:[NSMutableDictionary dictionaryWithObjectsAndKeys:req, kAdapterOffline, nil]];
}

#pragma mark - OffLine BillStatus

- (void)reqOfflineBillStatus:(id)req {
    [BeeCloudAdapter beeCloudOfflineStatus:[NSMutableDictionary dictionaryWithObjectsAndKeys:req, kAdapterOffline, nil]];
}

#pragma mark - OffLine BillRevert

- (void)reqOfflineBillRevert:(id)req {
    [BeeCloudAdapter beeCloudOfflineRevert:[NSMutableDictionary dictionaryWithObjectsAndKeys:req, kAdapterOffline, nil]];
}

#pragma mark PayPal

- (void)reqPayPal:(BCPayPalReq *)req {
    [BeeCloudAdapter beeCloudPayPal:[NSMutableDictionary dictionaryWithObjectsAndKeys:req, kAdapterPayPal,nil]];
}

- (void)reqPayPalVerify:(BCPayPalVerifyReq *)req {
    [BeeCloudAdapter beeCloudPayPalVerify:[NSMutableDictionary dictionaryWithObjectsAndKeys:req, kAdapterPayPal, nil]];
}

#pragma mark Query Bills/Refunds

- (void)reqQueryOrder:(BCQueryReq *)req {
    [BCPayCache sharedInstance].bcResp = [[BCQueryResp alloc] initWithReq:req];
    if (req == nil) {
        [self doErrorResponse:@"请求结构体不合法"];
        return;
    }
    
    NSString *cType = [BCPayUtil getChannelString:req.channel];
    
    NSMutableDictionary *parameters = [BCPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [self doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    NSString *reqUrl = [BCPayUtil getBestHostWithFormat:kRestApiQueryBills];
    
    if (req.billNo.isValid) {
        parameters[@"bill_no"] = req.billNo;
    }
    if (req.startTime.isValid) {
        parameters[@"start_time"] = [NSNumber numberWithLongLong:[BCPayUtil dateStringToMillisencond:req.startTime]];
    }
    if (req.endTime.isValid) {
        parameters[@"end_time"] = [NSNumber numberWithLongLong:[BCPayUtil dateStringToMillisencond:req.endTime]];
    }
    if (req.type == BCObjsTypeQueryRefundReq) {
        BCQueryRefundReq *refundReq = (BCQueryRefundReq *)req;
        if (refundReq.refundNo.isValid) {
            parameters[@"refund_no"] = refundReq.refundNo;
        }
        reqUrl = [BCPayUtil getBestHostWithFormat:kRestApiQueryRefunds];
    }
    if (cType.isValid) {
        parameters[@"channel"] = cType;
    }
    parameters[@"skip"] = [NSNumber numberWithInteger:req.skip];
    parameters[@"limit"] =  req.limit > 50 ? @50 : [NSNumber numberWithInteger:req.limit];
    
    NSMutableDictionary *preparepara = [BCPayUtil getWrappedParametersForGetRequest:parameters];
    
    AFHTTPRequestOperationManager *manager = [BCPayUtil getAFHTTPRequestOperationManager];
    __weak BeeCloud *weakSelf = [BeeCloud sharedInstance];
    [manager GET:reqUrl parameters:preparepara
         success:^(AFHTTPRequestOperation *operation, id response) {
             BCPayLog(@"resp = %@", response);
             [weakSelf doQueryResponse:(NSDictionary *)response];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [weakSelf doErrorResponse:kNetWorkError];
         }];
}

#pragma mark Refund Status For WeChat

- (void)reqRefundStatus:(BCRefundStatusReq *)req {
    [BCPayCache sharedInstance].bcResp = [[BCRefundStatusResp alloc] initWithReq:req];
    if (req == nil) {
        [self doErrorResponse:@"请求结构体不合法"];
        return;
    }
    
    NSMutableDictionary *parameters = [BCPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [self doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    
    if (req.refundNo.isValid) {
        parameters[@"refund_no"] = req.refundNo;
    }
    parameters[@"channel"] = @"WX";
    
    NSMutableDictionary *preparepara = [BCPayUtil getWrappedParametersForGetRequest:parameters];
    
    AFHTTPRequestOperationManager *manager = [BCPayUtil getAFHTTPRequestOperationManager];
    __weak BeeCloud *weakSelf = [BeeCloud sharedInstance];
    [manager GET:[BCPayUtil getBestHostWithFormat:kRestApiRefundState] parameters:preparepara
         success:^(AFHTTPRequestOperation *operation, id response) {
             [weakSelf doQueryRefundStatus:(NSDictionary *)response];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [weakSelf doErrorResponse:kNetWorkError];
         }];
}

- (BOOL)checkParametersForReqPay:(BCBaseReq *)request {
    
    if (request == nil) {
        [self doErrorResponse:@"请求结构体不合法"];
    } else if (request.type == BCObjsTypePayReq) {
        BCPayReq *req = (BCPayReq *)request;
        if (!req.title.isValid || [BCPayUtil getBytes:req.title] > 32) {
            [self doErrorResponse:@"title 必须是长度不大于32个字节,最长16个汉字的字符串的合法字符串"];
            return NO;
        } else if (!req.totalFee.isValid || !req.totalFee.isPureInt) {
            [self doErrorResponse:@"totalfee 以分为单位，必须是只包含数值的字符串"];
            return NO;
        } else if (!req.billNo.isValid || !req.billNo.isValidTraceNo || (req.billNo.length < 8) || (req.billNo.length > 32)) {
            [self doErrorResponse:@"billno 必须是长度8~32位字母和/或数字组合成的字符串"];
            return NO;
        } else if ((req.channel == PayChannelAliApp) && !req.scheme.isValid) {
            [self doErrorResponse:@"scheme 不是合法的字符串，将导致无法从支付宝钱包返回应用"];
            return NO;
        } else if ((req.channel == PayChannelUnApp) && (req.viewController == nil)) {
            [self doErrorResponse:@"viewController 不合法，将导致无法正常执行银联支付"];
            return NO;
        } else if (req.channel == PayChannelWxApp && ![BeeCloudAdapter beeCloudIsWXAppInstalled]) {
            [self doErrorResponse:@"未找到微信客户端，请先下载安装"];
            return NO;
        }
        return YES;
    }
    return NO ;
}

#pragma mark - Pay Action

- (BOOL)doPayAction:(BCPayReq *)req source:(NSDictionary *)response {
    BOOL bSendPay = NO;
    if (response) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:
                                    (NSDictionary *)response];
        if (req.channel == PayChannelAliApp) {
            [dic setObject:req.scheme forKey:@"scheme"];
        } else if (req.channel == PayChannelUnApp) {
            [dic setObject:req.viewController forKey:@"viewController"];
        }
        [BCPayCache sharedInstance].bcResp.bcId = [dic objectForKey:@"id"];
        switch (req.channel) {
            case PayChannelWxApp:
                bSendPay = [BeeCloudAdapter beeCloudWXPay:dic];
                break;
            case PayChannelAliApp:
                bSendPay = [BeeCloudAdapter beeCloudAliPay:dic];
                break;
            case PayChannelUnApp:
                bSendPay = [BeeCloudAdapter beeCloudUnionPay:dic];
                break;
            case PayChannelBaiduApp:
                bSendPay = [BeeCloudAdapter beeCloudBaiduPay:dic].isValid;
                break;
            default:
                break;
        }
    }
    return bSendPay;
}

- (BCBaseResp *)doErrorResponse:(NSString *)errMsg {
    BCBaseResp *resp = [BCPayCache sharedInstance].bcResp;
    resp.resultCode = BCErrCodeCommon;
    resp.resultMsg = errMsg;
    resp.errDetail = errMsg;
    [BCPayCache beeCloudDoResponse];
    return resp;
}

- (BCBaseResp *)getErrorInResponse:(NSDictionary *)response {
    BCBaseResp *resp = [BCPayCache sharedInstance].bcResp;
    resp.resultCode = [response integerValueForKey:kKeyResponseResultCode defaultValue:BCErrCodeCommon];
    resp.resultMsg = [response stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
    resp.errDetail = [response stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
    [BCPayCache beeCloudDoResponse];
    return resp;
}

- (BCQueryResp *)doQueryResponse:(NSDictionary *)response {
    BCQueryResp *resp = (BCQueryResp *)[BCPayCache sharedInstance].bcResp;
    resp.resultCode = [response integerValueForKey:kKeyResponseResultCode defaultValue:BCErrCodeCommon];
    resp.resultMsg = [response stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
    resp.errDetail = [response stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
    resp.count = [response integerValueForKey:@"count" defaultValue:0];
    resp.results = [self parseResults:response];
    [BCPayCache beeCloudDoResponse];
    return resp;
}

- (NSMutableArray *)parseResults:(NSDictionary *)dic {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    if ([[dic allKeys] containsObject:@"bills"]) {
        for (NSDictionary *result in [dic arrayValueForKey:@"bills" defaultValue:nil]) {
            BCQueryBillResult *bill = (BCQueryBillResult *)[self parseQueryResult:result];
            if (bill) {
                [array addObject:bill];
            }
        } ;
    } else if ([[dic allKeys] containsObject:@"refunds"]) {
        for (NSDictionary *result in [dic arrayValueForKey:@"refunds" defaultValue:nil]) {
            BCQueryRefundResult *refund = (BCQueryRefundResult *)[self parseQueryResult:result];
            if (refund) {
                [array addObject:refund];
            }
        } ;
    }
    return array.count > 0 ? array : nil;
}

- (BCBaseResult *)parseQueryResult:(NSDictionary *)dic {
    if (dic) {
        if ([[dic allKeys] containsObject:@"spay_result"]) {
            return [[BCQueryBillResult alloc] initWithResult:dic];
        } else if ([[dic allKeys] containsObject:@"refund_no"]) {
            return [[BCQueryRefundResult alloc] initWithResult:dic];
        }
    }
    return nil;
}

- (BCRefundStatusResp *)doQueryRefundStatus:(NSDictionary *)dic {
    BCRefundStatusResp *resp = (BCRefundStatusResp *)[BCPayCache sharedInstance].bcResp;
    resp.resultCode = [dic integerValueForKey:kKeyResponseResultCode defaultValue:BCErrCodeCommon];
    resp.resultMsg = [dic stringValueForKey:kKeyResponseResultMsg defaultValue:kUnknownError];
    resp.errDetail = [dic stringValueForKey:kKeyResponseErrDetail defaultValue:kUnknownError];
    resp.refundStatus = [dic stringValueForKey:@"refund_status" defaultValue:@""];
    [BCPayCache beeCloudDoResponse];
    return resp;
}

@end
