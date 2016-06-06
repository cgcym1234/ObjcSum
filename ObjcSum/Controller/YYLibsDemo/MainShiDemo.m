//
//  MainShiDemo.m
//  ObjcSum
//
//  Created by sihuan on 16/5/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "MainShiDemo.h"
#import <objc/runtime.h>

/**
 synthesize 合成访问器方法
 实现property所声明的方法的定义。其实说直白就像是：property声明了一些成员变量的访问方法，synthesize则定义了由property声明的方法。
 
 他们之前的对应关系是:property 声明方法 ->头文件中申明getter和setter方法 synthesize定义方法 -> m文件中实现getter和setter方法。
 
 在Xcode4.5及以后的版本中，可以省略@synthesize，编译器会自动帮你加上get 和 set 方法的实现，并且默认会去访问_age这个成员变量，如果找不到_age这个成员变量，会自动生成一个叫做 _age的私有成员变量。在.m文件中同时实现getter和setter时候需要@synthesize age = _age.
 */


@interface MainShiDemo() {
    NSString *obj;
}

@property (nonatomic, strong) NSString *title;

@property NSString *firstName;
@property NSString *lastName;
@property NSString *obj;

@end

@implementation MainShiDemo

//重载
@synthesize title;

@synthesize firstName = _myFirstName;
@synthesize lastName = _myLastName;
//上述语法会将生成的实例变量命名为 _myFirstName 与 _myLastName ，而不再使用默认的名字。

/**
 总结下 @synthesize 合成实例变量的规则，有以下几点：
 
 1. 如果指定了成员变量的名称,会生成一个指定的名称的成员变量,
 2. 如果这个成员已经存在了就不再生成了.
 3. 如果是 @synthesize foo; 还会生成一个名称为foo的成员变量，也就是说：
 - 如果没有指定成员变量的名称会自动生成一个属性同名的成员变量,
 4. 如果是 @synthesize foo = _foo; 就不会生成成员变量了.
 */


#pragma mark - 25. _objc_msgForward函数是做什么的，直接调用它将会发生什么？

- (void)msgForwardDemo {
    //_objc_msgForward是 IMP 类型，用于消息转发的：当向一个对象发送一条消息，但它并没有实现的时候，_objc_msgForward会尝试做消息转发。
}

#pragma mark - ## 44. 以下代码运行结果如何？

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"1");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
    //只输出：1 。发生主线程锁死。
}


/*
 我们看看官方文档关于dispatch_sync的解释：
 
 ```
 Submits a block to a dispatch queue like dispatch_async(), however
 dispatch_sync() will not return until the block has finished.
 
 Calls to dispatch_sync() targeting the current queue will result
 in dead-lock. Use of dispatch_sync() is also subject to the same
 multi-party dead-lock problems that may result from the use of a mutex.
 Use of dispatch_async() is preferred.
 ```
 如果dispatch_sync()的目标queue为当前queue，会发生死锁(并行queue并不会)。使用dispatch_sync()会遇到跟我们在pthread中使用mutex锁一样的死锁问题。
 
 我们看看究竟是怎么做的？先放码：
 */



@end




void yy_dispatch_sync_f(dispatch_queue_t dq, void *ctxt, dispatch_function_t func) {
//    typeof(dq->dq_running) prev_cnt;
//    dispatch_queue_t old_dq;
    
    #pragma mark - 2
    //Step2. dispatch_sync_f首先检查传入的队列宽度（dq_width），由于我们传入的main queue为串行队列，队列宽度为1，所有接下来会调用dispatch_barrier_sync_f，传入3个参数，dispatch_sync中的目标queue、上下文信息和由我们block函数指针转化过后的func结构体。
//    if (dq->dq_width == 1) {
//        return dispatch_barrier_sync_f(dq, ctxt, func);
//    }
    
    // 1) ensure that this thread hasn't enqueued anything ahead of this call
    // 2) the queue is not suspended
//    if (slowpath(dq->dq_items_tail) || slowpath(DISPATCH_OBJECT_SUSPENDED(dq))) {
//        _dispatch_sync_f_slow(dq);
//    } else {
//        prev_cnt = dispatch_atomic_add(&dq->dq_running, 2) - 2;
//        
//        if (slowpath(prev_cnt & 1)) {
//            if (dispatch_atomic_sub(&dq->dq_running, 2) == 0) {
//                _dispatch_wakeup(dq);
//            }
//            _dispatch_sync_f_slow(dq);
//        }
//    }
//    
//    old_dq = _dispatch_thread_getspecific(dispatch_queue_key);
//    _dispatch_thread_setspecific(dispatch_queue_key, dq);
//    func(ctxt);
//    _dispatch_workitem_inc();
//    _dispatch_thread_setspecific(dispatch_queue_key, old_dq);
//    
//    if (slowpath(dispatch_atomic_sub(&dq->dq_running, 2) == 0)) {
//        _dispatch_wakeup(dq);
//    }
}

