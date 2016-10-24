//
//  YYGCDTimer.h
//  MySimpleFrame
//
//  Created by sihuan on 15/6/13.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYGCDQueue.h"

@interface YYGCDTimer : NSObject

@property (nonatomic, strong, readonly) dispatch_source_t dispatchSource;

#pragma 初始化以及释放
- (instancetype)init;
- (instancetype)initInQueue:(YYGCDQueue *)queue;

#pragma 用法
- (void)event:(dispatch_block_t)block timeInterval:(NSTimeInterval)sec;
- (void)start;
- (void)destory;

/* demo
 YYGCDTimer *timer = [[YYGCDTimer alloc] init];
 
 //在指定que中运行
 //YYGCDTimer *timer = [[YYGCDTimer alloc] initInQueue:[YYGCDQueue globalQueue]];
 
 [timer event:^{
 // 每1秒执行一次你的event
 } timeInterval:1];
 
 [timer start];
 
 //此定时器不能暂停,只能销毁后释放掉对象.
 [timer destory];
 */
@end
