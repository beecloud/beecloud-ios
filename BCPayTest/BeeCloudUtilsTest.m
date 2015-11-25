//
//  BCPayTests.m
//  BCPayTests
//
//  Created by joseph on 15/11/5.
//  Copyright © 2015年 BeeCloud. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCTestHeader.h"
#import "BeeCloud+Utils.h"

@interface BeeCloudUtilsTest : XCTestCase {
    BeeCloud *instance;
}

@end

@implementation BeeCloudUtilsTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [BeeCloud initWithAppID:TESTAPPID andAppSecret:TESTAPPSECRET];
    instance = [BeeCloud sharedInstance];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCheckParametersForReqPay {

    BCPayReq * req = [[BCPayReq alloc] init];
    
    req.title = @"";
    XCTAssertFalse([instance checkParametersForReqPay:req]);
    
    req.title = @"123456781234567812345678123456781";
    XCTAssertFalse([instance checkParametersForReqPay:req]);
    
    req.title = @"比可网络比可网络比可网络比可网络比可网络";
    XCTAssertFalse([instance checkParametersForReqPay:req]);
    
    req.title = @"test";
    req.totalFee = @"aaa";
    XCTAssertFalse([instance checkParametersForReqPay:req]);
    
    req.totalFee = @"";
    XCTAssertFalse([instance checkParametersForReqPay:req]);
    req.totalFee = @"-1";
    XCTAssertFalse([instance checkParametersForReqPay:req]);
    req.totalFee = @"99.00";
    XCTAssertFalse([instance checkParametersForReqPay:req]);
    
    req.totalFee = @"1";
    req.billNo = @"1212";
    XCTAssertFalse([instance checkParametersForReqPay:req]);
    
    req.billNo = @"abcdefgh&*&^";
    XCTAssertFalse([instance checkParametersForReqPay:req]);
    
    req.billNo = @"123456781234567812345678123456781";
    XCTAssertFalse([instance checkParametersForReqPay:req]);
    
    req.billNo = @"2015110616001200";
    req.channel = PayChannelAliApp;
    req.scheme = @"";
    XCTAssertFalse([instance checkParametersForReqPay:req]);
    
    req.channel = PayChannelUnApp;
    req.viewController = nil;
    XCTAssertFalse([instance checkParametersForReqPay:req]);
    
    req.channel = PayChannelWxApp;//因为没有安装微信，所以check失败
    XCTAssertFalse([instance checkParametersForReqPay:req]);
    
    req.channel = PayChannelBaiduApp;
    XCTAssertTrue([instance checkParametersForReqPay:req]);
}

- (void)test_doPayAction {
    BCPayReq *req = [[BCPayReq alloc] init];
    [BCPayCache sharedInstance].bcResp = [[BCPayResp alloc] initWithReq:req];
    
    req.channel = PayChannelWxApp;
    XCTAssertFalse([instance doPayAction:req source:@{}]);
    
    req.channel = PayChannelAliApp;
    req.scheme = @"test";
    XCTAssertFalse([instance doPayAction:req source:@{}]);
    
    req.channel = PayChannelUnApp;
    req.viewController = [[UIViewController alloc] init];
    XCTAssertFalse([instance doPayAction:req source:@{}]);
    
    req.channel = PayChannelBaiduApp;
    XCTAssertFalse([instance doPayAction:req source:@{}]);
    
    req.channel = PayChannelBaiduApp;
    XCTAssertFalse([instance doPayAction:req source:@{@"orderinfo":@"test"}]);
    
    req.channel = PayChannelBaiduApp;
    XCTAssertTrue([instance doPayAction:req source:@{@"orderInfo":@"test"}]);
}

- (void)test_doErrorResponse {
    BCBaseResp *resp = [instance doErrorResponse:@"BeeCloud"];
    XCTAssertEqual(@"BeeCloud",resp.resultMsg);
    XCTAssertEqual(@"BeeCloud", resp.errDetail);
    XCTAssertTrue(resp.resultCode == BCErrCodeCommon);
}

