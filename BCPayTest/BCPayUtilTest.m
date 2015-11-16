//
//  BCPayUtilTest.m
//  BCPay
//
//  Created by joseph on 15/11/7.
//  Copyright © 2015年 BeeCloud. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCPayUtil.h"
#import "BCTestHeader.h"

@interface BCPayUtilTest : XCTestCase

@end

@implementation BCPayUtilTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [BeeCloud initWithAppID:TESTAPPID andAppSecret:TESTAPPSECRET];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testGetAFHTTPRequestOperationManager {
    XCTAssertNotNil([BCPayUtil getAFHTTPRequestOperationManager]);
}

- (void)testGetWrappedParametersForGetRequest {
    NSMutableDictionary * getParams = [BCPayUtil getWrappedParametersForGetRequest:@{@"key1": @"key2"}];
    XCTAssertTrue([[getParams allKeys] containsObject:@"para"]);
}

- (void)testPrepareParametersForRequest {
    NSMutableDictionary *params = [BCPayUtil prepareParametersForRequest];
    XCTAssertNotNil(params);
    XCTAssertNotNil([params objectForKey:@"app_id"]);
    XCTAssertNotNil([params objectForKey:@"app_sign"]);
    XCTAssertNotNil([params objectForKey:@"timestamp"]);
}

- (void)testGetUrlType {
    NSURL *url = [NSURL URLWithString:@"wxtest://pay?test=yes"];
    XCTAssertTrue(BCPayUrlWeChat == [BCPayUtil getUrlType:url]);
    
    url = [NSURL URLWithString:@"alipay://safepay?test=yes"];
    XCTAssertTrue(BCPayUrlAlipay == [BCPayUtil getUrlType:url]);
    
    url = [NSURL URLWithString:@"beecloud://pay?test=no"];
    XCTAssertTrue(BCPayUrlUnknown == [BCPayUtil getUrlType:url]);
}

- (void)testGetBestHostWithFormat {
    XCTAssertNotNil([BCPayUtil getBestHostWithFormat:@"%@/1/rest/bill"]);
}

- (void)testGetChannelString {
    XCTAssertTrue([@"WX" isEqualToString:[BCPayUtil getChannelString:PayChannelWx]]);
    XCTAssertTrue([@"WX_APP" isEqualToString:[BCPayUtil getChannelString:PayChannelWxApp]]);
    XCTAssertTrue([@"WX_NATIVE" isEqualToString:[BCPayUtil getChannelString:PayChannelWxNative]]);
    XCTAssertTrue([@"WX_JSAPI" isEqualToString:[BCPayUtil getChannelString:PayChannelWxJsApi]]);
    XCTAssertTrue([@"WX_SCAN"isEqualToString: [BCPayUtil getChannelString:PayChannelWxScan]]);
    
    XCTAssertTrue([@"ALI" isEqualToString:[BCPayUtil getChannelString:PayChannelAli]]);
    XCTAssertTrue([@"ALI_APP" isEqualToString: [BCPayUtil getChannelString:PayChannelAliApp]]);
    XCTAssertTrue([@"ALI_WEB" isEqualToString:[BCPayUtil getChannelString:PayChannelAliWeb]]);
    XCTAssertTrue([@"ALI_WAP" isEqualToString:[BCPayUtil getChannelString:PayChannelAliWap]]);
    XCTAssertTrue([@"ALI_QRCODE" isEqualToString:[BCPayUtil getChannelString:PayChannelAliQrCode]]);
    XCTAssertTrue([@"ALI_OFFLINE_QRCODE" isEqualToString: [BCPayUtil getChannelString:PayChannelAliOfflineQrCode]]);
    XCTAssertTrue([@"ALI_SCAN" isEqualToString: [BCPayUtil getChannelString:PayChannelAliScan]]);
    
    XCTAssertTrue([@"UN" isEqualToString: [BCPayUtil getChannelString:PayChannelUn]]);
    XCTAssertTrue([@"UN_APP" isEqualToString: [BCPayUtil getChannelString:PayChannelUnApp]]);
    XCTAssertTrue([@"UN_WEB" isEqualToString: [BCPayUtil getChannelString:PayChannelUnWeb]]);
    
    XCTAssertTrue([@"BD" isEqualToString:[BCPayUtil getChannelString:PayChannelBaidu]]);
    XCTAssertTrue([@"BD_APP" isEqualToString: [BCPayUtil getChannelString:PayChannelBaiduApp]]);
    XCTAssertTrue([@"BD_WEB" isEqualToString: [BCPayUtil getChannelString:PayChannelBaiduWeb]]);
    XCTAssertTrue([@"BD_WAP" isEqualToString: [BCPayUtil getChannelString:PayChannelBaiduWap]]);
    
    XCTAssertTrue([@"PAYPAL" isEqualToString: [BCPayUtil getChannelString:PayChannelPayPal]]);
    XCTAssertTrue([@"PAYPAL_LIVE" isEqualToString: [BCPayUtil getChannelString:PayChannelPayPalLive]]);
    XCTAssertTrue([@"PAYPAL_SANDBOX" isEqualToString: [BCPayUtil getChannelString:PayChannelPayPalSanBox]]);
}

- (void)testGenerateRandomUUID {
    XCTAssertTrue([BCPayUtil generateRandomUUID].length == 36);
}

- (void)testMillisecondToDate {
    NSString * dateString1 = [BCPayUtil dateToString:[NSDate date]];
    long long timeStamp = [BCPayUtil dateStringToMillisencond:dateString1];
    NSString *dateString2 = [BCPayUtil millisecondToDateString:timeStamp];
    XCTAssertTrue([dateString1 isEqualToString: dateString2]);
}

- (void)testIsValidEmail {
    XCTAssertTrue([BCPayUtil isValidEmail:@"hwl@beecloud.cn"]);
    XCTAssertFalse([BCPayUtil isValidEmail:@"12?/@beecloud.cn"]);
    XCTAssertFalse([BCPayUtil isValidEmail:@"dwojodwjo.cn"]);
    XCTAssertFalse([BCPayUtil isValidEmail:@"@beecloud.cn"]);
}


- (void)testIsValidMobile {
    XCTAssertFalse([BCPayUtil isValidMobile:@"0125363"]);
    XCTAssertFalse([BCPayUtil isValidMobile:@"1381562711a"]);
    XCTAssertFalse([BCPayUtil isValidMobile:@"33815627115"]);
}

- (void)testIsLetter {
    XCTAssertFalse([BCPayUtil isLetter:'&']);
    XCTAssertFalse([BCPayUtil isLetter:'1']);
}

- (void)testIsDigit {
    XCTAssertFalse([BCPayUtil isDigit:'a']);
    XCTAssertFalse([BCPayUtil isDigit:'*']);
}

- (void)testGetBytes {
    XCTAssertTrue([BCPayUtil getBytes:@"wo"] == 2);
    XCTAssertTrue([BCPayUtil getBytes:@"我"] == 2);
}

@end
