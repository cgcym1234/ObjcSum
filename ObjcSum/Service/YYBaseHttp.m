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

@property (nonatomic) AFHTTPRequestOperationManager *operationManager;
@property (nonatomic) AFHTTPSessionManager *sessoinManager;

@end

@implementation YYBaseHttp

+ (void)load {
    [YYUrlCache useCustomUrlCache];
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _operationManager = [AFHTTPRequestOperationManager manager];
        [_operationManager setRequestSerializer:[YYJsonRequestSerializer new]];
        [_operationManager setResponseSerializer:[YYJsonResponseSerializer new]];
    }
    return self;
}

#pragma mark - private

- (NSError *)errWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:HttpErrorDomain
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey :message}];
}

- (AFHTTPRequestOperation *)requestWithDelegate:(__weak id)delegate
                                     urlRequest:(NSMutableURLRequest *)request
                                completionBlock:(YYBaseHttpCompletionBlock)completion {
    AFHTTPRequestOperation *httpOperation = [self.operationManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (completion) {
            completion(responseObject, nil, operation);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (error.code == NSURLErrorCancelled) {
            return;
        }
        if (completion) {
            NSInteger code = operation.response ? operation.response.statusCode : error.code;
            NSString *errorMsg = error.localizedDescription;
            
            if (code == NSURLErrorTimedOut) {
                errorMsg = ErrorTimeOut;
            } else if (code == NSURLErrorNotConnectedToInternet) {
                errorMsg = ErrorNetworkUnvailable;
            } else {
                errorMsg = operation.responseObject;
            }
            
            if (!errorMsg) {
                errorMsg = @"无数据";//404
            }
            
            NSLog(@"requestFailed error=%@, responseCode=%ld, errorMsg=%@", error, (long)code, errorMsg);
            
            completion(nil, [self errWithCode:code message:errorMsg], operation);
        }
    }];
    
    [httpOperation setRedirectResponseBlock:^NSURLRequest * _Nonnull(NSURLConnection * _Nonnull connection, NSURLRequest * _Nonnull request, NSURLResponse * _Nonnull redirectResponse) {
        if (redirectResponse) {
            NSLog(@"redirectResponse=%@,request=%@",redirectResponse,request);
        }
        return request;
    }];
    
    return httpOperation;
}

#pragma mark - public
//全局设置请求头
- (void)setHttpRequestHeaderValue:(NSString *)value key:(NSString *)key {
    [self.operationManager.requestSerializer setValue:value forHTTPHeaderField:key];
}

/**
 *  取消网络请求
 */
- (void)cancelAllRequests {
    [self.operationManager.operationQueue cancelAllOperations];
}

- (NSURLRequest *)getUrl:(NSString *)urlString
              parameters:(NSDictionary *)parameters
         completionBlock:(YYBaseHttpCompletionBlock)completion {
    return [self requestWithDelegate:nil method:GET urlString:urlString parameters:parameters headers:nil useCache:IsUserCache removeCache:NO cacheExpiration:-1 progressBlock:nil completionBlock:completion];
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
                        progressBlock:(YYBaseHttpProgressBlock)progress
                      completionBlock:(YYBaseHttpCompletionBlock)completion {
//    NSMutableURLRequest *request = [self.operationManager.requestSerializer multipartFormRequestWithMethod:method URLString:urlString parameters:parameters constructingBodyWithBlock:NULL error:nil];
    NSMutableURLRequest *request = nil;
    
    //上传
    if (progress && [method isEqualToString:POST]) {
        request = [self.operationManager.requestSerializer multipartFormRequestWithMethod:method URLString:urlString parameters:parameters constructingBodyWithBlock:NULL error:nil];
    } else {
        request = [self.operationManager.requestSerializer requestWithMethod:method URLString:urlString parameters:parameters error:nil];
    }
    
    if (!request) {
        completion(nil, [self errWithCode:ErrorCodeCustomer message:ErrorArgument], nil);
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
    
    
    AFHTTPRequestOperation *operation = [self requestWithDelegate:delegate urlRequest:request completionBlock:completion];
    
    if (!operation) {
        completion(nil, [self errWithCode:ErrorCodeCustomer message:@"无法生成 AFHTTPRequestOperation"], nil);
        return request;
    }
    
    if (progress) {
        [operation setUploadProgressBlock:progress];
    }
    [self.operationManager.operationQueue addOperation:operation];
    
    return operation.request;
}
























@end