- (void)test_getErrorInResponse {
    
    BCBaseResp *resp = [instance getErrorInResponse:@{}];
    XCTAssertFalse(resp.resultCode == BCErrCodeSuccess);
    XCTAssertNotEqual(resp.resultMsg, @"OK");
    XCTAssertNotEqual(resp.errDetail, @"");
    
    resp = [instance getErrorInResponse:@{@"resultCode":@0,@"resultMsg":@"OK",@"errDetail":@""}];
    XCTAssertFalse(resp.resultCode == BCErrCodeSuccess);
    XCTAssertNotEqual(resp.resultMsg, @"OK");
    XCTAssertNotEqual(resp.errDetail, @"");
    
    resp = [instance getErrorInResponse:@{@"result_code":@0,@"result_msg":@"OK",@"err_detail":@""}];
    XCTAssertTrue(resp.resultCode == BCErrCodeSuccess);
    XCTAssertEqual(resp.resultMsg, @"OK");
    XCTAssertEqual(resp.errDetail, @"");
}

- (void)test_doQueryResponse {
    [BCPayCache sharedInstance].bcResp = [[BCQueryResp alloc] init];
    BCQueryResp *resp = [instance doQueryResponse:@{@"result_code":@0,@"result_msg":@"OK",@"err_detail":@""}];
    XCTAssertFalse(resp.count > 0);
    
    resp = [instance doQueryResponse:@{@"result_code":@0,@"result_msg":@"OK",@"err_detail":@"", @"count":@0}];
    XCTAssertTrue(resp.count==0);
}

- (void)test_parseResults {
    NSMutableArray *results = [instance parseResults:@{}];
    XCTAssertNil(results);
    
    results = [instance parseResults:@{@"bill":@""}];
    XCTAssertNil(results);
    
    results = [instance parseResults:@{@"bills":@""}];
    XCTAssertNil(results);
    
    results = [instance parseResults:@{@"bill":@[]}];
    XCTAssertNil(results);
    
    results = [instance parseResults:@{@"bills":@[@{@"title":@"test"}]}];
    XCTAssertNil(results);
    
    results = [instance parseResults:@{@"bills":@[@{@"title":@"test",@"pay_result":@YES}]}];
    XCTAssertNil(results);
    
    results = [instance parseResults:@{@"bills":@[@{@"title":@"test",@"spay_result":@YES}]}];
    XCTAssertNotNil(results);
    
    results = [instance parseResults:@{@"refund":@""}];
    XCTAssertNil(results);
    
    results = [instance parseResults:@{@"refunds":@""}];
    XCTAssertNil(results);
    
    results = [instance parseResults:@{@"refunds":@[]}];
    XCTAssertNil(results);
    
    results = [instance parseResults:@{@"refunds":@[@{@"title":@"test"}]}];
    XCTAssertNil(results);
    
    results = [instance parseResults:@{@"refunds":@[@{@"title":@"test",@"refundNo":@""}]}];
    XCTAssertNil(results);
    
    results = [instance parseResults:@{@"refunds":@[@{@"title":@"test",@"refund_no":@"2015010202"}]}];
    XCTAssertNotNil(results);
}

- (void)test_parseQueryResult {
    BCBaseResult *baseResult = [instance parseQueryResult:@{}];
    XCTAssertNil(baseResult);
    
    baseResult = [instance parseQueryResult:nil];
    XCTAssertNil(baseResult);
    
    baseResult = [instance parseQueryResult:@{@"spayResult":@YES}];
    XCTAssertNil(baseResult);
    
    baseResult = [instance parseQueryResult:@{@"spay_result":@YES}];
    XCTAssertNotNil(baseResult);
    
    baseResult = [instance parseQueryResult:@{@"refundNo":@YES}];
    XCTAssertNil(baseResult);
    
    baseResult = [instance parseQueryResult:@{@"refund_no":@""}];
    XCTAssertNotNil(baseResult);
}

- (void)test_doQueryRefundStatus {
    
    [BCPayCache sharedInstance].bcResp = [[BCRefundStatusResp alloc] init];
    
    BCRefundStatusResp *resp = [instance doQueryRefundStatus:nil];
    XCTAssertNil(resp.refundStatus);
    
    resp = [instance doQueryRefundStatus:@{@"refund":@"success"}];
    XCTAssertNotEqual(@"success",resp.refundStatus);
    
    resp = [instance doQueryRefundStatus:@{@"refund_status":@"success"}];
    XCTAssertEqual(@"success",resp.refundStatus);

}
@end
