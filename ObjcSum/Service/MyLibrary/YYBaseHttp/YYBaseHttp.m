//
//  YYBaseHttp.m
//  ObjcSum
//
//  Created by sihuan on 15/10/31.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYBaseHttp.h"

#import "YYJsonRequestSerializer.h"
#import "YYHttpRequestSerializer.h"

#import "YYJsonResponseSerializer.h"

//http请求错误域
#define HttpErrorDomain   @"httpError"

#define  OPTIONS    @"OPTIONS"
#define  GET        @"GET"
#define  HEAD       @"HEAD"
#define  POST       @"POST"
#define  PUT        @"PUT"
#define  PATCH      @"PATCH"
#define  DELETE     @"DELETE"
#define  TRACE      @"TRACE"
#define  CONNECT    @"CONNECT"

#define ErrorCodeCustomer   -1
#define ErrorArgument   @"参数错误"
#define ErrorTimeOut   @"网络不给力,请重新尝试"
#define ErrorNetworkUnvailable   @"网络没有打开喔,请检查网络后重试"

@interface YYBaseHttp ()



@end

@implementation YYBaseHttp

+ (void)load {
    [YYUrlCache useCustomUrlCache];
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _sessoinManager = [AFHTTPSessionManager manager];
        [_sessoinManager setRequestSerializer:[YYJsonRequestSerializer new]];
        [_sessoinManager setResponseSerializer:[YYJsonResponseSerializer new]];
    }
    return self;
}

#pragma mark - private

- (NSError *)errWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:HttpErrorDomain
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey :message}];
}

#pragma mark - public
//全局设置请求头
- (void)setHttpRequestHeaderValue:(NSString *)value key:(NSString *)key {
    [self.sessoinManager.requestSerializer setValue:value forHTTPHeaderField:key];
}

/**
 *  取消网络请求
 */
- (void)cancelAllRequests {
    [self.sessoinManager.operationQueue cancelAllOperations];
}

- (NSURLRequest *)getUrlString:(NSString *)urlString
                    parameters:(NSDictionary *)parameters
                    completion:(YYBaseHttpCompletionBlock)completion {
    return [self requestWithDelegate:nil method:GET urlString:urlString parameters:parameters headers:nil useCache:IsUserCache removeCache:NO cacheExpiration:-1 uploadProgress:nil downloadProgress:nil completion:completion];
}

- (NSURLRequest *)postUrlString:(NSString *)urlString
                     parameters:(NSDictionary *)parameters
                     completion:(YYBaseHttpCompletionBlock)completion {
    return [self requestWithHttpMethod:POST urlString:urlString parameters:parameters headers:nil completion:completion];
}

- (NSURLRequest *)requestWithHttpMethod:(NSString *)method
                              urlString:(NSString *)urlString
                             parameters:(NSDictionary *)parameters
                                headers:(NSDictionary *)headers
                             completion:(YYBaseHttpCompletionBlock)completion {
    return [self requestWithDelegate:nil method:method urlString:urlString parameters:parameters headers:headers useCache:NO removeCache:NO cacheExpiration:-1 uploadProgress:nil downloadProgress:nil completion:completion];
}


/**
 *  发起一个http请求
 *
 *  @param delegate        代理
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
                       uploadProgress:(YYBaseHttpProgressBlock)uploadProgress
                     downloadProgress:(YYBaseHttpProgressBlock)downloadProgress
                           completion:(YYBaseHttpCompletionBlock)completion {
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [_sessoinManager.requestSerializer requestWithMethod:method URLString:[NSURL URLWithString:urlString relativeToURL:_sessoinManager.baseURL].absoluteString parameters:parameters error:&serializationError];
    if (serializationError) {
        if (completion) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(nil, serializationError, nil);
            });
        }
        return request;
    }
    
    if (headers) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [request setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    NSURLRequestCachePolicy cachePolicy = useCache ? NSURLRequestReturnCacheDataElseLoad : NSURLRequestReloadIgnoringLocalCacheData;
    [request setCachePolicy:cachePolicy];
    
    if (beRefreshCache) {
        [YYUrlCache removeCachedResponseForRequest:request];
    }
    
    if (cacheExpiration > 0) {
        [YYUrlCache setExpirationInterval:cacheExpiration forRequest:request];
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_sessoinManager dataTaskWithRequest:request uploadProgress:uploadProgress downloadProgress:downloadProgress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completion) {
            if (error) {
                NSInteger code = [(NSHTTPURLResponse *)response statusCode];
                NSString *errorMsg = error.localizedDescription;
                
                if (code == NSURLErrorTimedOut) {
                    errorMsg = ErrorTimeOut;
                } else if (code == NSURLErrorNotConnectedToInternet) {
                    errorMsg = ErrorNetworkUnvailable;
                } else {
                    errorMsg = responseObject;
                }
                
                if (!errorMsg) {
                    errorMsg = @"无数据";//404
                }
                
                NSLog(@"requestFailed error=%@, responseCode=%ld, errorMsg=%@", error, (long)code, errorMsg);
                
                completion(nil, [self errWithCode:code message:errorMsg], dataTask);
            } else {
                completion(responseObject, nil, dataTask);
            }
        }
    }];
    
    [dataTask resume];
    return request;
}
























@end
