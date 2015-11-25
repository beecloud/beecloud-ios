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
    XCTAssertEqualObjects(@"WX", [BCPayUtil getChannelString:PayChannelWx]);
    XCTAssertEqualObjects(@"WX_APP", [BCPayUtil getChannelString:PayChannelWxApp]);
    XCTAssertEqualObjects(@"WX_NATIVE", [BCPayUtil getChannelString:PayChannelWxNative]);
    XCTAssertEqualObjects(@"WX_JSAPI", [BCPayUtil getChannelString:PayChannelWxJsApi]);
    XCTAssertEqualObjects(@"WX_SCAN", [BCPayUtil getChannelString:PayChannelWxScan]);
    
    XCTAssertEqualObjects(@"ALI", [BCPayUtil getChannelString:PayChannelAli]);
    XCTAssertEqualObjects(@"ALI_APP", [BCPayUtil getChannelString:PayChannelAliApp]);
    XCTAssertEqualObjects(@"ALI_WEB", [BCPayUtil getChannelString:PayChannelAliWeb]);
    XCTAssertEqualObjects(@"ALI_WAP", [BCPayUtil getChannelString:PayChannelAliWap]);
    XCTAssertEqualObjects(@"ALI_QRCODE", [BCPayUtil getChannelString:PayChannelAliQrCode]);
    XCTAssertEqualObjects(@"ALI_OFFLINE_QRCODE", [BCPayUtil getChannelString:PayChannelAliOfflineQrCode]);
    XCTAssertEqualObjects(@"ALI_SCAN", [BCPayUtil getChannelString:PayChannelAliScan]);
    
    XCTAssertEqualObjects(@"UN", [BCPayUtil getChannelString:PayChannelUn]);
    XCTAssertEqualObjects(@"UN_APP", [BCPayUtil getChannelString:PayChannelUnApp]);
    XCTAssertEqualObjects(@"UN_WEB", [BCPayUtil getChannelString:PayChannelUnWeb]);
    
    XCTAssertEqualObjects(@"BD", [BCPayUtil getChannelString:PayChannelBaidu]);
    XCTAssertEqualObjects(@"BD_APP", [BCPayUtil getChannelString:PayChannelBaiduApp]);
    XCTAssertEqualObjects(@"BD_WEB", [BCPayUtil getChannelString:PayChannelBaiduWeb]);
    XCTAssertEqualObjects(@"BD_WAP", [BCPayUtil getChannelString:PayChannelBaiduWap]);
    
    XCTAssertEqualObjects(@"PAYPAL", [BCPayUtil getChannelString:PayChannelPayPal]);
    XCTAssertEqualObjects(@"PAYPAL_LIVE", [BCPayUtil getChannelString:PayChannelPayPalLive]);
    XCTAssertEqualObjects(@"PAYPAL_SANDBOX", [BCPayUtil getChannelString:PayChannelPayPalSanBox]);
}

- (void)testGenerateRandomUUID {
    XCTAssertEqual([BCPayUtil generateRandomUUID].length, 36);
}

- (void)testMillisecondToDate {
    NSString * dateString1 = [BCPayUtil dateToString:[NSDate date]];
    long long timeStamp = [BCPayUtil dateStringToMillisencond:dateString1];
    NSString *dateString2 = [BCPayUtil millisecondToDateString:timeStamp];
    XCTAssertEqualObjects(dateString1, dateString2);
}

- (void)testIsValidEmail {
    XCTAssertFalse([BCPayUtil isValidEmail:@"12?/@beecloud.cn"]);
    XCTAssertFalse([BCPayUtil isValidEmail:@"dwojodwjo.cn"]);
    XCTAssertFalse([BCPayUtil isValidEmail:@"@beecloud.cn"]);
    
    XCTAssertTrue([BCPayUtil isValidEmail:@"hwl@beecloud.cn"]);
}


- (void)testIsValidMobile {
    XCTAssertFalse([BCPayUtil isValidMobile:@"0125363"]);
    XCTAssertFalse([BCPayUtil isValidMobile:@"1381562711a"]);
    XCTAssertFalse([BCPayUtil isValidMobile:@"33815627115"]);
    XCTAssertTrue([BCPayUtil isValidMobile:@"13305120512"]);
}

- (void)testIsLetter {
    XCTAssertFalse([BCPayUtil isLetter:'&']);
    XCTAssertFalse([BCPayUtil isLetter:'1']);
    XCTAssertTrue([BCPayUtil isLetter:'A']);
}

- (void)testIsDigit {
    XCTAssertFalse([BCPayUtil isDigit:'a']);
    XCTAssertFalse([BCPayUtil isDigit:'*']);
    XCTAssertTrue([BCPayUtil isDigit:'1']);
}

- (void)testGetBytes {
    XCTAssertTrue([BCPayUtil getBytes:@"wo"] == 2);
    XCTAssertTrue([BCPayUtil getBytes:@"我"] == 2);
    XCTAssertFalse([BCPayUtil getBytes:@"1"] == 2);
}

@end
