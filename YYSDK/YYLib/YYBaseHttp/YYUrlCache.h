//
//  YYUrlCache.h
//  ObjcSum
//
//  Created by sihuan on 15/11/2.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CacheExpirationInterval  (60*60*24*7)               //缓存持续时间，秒为单位
#define RequestTimeoutInterval  (60)                        //请求超时时间，秒为单位
#define MemoryCapacity                   10                   //缓存 用于内存的容量限制，M为单位
#define DiskCapacity                     2000                 //缓存 用于磁盘的容量限制，M为单位

#define KeyExpirationInterval            @"ExpirationInterval"//cookie和userinfo中的KEY
#define KeyCachedDate             @"KeyCachedDate"

@interface YYUrlCache : NSURLCache

+ (instancetype)sharedInstance;

/**
 *  设置使用YYUrlCache替换默认的NSURLCache
 */
+ (void)useCustomUrlCache;

/**
 *  设置cookie里的cache有效时间
 *
 *  @param request            请求
 *  @param expirationInterval 超时时间（秒）
 */
+ (void)setExpirationInterval:(NSTimeInterval)expirationInterval forRequest:(NSMutableURLRequest *)request;

/**
 *  清除缓存
 *
 *  @param request url的请求
 */
+ (void)removeCachedResponseForRequest:(NSURLRequest *)request;


@end
