//
//  YYFoundation.m
//  MySimpleFrame
//
//  Created by sihuan on 15/5/12.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYFoundation.h"
#import <CoreData/CoreData.h>

static NSSet *_foundationClasses;

@implementation YYFoundation

+ (void)load {
    _foundationClasses = [NSSet setWithObjects:
                          [NSObject class],
                          [NSURL class],
                          [NSDate class],
                          [NSNumber class],
                          [NSDecimalNumber class],
                          [NSData class],
                          [NSMutableData class],
                          [NSArray class],
                          [NSMutableArray class],
                          [NSDictionary class],
                          [NSMutableDictionary class],
                          [NSManagedObject class],
                          [NSString class],
                          [NSMutableString class], nil];
}

#pragma mark - 判断是否NSString、NSNumber，NSDictionary等基本数据
+ (BOOL)isClassFromFoundation:(Class)c {
    return [_foundationClasses containsObject:c];
}

@end
