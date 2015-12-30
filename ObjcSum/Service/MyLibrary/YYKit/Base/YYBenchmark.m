//
//  YYBenchmark.m
//  ObjcSum
//
//  Created by sihuan on 15/12/29.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYBenchmark.h"
#import <QuartzCore/QuartzCore.h>

/**
 *  dispatch_benchmark 是 libdispatch (Grand Central Dispatch) 的一部分。但严肃地说，这个方法并没有被公开声明，所以你必须要自己声明：
 *
 *  @param count  block执行次数
 *  @param ^block 要执行的block
 *
 *  @return 消耗时间,单位ns 纳秒
 */
extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));

@implementation YYBenchmark

/**
 *  开始测试，主线程中执行block代码
 */
+ (NSTimeInterval)start:(void(^)())block {
    if (!block) {
        return 0;
    }
    
    #pragma mark - 第一种,使用CACurrentMediaTime
    
    /** 使用mach_absolute_time和CACurrentMediaTime的好处：
     *  mach_absolute_time() 和 CACurrentMediaTime() 是基于内建时钟的，
     能够更精确更原子化地测量，并且不会因为外部时间变化而变化（例如时区变化、夏时制、秒突变等）
     */
//    NSTimeInterval startTime = CACurrentMediaTime();
//    block();
//    NSTimeInterval endTime = CACurrentMediaTime();
//    return (endTime - startTime)*1000;
    
    #pragma mark - 第二种，使用dispatch_benchmark
    
    /**
     *  相比之前的秒计时，纳秒更加精确，dispatch_benchmark 也比手动写循环的 CFAbsoluteTimeGetCurrent() 语法结构上看起来更好。
     */
    uint64_t cost = dispatch_benchmark(1, block);
    return cost / 1000000.0;
}

@end
