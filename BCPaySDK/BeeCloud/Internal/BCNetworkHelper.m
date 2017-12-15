//
//  BCNetworking.m
//  BCPay
//
//  Created by Ewenlong03 on 2016/11/3.
//  Copyright © 2016年 BeeCloud. All rights reserved.
//

#import "BCNetworkHelper.h"
#import "BCURLRequestSerialization.h"

@implementation BCNetworkHelper

+ (void)getWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    NSMutableString *mutableUrl = [[NSMutableString alloc] initWithString:url];
    
    NSURL *nsurl = [NSURL URLWithString:mutableUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    NSString *query = BCQueryStringFromParameters(parameters);
    if (query && query.length > 0) {
        request.URL = [NSURL URLWithString:[[request.URL absoluteString] stringByAppendingFormat:request.URL.query ? @"&%@" : @"?%@", query]];
    }
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *new_response = (NSHTTPURLResponse *)response;
        if ([new_response statusCode] == 200) {
            //请求成功
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock(dic);
            });
        } else {
            //请求失败
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(error);
            });
        }
    }];
    [dataTask resume];
}

+ (void)postWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSURL *nsurl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    //如果想要设置网络超时的时间的话，可以使用下面的方法：
    //NSMutableURLRequest *mutableRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //设置请求类型
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSError *error = nil;
    //把参数放到请求体内
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *new_response = (NSHTTPURLResponse *)response;
        if ([new_response statusCode] == 200) {
            //请求成功
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock(dic);
            });
        } else {
            //请求失败
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(error);
            });
        }
    }];
    [dataTask resume];  //开始请求
}

+ (void)putWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSURL *nsurl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    //如果想要设置网络超时的时间的话，可以使用下面的方法：
    //NSMutableURLRequest *mutableRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //设置请求类型
    request.HTTPMethod = @"PUT";
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSError *error = nil;
    //把参数放到请求体内
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *new_response = (NSHTTPURLResponse *)response;
        if ([new_response statusCode] == 200) {
            //请求成功
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock(dic);
            });
        } else {
            //请求失败
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(error);
            });
        }
    }];
    [dataTask resume];  //开始请求
}


@end
