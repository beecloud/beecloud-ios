//
//  BCPayTest.m
//  BCPaySDK
//
//  Created by Ewenlong03 on 15/7/21.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTestCase+AsyncTesting.h"
#import "BCPaySDK.h"
@interface BCPayTest : XCTestCase

@end

@implementation BCPayTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [BCPaySDK initWithAppID:@"c5d1cba1-5e3f-4ba0-941d-9b0a371fe719" andAppSecret:@"39a7a518-9ac8-4a9e-87bc-7885f33cf18c"];
    [BCPaySDK initWeChatPay:@"wxf1aa465362b4c8f1"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testQueryOrder {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *outTradeNo = [formatter stringFromDate:[NSDate date]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];
    NSLog(@"traceno = %@", outTradeNo);
    BCPayReq *payReq = [[BCPayReq alloc] init];
    payReq.channel = WX;
    payReq.title = @"test";
    payReq.totalfee = @"1";
    payReq.billno = outTradeNo;
    payReq.scheme = @"payTestDemo";
    payReq.viewController = nil;
    payReq.optional = dict;
    [BCPaySDK sendBCReq:payReq];
    [self waitForTimeout:3];
}

- (void)testQueryBills {
    BCQueryReq *req = [[BCQueryReq alloc] init];
    req.channel = WX;
    req.skip = 0;
    req.limit = 20;
    [BCPaySDK sendBCReq:req];
    [self waitForTimeout:2];
}

- (void)testQueryBillsByBillno {
    BCQueryReq *req = [[BCQueryReq alloc] init];
    req.channel = WX;
    req.billno = @"20150722164516738";
    req.skip = 0;
    req.limit = 10;
    [BCPaySDK sendBCReq:req];
    [self waitForTimeout:2];
}

- (void)testQueryBillsByTime {
    BCQueryReq *req = [[BCQueryReq alloc] init];
    req.channel = WX;
    req.starttime = @"201507150000";
    req.endtime = @"2015072310000";
    req.skip = 0;
    req.limit = 100;
    [BCPaySDK sendBCReq:req];
    [self waitForTimeout:2];
}

- (void)testQueryRefunds {
    BCQRefundReq *req = [[BCQRefundReq alloc] init];
    req.channel = WX;
    req.skip = 0;
    req.limit = 100;
    [BCPaySDK sendBCReq:req];
    [self waitForTimeout:10];
}

- (void)testQueryRefundsByRefundno {
    BCQRefundReq *req = [[BCQRefundReq alloc] init];
    req.channel = WX;
    req.refundno = @"20150722a693e55a";
    req.skip = 0;
    req.limit = 10;
    [BCPaySDK sendBCReq:req];
    [self waitForTimeout:10];
}

- (void)testQueryRefundsByTime {
    BCQRefundReq *req = [[BCQRefundReq alloc] init];
    req.channel = WX;
    req.starttime = @"201507150000";
    req.endtime = @"2015072310000";
    req.skip = 0;
    req.limit = 100;
    [BCPaySDK sendBCReq:req];
    [self waitForTimeout:10];
}



@end
