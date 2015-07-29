//
//  BCPayObject.m
//  BCPaySDK
//
//  Created by Ewenlong03 on 15/7/21.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//
#import "BCPayObject.h"
#import <Foundation/Foundation.h>
#import "BCPayUtil.h"
#import "BCUtil.h"

#pragma makr base request
@implementation BCBaseReq
- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = 0;
    }
    return self;
}

@end

#pragma mark base response
@implementation BCBaseResp
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
@end

#pragma mark pay request
@implementation BCPayReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = 1;
    }
    return self;
}
@end

#pragma mark pay response
@implementation BCPayResp
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
@end

#pragma mark query request
@implementation BCQueryReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = 2;
        self.skip = 0;
        self.limit = 10;
        self.starttime = @"";
        self.endtime = @"";
        self.billno = @"";
    }
    return self;
}
@end

#pragma mark query response
@implementation BCQueryResp
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
@end

#pragma mark query refund request
@implementation BCQRefundReq

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = 3;
        self.refundno = @"";
    }
    return self;
}
@end

@implementation BCBaseResult

- (instancetype)init {
    self = [super init];
    if (self) {
        self.channel = @"";
        self.bill_no = @"";
        self.title = @"";
        self.created_time = @0;
        self.total_fee = @0;
    }
    return self;
}
@end

@implementation BCQBillsResult

- (instancetype)init {
    self = [super init];
    if (self) {
        self.spay_result = @NO;
    }
    return self;
}
@end

@implementation BCQRefundResult

- (instancetype)init {
    self = [super init];
    if (self) {
        self.refund_no = @"";
        self.refund_fee = @0;
        self.result = @NO;
        self.finish = @NO;
    }
    return self;
}

@end



