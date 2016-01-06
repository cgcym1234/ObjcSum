//
//  NSHTTPCookie+YYExtension.h
//  ObjcSum
//
//  Created by sihuan on 16/1/4.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPCookie (YYExtension)

+ (NSHTTPCookie *)cookieWithName:(NSString *)name value:(NSString *)value domain:(NSString *)domain path:(NSString *)path expires:(NSDate *)expires;
@end