void yy_dispatch_barrier_sync_f(dispatch_queue_t dq, void *ctxt, dispatch_function_t func) {
//    dispatch_queue_t old_dq = _dispatch_thread_getspecific(dispatch_queue_key);
    
    // 1) ensure that this thread hasn't enqueued anything ahead of this call
    // 2) the queue is not suspended
    // 3) the queue is not weird
    
    #pragma mark - 3
    /**
     Step3. disptach_barrier_sync_f首先做了做了3个判断：
     
     1. 队列存在尾部节点状态（判断当前是不是处于队列尾部）
     2. 队列不为暂停状态
     3. 使用_dispatch_queue_trylock检查队列能被正常加锁。
     */
    
    //然而在我们例子中，很显然当前队列中还有其他viewController的任务，我们的流程跑到_dispatch_barrier_aync_f_slow()函数体中。
    
//    if (slowpath(dq->dq_items_tail)
//        || slowpath(DISPATCH_OBJECT_SUSPENDED(dq))
//        || slowpath(!_dispatch_queue_trylock(dq))) {
//        return _dispatch_barrier_sync_f_slow(dq, ctxt, func);
//    }
    /**
     满足所有条件则不执行if语句内的内容，执行下面代码，简单解释为：
     
     1. 使用mutex锁，获取到当前进程资源锁。
     2. 直接执行我们block函数指针的具体内容。
     3. 然后释放锁，整个调用结束。
     */
//    
//    _dispatch_thread_setspecific(dispatch_queue_key, dq);
//    func(ctxt);
//    _dispatch_workitem_inc();
//    _dispatch_thread_setspecific(dispatch_queue_key, old_dq);
//    _dispatch_queue_unlock(dq);
}


static void yy_dispatch_barrier_sync_f_slow(dispatch_queue_t dq, void *ctxt, dispatch_function_t func)
{
    
    // It's preferred to execute synchronous blocks on the current thread
    // due to thread-local side effects, garbage collection, etc. However,
    // blocks submitted to the main thread MUST be run on the main thread
    
//    struct dispatch_barrier_sync_slow2_s dbss2 = {
//        .dbss2_dq = dq,
//#if DISPATCH_COCOA_COMPAT
//        .dbss2_func = func,
//        .dbss2_ctxt = ctxt,
//#endif
//        .dbss2_sema = _dispatch_get_thread_semaphore(),
//    };
//    struct dispatch_barrier_sync_slow_s {
//        DISPATCH_CONTINUATION_HEADER(dispatch_barrier_sync_slow_s);
//    } dbss = {
//        .do_vtable = (void *)DISPATCH_OBJ_BARRIER_BIT,
//        .dc_func = _dispatch_barrier_sync_f_slow_invoke,
//        .dc_ctxt = &dbss2,
//    };
    //---------------重点是这里---------------
//    _dispatch_queue_push(dq, (void *)&dbss);
//    dispatch_semaphore_wait(dbss2.dbss2_sema, DISPATCH_TIME_FOREVER);
//    _dispatch_put_thread_semaphore(dbss2.dbss2_sema);
//    
//#if DISPATCH_COCOA_COMPAT
//    // Main queue bound to main thread
//    if (dbss2.dbss2_func == NULL) {
//        return;
//    }
//#endif
//    dispatch_queue_t old_dq = _dispatch_thread_getspecific(dispatch_queue_key);
//    _dispatch_thread_setspecific(dispatch_queue_key, dq);
//    func(ctxt);
//    _dispatch_workitem_inc();
//    _dispatch_thread_setspecific(dispatch_queue_key, old_dq);
//    dispatch_resume(dq);
}

void yy_dispatch_sync(dispatch_queue_t queue, void (^work)(void)) {
    dispatch_function_t f = (__bridge void *)work;
    #pragma mark - 1
    //Step1. 可以看到dispatch_sync将我们block函数指针进行了一些转换后，直接传给了dispatch_sync_f()去处理。
    yy_dispatch_sync_f(queue, nil, f);
    
    //struct Block_basic *bb = (void *)work;
    //dispatch_sync_f(dq, work, (dispatch_function_t)bb->Block_invoke);
}


















