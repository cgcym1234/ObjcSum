//
//  NSObject+YYMessage.m
//  ObjcSum
//
//  Created by sihuan on 16/1/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "NSObject+YYMessage.h"

@implementation NSObject (YYMessage)

/**
 *  @return 类名
 */
+ (NSString *)className {
    return NSStringFromClass([self class]);
}
- (NSString *)className {
    return NSStringFromClass([self class]);
}

@end
