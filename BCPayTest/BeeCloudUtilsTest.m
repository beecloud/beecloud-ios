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

@interface BeeCloudUtilsTest : XCTestCase<BeeCloudDelegate> {
    int testId;
    BCBaseResp *testResp;
    BOOL bFinish;
}

@end

@implementation BeeCloudUtilsTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [BeeCloud initWithAppID:TESTAPPID andAppSecret:TESTAPPSECRET];
    [BeeCloud setBeeCloudDelegate:self];
    testId = 0;
    bFinish = NO;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testCheckParametersForReqPay {

    BeeCloud *instance = [BeeCloud sharedInstance];
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
    
    req.channel = PayChannelWxApp;
    XCTAssertFalse([instance checkParametersForReqPay:req]);
    
    req.channel = PayChannelBaiduApp;
    XCTAssertTrue([instance checkParametersForReqPay:req]);
}

- (void)test_reqPay {
    BCPayReq *req = [[BCPayReq init] alloc];
    req.title = @"BeeCloud";
    req.totalFee = @"1";
    req.billNo = @"2015111317050048";
    req.channel = PayChannelWxApp;
    req.scheme = @"BCTest";
    req.viewController = nil;
    
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(BeeCloudDelegate)];
    [BeeCloud setBeeCloudDelegate:mockDelegate];
    [mockDelegate verify];
    
    id manager = [OCMockObject mockForClass:[AFHTTPRequestOperationManager class]];
    [[manager expect] POST:kRestApiPay parameters:nil success:[OCMArg checkWithBlock:^BOOL(void (^successBlock)(AFHTTPRequestOperation *, id)) {
        
        return YES;
    }] failure:OCMOCK_ANY];
    
    
}

- (void)onBeeCloudResp:(BCBaseResp *)resp {
    testResp = resp;
    bFinish = YES;
}






@end
