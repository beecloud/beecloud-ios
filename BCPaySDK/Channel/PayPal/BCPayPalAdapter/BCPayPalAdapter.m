//
//  BCPayPalAdapter.m
//  BeeCloud
//
//  Created by Ewenlong03 on 15/9/9.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "BCPayPalAdapter.h"
#import "BeeCloudAdapterProtocol.h"
#import "PayPalMobile.h"
#import "BCPayUtil.h"
#import "BCPayCache.h"

@interface BCPayPalAdapter ()<BeeCloudAdapterDelegate>

@property (nonatomic, assign) BOOL isSandBox;

@end

@implementation BCPayPalAdapter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static BCPayPalAdapter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[BCPayPalAdapter alloc] init];
    });
    return instance;
}

- (void)registerPayPal:(NSString *)clientID secret:(NSString *)secret sanBox:(BOOL)isSandBox {
    if(clientID.isValid && secret.isValid) {
        
        if (isSandBox) {
            [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"YOUR_PRODUCTION_CLIENT_ID",
                                                                   PayPalEnvironmentSandbox : clientID}];
            [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
        } else {
            [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : clientID,
                                                                   PayPalEnvironmentSandbox : @"YOUR_SANDBOX_CLIENT_ID"}];
            [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
        }
        
    }
}

- (void)payPal:(NSMutableDictionary *)dic {

    BCPayPalReq *req = (BCPayPalReq *)[dic objectForKey:kAdapterPayPal];
    [BCPayCache sharedInstance].bcResp.request = req;
    
    if (![self checkParameters:req]) return;
    
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:req.items];
    
    // Optional: include payment details
    NSDecimalNumber *dShipping = [[NSDecimalNumber alloc] initWithString:req.shipping];
    NSDecimalNumber *dTax = [[NSDecimalNumber alloc] initWithString:req.tax];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:dShipping
                                                                                    withTax:dTax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:dShipping] decimalNumberByAdding:dTax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = ((PayPalItem *)req.items.lastObject).currency;
    payment.shortDescription = req.shortDesc;
    payment.items = req.items;
    payment.paymentDetails = paymentDetails;
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:(PayPalConfiguration *)req.payConfig
                                                                                                     delegate:req.viewController];
    [(UIViewController *)req.viewController presentViewController:paymentViewController animated:YES completion:nil];
}

- (void)payPalVerify:(NSMutableDictionary *)dic {
    BCPayPalVerifyReq *req = (BCPayPalVerifyReq *)[dic objectForKey:kAdapterPayPal];
    [self reqPayPalAccessToken:req];
}

- (void)reqPayPalAccessToken:(BCPayPalVerifyReq *)req {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = NO;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:[BCPayCache sharedInstance].payPalClientID password:[BCPayCache sharedInstance].payPalSecret];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"client_credentials" forKey:@"grant_type"];
    __weak BCPayPalAdapter * weakSelf = [BCPayPalAdapter sharedInstance];
    [manager POST:[BCPayCache sharedInstance].isPayPalSandBox?kPayPalAccessTokenSandBox:kPayPalAccessTokenProduction parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        BCPayLog(@"token %@", response);
        NSDictionary *dic = (NSDictionary *)response;
        [weakSelf doPayPalVerify:req accessToken:[NSString stringWithFormat:@"%@ %@", [dic stringValueForKey:@"token_type" defaultValue:@""],[dic stringValueForKey:@"access_token" defaultValue:@""]]];
    }  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf doErrorResponse:kNetWorkError];
    }];
}

- (void)doPayPalVerify:(BCPayPalVerifyReq *)req accessToken:(NSString *)accessToken {
    
    if (req == nil || req.payment == nil) {
        [self doErrorResponse:@"请求参数格式不合法"];
        return ;
    }
    NSMutableDictionary *parameters = [BCPayUtil prepareParametersForRequest];
    if (parameters == nil) {
        [self doErrorResponse:@"请检查是否全局初始化"];
        return;
    }
    if ([BCPayCache sharedInstance].isPayPalSandBox) {
        parameters[@"channel"] = @"PAYPAL_SANDBOX";
    } else {
        parameters[@"channel"] = @"PAYPAL_LIVE";
    }
    if (req.optional) {
        parameters[@"optional"] = req.optional;
    }
    PayPalPayment *payment = (PayPalPayment *)req.payment;
    parameters[@"title"] = payment.shortDescription;
    parameters[@"total_fee"] = @((int)([payment.amount floatValue] * 100));
    parameters[@"currency"] = payment.currencyCode;
    parameters[@"bill_no"] = [[payment.confirmation[@"response"] objectForKey:@"id"] stringByReplacingOccurrencesOfString:@"PAY-" withString:@""];
    parameters[@"access_token"] = accessToken;
    
    AFHTTPRequestOperationManager *manager = [BCPayUtil getAFHTTPRequestOperationManager];
    __weak BCPayPalAdapter *weakSelf = [BCPayPalAdapter sharedInstance];
    [manager POST:[BCPayUtil getBestHostWithFormat:kRestApiPay] parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id response) {
              [weakSelf getErrorInResponse:response];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [weakSelf doErrorResponse:kNetWorkError];
          }];
}


- (BOOL)checkParameters:(BCBaseReq *)request {
    
    if (request == nil) {
        [self doErrorResponse:@"请求结构体不合法"];
    } else if (request.type == BCObjsTypePayPal) {
        BCPayPalReq *req = (BCPayPalReq *)request;
        if (req.items == nil || req.items.count == 0) {
            [self doErrorResponse:@"payitem 格式不合法"];
            return NO;
        } else if (!req.shipping.isValid) {
            [self doErrorResponse:@"shipping 格式不合法"];
            return NO;
        }  else if (!req.tax.isValid) {
            [self doErrorResponse:@"tax 格式不合法"];
            return NO;
        } else if (req.payConfig == nil || ![req.payConfig isKindOfClass:[PayPalConfiguration class]]) {
            [self doErrorResponse:@"payConfig 格式不合法"];
            return NO;
        } else if (req.viewController == nil) {
            [self doErrorResponse:@"viewController 格式不合法"];
            return NO;
        }
        return YES;
    }
    return NO ;
}

- (void)doErrorResponse:(NSString *)errMsg {
    BCBaseResp * resp = [BCPayCache sharedInstance].bcResp;
    resp.resultCode = BCErrCodeCommon;
    resp.resultMsg = errMsg;
    resp.errDetail = errMsg;
    [BCPayCache beeCloudDoResponse];
}

- (void)getErrorInResponse:(id)response {
    NSDictionary *dic = (NSDictionary *)response;
    BCBaseResp *resp = [BCPayCache sharedInstance].bcResp;
    resp.resultCode = [dic[kKeyResponseResultCode] intValue];
    resp.resultMsg = dic[kKeyResponseResultMsg];
    resp.errDetail = dic[kKeyResponseErrDetail];
    [BCPayCache beeCloudDoResponse];
}

@end
