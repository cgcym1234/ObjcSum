//
//  NSObject+Extention.m
//  KKouNew
//
//  Created by huansi on 14-8-27.
//  Copyright (c) 2014年 KKOU. All rights reserved.
//

#import "NSObject+Extention.h"
#import "YYFoundation.h"
#import <objc/runtime.h>

@implementation NSObject (Extention)

- (NSString *)toString
{
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    } else if ([self isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", self];
    }
    return @"";
}

#pragma mark - 创建一个自己的拷贝
- (id)getCopyOfSelf {
    if ([self isKindOfClass:[NSURL class]]
        || [self isKindOfClass:[NSURL class]]
        || [self isKindOfClass:[NSDate class]]
        || [self isKindOfClass:[NSNumber class]]
        || [self isKindOfClass:[NSDecimalNumber class]]
        || [self isKindOfClass:[NSData class]]
        || [self isKindOfClass:[NSMutableData class]]
        || [self isKindOfClass:[NSArray class]]
        || [self isKindOfClass:[NSMutableArray class]]
        || [self isKindOfClass:[NSDictionary class]]
        || [self isKindOfClass:[NSMutableDictionary class]]
        || [self isKindOfClass:[NSString class]]
        || [self isKindOfClass:[NSMutableString class]]) {
        return [self mutableCopy];
    }
    id newObj = [[self.class alloc] init];
    NSArray *propertyArr = [self getPropertyList];
    for (NSString *key in propertyArr) {
        [newObj setValue:[self valueForKey:key] forKey:key];
    }
    return newObj;
}

#pragma mark - 获取属性列表
- (NSArray *)getPropertyList{
    return [self getPropertyList:[self class]];
}

- (NSArray *)getPropertyList: (Class)clazz
{
    u_int count;
    objc_property_t *properties  = class_copyPropertyList(clazz, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject: [NSString  stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    
    return propertyArray;
}


#pragma mark - 根据类名来实例化对象,
+ (id)instanceFromString:(NSString *)clsName{
    Class cls = NSClassFromString(clsName);
    if (cls) {
        return [[cls alloc] init];
    }
    return nil;
}

@end
