//
//  YYGlobalTimer.h
//  ObjcSum
//
//  Created by yangyuan on 2016/10/23.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define YYGlobalTimerInterval  0.1
/* 每隔0.1秒执行一次的定时器
 1. 定时器运行在主线程中，滑动时也会运行，没有任务时，不执行
 2. 添加和移除操作是线程安全的
 3. 可以选择任务运行在主线程或Global线程中
 4. 当target释放时，上面的任务会被自动清除掉
 */

typedef void (^YYGlobalTimerHandler)();

@interface YYGlobalTimer : NSObject

/// 添加任务,添加一个任务后timer会自动开始
///
/// - parameter target:      任务的目标对象
/// - parameter key:         任务的名字
/// - parameter executedInMainThread: 是否在主线程中执行
/// - parameter action:      action
+ (void)addTaskForTarget:(nonnull id)taget
                     key:(nonnull NSString *)key
                  action:(nonnull YYGlobalTimerHandler)action
    executedInMainThread:(BOOL)executedInMainThread;

+ (void)addTaskForKey:(nonnull NSString *)key
               action:(nonnull YYGlobalTimerHandler)action
 executedInMainThread:(BOOL)executedInMainThread;


/**
 移除任务，没有任务的话会自动停止
 */
+ (void)removeTaskForTarget:(nonnull id)target
                        key:(nonnull NSString *)key;
+ (void)removeTaskForTarget:(nonnull id)taget;
+ (void)removeTaskForKey:(nonnull NSString *)key;
+ (void)removeAllTask;

@end
