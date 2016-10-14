//
//  YYBenchmark.h
//  ObjcSum
//
//  Created by sihuan on 15/12/29.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 性能测试

@interface YYBenchmark : NSObject

/**
 *  开始测试，在主线程中执行block代码，
 返回消耗时间 毫秒
 */
+ (NSTimeInterval)start:(void(^)())block;

@end
