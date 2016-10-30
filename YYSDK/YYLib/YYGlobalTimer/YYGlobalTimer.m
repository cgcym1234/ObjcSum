//
//  YYGlobalTimer.m
//  ObjcSum
//
//  Created by yangyuan on 2016/10/23.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYGlobalTimer.h"

#pragma mark - YYGlobalTimerTask

@interface YYGlobalTimerTask : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *targetName;

@property (nonatomic, copy) YYGlobalTimerHandler task;
@property (nonatomic, copy) NSString *taskName;

@property (nonatomic, assign) BOOL executedInMainThread;

+ (instancetype)instanceWithTarget:(id)taget
                        targetName:(NSString *)targetName
                              task:(YYGlobalTimerHandler)task
                          taskName:(NSString *)targetName
              executedInMainThread:(BOOL)executedInMainThread;

@end

@implementation YYGlobalTimerTask

+ (instancetype)instanceWithTarget:(id)target
                        targetName:(NSString *)targetName
                              task:(YYGlobalTimerHandler)task
                          taskName:(NSString *)taskName
              executedInMainThread: (BOOL)executedInMainThread {
    YYGlobalTimerTask *item = [YYGlobalTimerTask new];
    item.target = target;
    item.targetName = targetName;
    item.task = task;
    item.taskName = taskName;
    item.executedInMainThread = executedInMainThread;
    
    return item;
}

@end

#pragma mark - YYGlobalTimer

typedef NSMutableDictionary<NSString *, YYGlobalTimerTask *> YYGlobalTimerTaskDict;

@interface YYGlobalTimer ()

//保证添加和移除线程安全
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, YYGlobalTimerTaskDict *> *targetTasksDict;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL running;
@end

@implementation YYGlobalTimer

+ (nonnull instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (nonnull instancetype)init {
    if (self = [super init]) {
        _targetTasksDict = [NSMutableDictionary new];
        _serialQueue = dispatch_queue_create("YYGlobalTimer", DISPATCH_QUEUE_SERIAL);
        _timer = [[NSTimer alloc] initWithFireDate:[NSDate distantFuture] interval:YYGlobalTimerInterval target:self selector:@selector(timerTask) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
        [self pause];
    }
    return self;
}

#pragma mark - Task

- (void)timerTask {
    __block BOOL hasTask = NO;
    NSArray<YYGlobalTimerTaskDict *> *targetTasks = [_targetTasksDict allValues];
    [targetTasks enumerateObjectsUsingBlock:^(YYGlobalTimerTaskDict * _Nonnull targetTask, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<YYGlobalTimerTask *> *tasks = [targetTask allValues];
        [tasks enumerateObjectsUsingBlock:^(YYGlobalTimerTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!task.target) {
                //目标对象释放掉，删除target上的所有任务
                [_targetTasksDict removeObjectForKey:task.targetName];
            } else {
                if (task.executedInMainThread) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        task.task();
                    });
                } else {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        task.task();
                    });
                }
                hasTask = YES;
            }
        }];
    }];
    
    //如果没有任务，停止timer
    if (!hasTask) {
        [self pause];
    }
}

#pragma mark - Public

/// 添加任务,添加一个任务后timer会自动开始
///
/// - parameter target:      任务的目标对象
/// - parameter key:         任务的名字
/// - parameter executedInMainThread: 是否在主线程中执行
/// - parameter action:      action
+ (void)addTaskForTarget:(nonnull id)target
                     key:(nonnull NSString *)key
                  action:(nonnull YYGlobalTimerHandler)action
    executedInMainThread:(BOOL)executedInMainThread {
    [YYGlobalTimer.sharedInstance addTaskForTarget:target key:key action:action executedInMainThread:executedInMainThread];
}

+ (void)addTaskForKey:(nonnull NSString *)key
               action:(nonnull YYGlobalTimerHandler)action
 executedInMainThread:(BOOL)executedInMainThread {
    [YYGlobalTimer.sharedInstance addTaskForTarget:self key:key action:action executedInMainThread:executedInMainThread];
}


/**
 移除任务，没有任务的话会自动停止
 */
+ (void)removeTaskForTarget:(nonnull id)target
                        key:(nonnull NSString *)key {
    [YYGlobalTimer.sharedInstance removeTaskForTarget:target key:key];
}
+ (void)removeTaskForTarget:(nonnull id)target {
    [YYGlobalTimer.sharedInstance removeTaskForTarget:target key:nil];
}
+ (void)removeTaskForKey:(nonnull NSString *)key {
    [YYGlobalTimer.sharedInstance removeTaskForTarget:self key:key];
}
+ (void)removeAllTask {
    [YYGlobalTimer.sharedInstance removeAllTask];
}

/**
 强制启动或暂停
 */
+ (void)start {
    [YYGlobalTimer.sharedInstance start];
}
+ (void)pause {
    [YYGlobalTimer.sharedInstance pause];
}

#pragma mark - Private

- (void)start {
    _timer.fireDate = [NSDate date];
    _running = YES;
}

- (void)pause {
    _timer.fireDate = [NSDate distantFuture];
    _running = NO;
}

- (void)startIfNeeded {
    if (!_running && _targetTasksDict.allValues.count > 0) {
        [self start];
    }
}

- (void)pauseIfNeeded {
    if (_running && _targetTasksDict.allValues.count == 0) {
        [self pause];
    }
}

/**
 添加一个任务后会自动开始
 */
- (void)addTaskForTarget:(nullable id)target
                     key:(nonnull NSString *)key
                  action:(nonnull YYGlobalTimerHandler)action
    executedInMainThread:(BOOL)executedInMainThread {
    
    if (!key || !action) {
        return;
    }
    
    id finaleTarget = target ?: self;
    NSString *targetKey = [NSString stringWithFormat:@"%p", finaleTarget];
    YYGlobalTimerTask *task = [YYGlobalTimerTask instanceWithTarget:finaleTarget targetName:targetKey task:action taskName:key executedInMainThread:executedInMainThread];
    [self addTask:task];
}

- (void)addTask:(nonnull YYGlobalTimerTask *)task {
    dispatch_async(_serialQueue, ^{
        YYGlobalTimerTaskDict *targetTasksDict = _targetTasksDict[task.targetName];
        if (targetTasksDict != nil) {
            targetTasksDict[task.taskName] = task;
        } else {
            targetTasksDict = [@{ task.taskName: task } mutableCopy];
            _targetTasksDict[task.targetName] = targetTasksDict;
        }
        [self startIfNeeded];
    });
}

/**
 移除任务，没有任务的话会自动停止
 */
- (void)removeTaskForTarget:(nullable id)target
                        key:(nullable NSString *)key {
    if (!target && !key) {
        return;
    }
    
    NSString *targetKey = [NSString stringWithFormat:@"%p", target ?: self];
    dispatch_async(_serialQueue, ^{
        if (key != nil) {
            //删除target上指定任务
            [_targetTasksDict[targetKey] removeObjectForKey:key];
        } else {
            //删除target上的所有任务
            [_targetTasksDict removeObjectForKey:targetKey];
        }
        [self pauseIfNeeded];
    });
}

- (void)removeAllTask {
    dispatch_async(_serialQueue, ^{
        [_targetTasksDict removeAllObjects];
        [self pause];
    });
}

@end
