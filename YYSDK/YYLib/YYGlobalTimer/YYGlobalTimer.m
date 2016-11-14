//
//  YYGlobalTimer.m
//  JuMei
//
//  Created by yuany on 16/10/21.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "YYGlobalTimer.h"

#pragma mark - YYGlobalTimerTask

@interface YYGlobalTimerTask : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *targetName;

@property (nonatomic, copy) YYGlobalTimerHandler task;
@property (nonatomic, copy) NSString *taskName;

//任务的执行间隔，毫秒
@property (nonatomic, assign) NSUInteger intervalMS;
@property (nonatomic, assign) BOOL executedInMainThread;

+ (instancetype)instanceWithTarget:(id)taget
                        targetName:(NSString *)targetName
                              task:(YYGlobalTimerHandler)task
                          taskName:(NSString *)targetName
                          interval:(NSUInteger)interval
              executedInMainThread:(BOOL)executedInMainThread;

@end

@implementation YYGlobalTimerTask

+ (instancetype)instanceWithTarget:(id)target
                        targetName:(NSString *)targetName
                              task:(YYGlobalTimerHandler)task
                          taskName:(NSString *)taskName
                          interval:(NSUInteger)interval
              executedInMainThread: (BOOL)executedInMainThread {
    YYGlobalTimerTask *item = [YYGlobalTimerTask new];
    item.target = target;
    item.targetName = targetName;
    item.task = task;
    item.taskName = taskName;
    item.intervalMS = interval;
    item.executedInMainThread = executedInMainThread;
    
    return item;
}

@end

#pragma mark - YYGlobalTimer

#define YYGlobalTimerInterval 0.1

typedef NSMutableDictionary<NSString *, YYGlobalTimerTask *> YYGlobalTimerTaskDict;

@interface YYGlobalTimer ()

//保证添加和移除线程安全
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, YYGlobalTimerTaskDict *> *targetTasksDict;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL running;

//timer开始运行的时间，毫秒，100的倍数，每次pause后都会清0
@property (nonatomic, assign) NSUInteger durationMS;


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
    NSDate *currentDate = [NSDate date];
    NSArray<YYGlobalTimerTaskDict *> *targetTasks = [_targetTasksDict allValues];
    [targetTasks enumerateObjectsUsingBlock:^(YYGlobalTimerTaskDict * _Nonnull targetTask, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<YYGlobalTimerTask *> *tasks = [targetTask allValues];
        [tasks enumerateObjectsUsingBlock:^(YYGlobalTimerTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!task.target) {
                //目标对象释放掉，删除target上的所有任务
                [_targetTasksDict removeObjectForKey:task.targetName];
            } else {
                //只有_durationMS是任务执行间隔时间的倍数时，才执行该任务
                if (_durationMS % task.intervalMS == 0) {
                    if (task.executedInMainThread) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            task.task(currentDate);
                        });
                    } else {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            task.task(currentDate);
                        });
                    }
                }
                
                hasTask = YES;
            }
        }];
    }];
    
    _durationMS += YYGlobalTimerInterval * 1000;
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
/// - parameter interval:    任务执行的间隔，单位秒，最小粒度是0.1秒
/// - parameter executedInMainThread: 是否在主线程中执行
/// - parameter action:      action
+ (void)addTaskForTarget:(nonnull id)target
                     key:(nonnull NSString *)key
                interval:(NSTimeInterval)interval
                  action:(nonnull YYGlobalTimerHandler)action
    executedInMainThread:(BOOL)executedInMainThread {
    [YYGlobalTimer.sharedInstance addTaskForTarget:target key:key interval:interval action:action executedInMainThread:executedInMainThread];
}

+ (void)addTaskForKey:(nonnull NSString *)key
             interval:(NSTimeInterval)interval
               action:(nonnull YYGlobalTimerHandler)action
 executedInMainThread:(BOOL)executedInMainThread {
    [YYGlobalTimer.sharedInstance addTaskForTarget:self key:key interval:interval action:action executedInMainThread:executedInMainThread];
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
    _durationMS = 0;
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
                interval:(NSTimeInterval)interval
                  action:(nonnull YYGlobalTimerHandler)action
    executedInMainThread:(BOOL)executedInMainThread {
    
    if (!key || !action) {
        return;
    }
    
    id finaleTarget = target ?: self;
    NSString *targetKey = [NSString stringWithFormat:@"%p", finaleTarget];
    NSUInteger intervalMS = (floorf(interval * 10) / 10) * 1000;
    
    YYGlobalTimerTask *task = [YYGlobalTimerTask instanceWithTarget:finaleTarget targetName:targetKey task:action taskName:key interval:intervalMS executedInMainThread:executedInMainThread];
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
