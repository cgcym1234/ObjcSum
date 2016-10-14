//
//  NSHTTPCookie+YYExtension.m
//  ObjcSum
//
//  Created by sihuan on 16/1/4.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "NSHTTPCookie+YYExtension.h"

@implementation NSHTTPCookie (YYExtension)

+ (NSHTTPCookie *)cookieWithName:(NSString *)name value:(NSString *)value domain:(NSString *)domain path:(NSString *)path expires:(NSDate *)expires {
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    
    [cookieProperties setValue:name forKey:NSHTTPCookieName];
    [cookieProperties setValue:value forKey:NSHTTPCookieValue];
    
    if (domain) {
        [cookieProperties setValue:domain forKey:NSHTTPCookieDomain];
    }
    if (path) {
        [cookieProperties setValue:path forKey:NSHTTPCookiePath];
    }
    if (expires) {
        [cookieProperties setValue:expires forKey:NSHTTPCookieExpires];
//        [cookieProperties setValue:expires forKey:NSHTTPCookieMaximumAge];
    }
    
    /**
     *  如果设置了NSHTTPCookieDiscard，那么表示是会话Cookie
     再设置NSHTTPCookieExpires或NSHTTPCookieMaximumAge都无效
     */
    [cookieProperties setValue:@(NO) forKey:NSHTTPCookieDiscard];
    
    return [[NSHTTPCookie alloc] initWithProperties:cookieProperties];
}

@end
