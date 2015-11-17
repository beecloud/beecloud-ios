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
#import "OCMock.h"

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
    XCTAssertTrue([instance doPayAction:req source:@{@"orderInfo":@"test"}]);
}

@end
