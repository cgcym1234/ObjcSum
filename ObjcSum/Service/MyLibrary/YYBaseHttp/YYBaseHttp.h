//
//  YYBaseHttp.h
//  ObjcSum
//
//  Created by sihuan on 15/10/31.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YYUrlCache.h"
#import "AFNetworking.h"

static const BOOL IsUserCache = YES;


typedef void (^YYBaseHttpCompletionBlock)(id responseData, NSError *error, AFHTTPRequestOperation *operation);
typedef void (^YYBaseHttpProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

//typedef void(^YYBaseHttpSuccessBlock)(id responseData, AFHTTPRequestOperation *operation);
//typedef void(^YYBaseHttpFailureBlock)(NSError *error, AFHTTPRequestOperation *operation);

@interface YYBaseHttp : NSObject

/**
 *  全局设置请求头
 */
- (void)setHttpRequestHeaderValue:(NSString *)value key:(NSString *)key;

/**
 *  取消网络请求
 */
- (void)cancelAllRequests;

#pragma mark - Get

- (NSURLRequest *)getUrl:(NSString *)urlString
              parameters:(NSDictionary *)parameters
         completionBlock:(YYBaseHttpCompletionBlock)completion;

/**
 *  发起一个http请求
 *
 *  @param delegate        代理对象
 *  @param method          请求方式Get,post等
 *  @param urlString       url的字符串
 *  @param parameters      参数
 *  @param headers         设置请求头
 *  @param useCache        是否使用该url的缓存
 *  @param beRefreshCache  是否清除该url的缓存
 *  @param cacheExpiration 设置该url缓存的有效期
 *  @param progress        上传的回调
 *  @param completion      请求完成的回调，包含成功返回的数据或失败的信息
 *
 *  @return 请求的NSURLRequest
 */
- (NSURLRequest *)requestWithDelegate:(__weak id)delegate
                               method:(NSString *)method
                            urlString:(NSString *)urlString
                           parameters:(NSDictionary *)parameters
                              headers:(NSDictionary *)headers
                             useCache:(BOOL)useCache
                          removeCache:(BOOL)beRefreshCache
                      cacheExpiration:(NSTimeInterval)cacheExpiration
                        progressBlock:(YYBaseHttpProgressBlock)progress
                      completionBlock:(YYBaseHttpCompletionBlock)completion;


@end
