//
//  YYUrlCache.m
//  ObjcSum
//
//  Created by sihuan on 15/11/2.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYUrlCache.h"

@implementation YYUrlCache

#pragma mark - Public

+ (instancetype)sharedInstance {
    static YYUrlCache *_standardURLCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _standardURLCache = [[YYUrlCache alloc]
                             initWithMemoryCapacity:(MemoryCapacity * 1024 * 1024)
                             diskCapacity:(DiskCapacity * 1024 * 1024)
                             diskPath:nil];
    });
    return _standardURLCache;
}

/**
 *  设置使用YYUrlCache
 */
+ (void)useCustomUrlCache {
    [NSURLCache setSharedURLCache:[YYUrlCache sharedInstance]];
}

/**
 *  设置cookie里的cache有效时间
 *
 *  @param request            请求
 *  @param expirationInterval 超时时间（秒）
 */
+ (void)setExpirationInterval:(NSTimeInterval)expirationInterval forRequest:(NSMutableURLRequest *)request {
    NSTimeInterval interval = expirationInterval > 0 ? expirationInterval : CacheExpirationInterval;
    [request setValue:[@(interval) stringValue] forKey:KeyExpirationInterval];
}

/**
 *  清除缓存
 *
 *  @param request url的请求
 */
+ (void)removeCachedResponseForRequest:(NSURLRequest *)request {
    [[YYUrlCache sharedInstance] removeCachedResponseForRequest:request];
}

#pragma mark - overwrite

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:request];
    if (cachedResponse) {
        NSDate *cacheData = cachedResponse.userInfo[KeyCachedDate];
        NSNumber *interval = cachedResponse.userInfo[KeyExpirationInterval];
        if ([self isOverdue:cacheData expirationInterval:interval.doubleValue]) {
            return nil;
        }
    }
    return cachedResponse;
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request {
    NSMutableDictionary *userInfo = [self buildUserInfo:cachedResponse forRequest:request];
    NSCachedURLResponse *modifiedCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response
                                                                                           data:cachedResponse.data
                                                                                       userInfo:userInfo
                                                                                  storagePolicy:cachedResponse.storagePolicy];
    [super storeCachedResponse:modifiedCachedResponse forRequest:request];
}

#pragma mark - Private
- (BOOL)isOverdue:(NSDate *)data expirationInterval:(NSTimeInterval)expirationInterval
{
    NSDate *overdueData = [data dateByAddingTimeInterval:expirationInterval];
    return [overdueData compare:[NSDate date]] == NSOrderedAscending;
}

- (NSMutableDictionary *)buildUserInfo:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:cachedResponse.userInfo];
    userInfo[KeyCachedDate] = [NSDate date];
    userInfo[KeyExpirationInterval] = [self interval:cachedResponse forRequest:request];
    return userInfo;
}

- (NSNumber *)interval:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request {
    NSString *intervalString = [request valueForHTTPHeaderField:KeyExpirationInterval];
    if (intervalString) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        return [formatter numberFromString:intervalString];
    }
    return @(CacheExpirationInterval);
}

@end
