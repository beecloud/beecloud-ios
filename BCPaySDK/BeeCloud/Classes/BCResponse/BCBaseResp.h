//
//  BCBaseResp.h
//  BCPaySDK
//
//  Created by Ewenlong03 on 15/7/27.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCPayConstant.h"
#import "BCBaseReq.h"
#pragma mark BCBaseResp
/**
 *  BeeCloud所有响应的基类
 */
@interface BCBaseResp : NSObject
/**
 *  响应的事件类型
 */
@property (nonatomic, assign) BCObjsType type;//200;
/** 
 *  响应码
 */
@property (nonatomic, assign) NSInteger resultCode;
/** 
 *  响应提示字符串 
 */
@property (nonatomic, retain) NSString *resultMsg;
/** 
 *  错误详情 
 */
@property (nonatomic, retain) NSString *errDetail;
/** 
 *  请求体  
 */
@property (nonatomic, retain) BCBaseReq *request;
/** 
 *  成功下单后返回支付表记录唯一标识;
 *  根据id查询支付或退款订单时,传入的bcId
 */
@property (nonatomic, retain) NSString *bcId;

/**
 *  初始化一个响应结构体
 *
 *  @param request 请求结构体
 *
 *  @return 响应结构体
 */
- (instancetype)initWithReq:(BCBaseReq *)request;

@end
