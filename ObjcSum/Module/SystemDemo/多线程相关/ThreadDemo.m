//
//  ThreadDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/12/10.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "ThreadDemo.h"

@interface ThreadDemo ()

@end

@implementation ThreadDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    dispatch_queue_t myCustomQueue;
//    myCustomQueue = dispatch_queue_create("com.example.MyCustomQueue", NULL);
//    dispatch_sync(myCustomQueue, ^{
//        sleep(10);
//    });
    
//    [self asyncBarrier];
    [self interview1];
}

- (void)interview1{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        NSLog(@"1---%@",[NSThread currentThread]);
        [self performSelector:@selector(test1) withObject:nil afterDelay:.0f];
        NSLog(@"3---%@",[NSThread currentThread]);
    });
}

- (void)test1{
    NSLog(@"2---%@",[NSThread currentThread]);
}



// 异步栅栏函数
- (void)asyncBarrier{
    NSLog(@"当前线程1");
    dispatch_queue_t queue = dispatch_queue_create("com.demo.tsk", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
       NSLog(@"开始下载part1---%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2.0f]; // 模拟下载耗时2s
        NSLog(@"完成下载part1---%@",[NSThread currentThread]);
    });
    
    NSLog(@"当前线程2");
    
    dispatch_async(queue, ^{
       NSLog(@"开始下载part2---%@",[NSThread currentThread]);
       [NSThread sleepForTimeInterval:1.0f]; // 模拟下载耗时1s
       NSLog(@"完成下载part2---%@",[NSThread currentThread]);
    });
    
    NSLog(@"当前线程3");
    
    dispatch_barrier_async(queue, ^{
       NSLog(@"开始合并part1和part2---%@",[NSThread currentThread]);
       [NSThread sleepForTimeInterval:1.0f]; // 模拟下载耗时1s
       NSLog(@"完成合并part1和part2---%@",[NSThread currentThread]);
    });
    
    NSLog(@"当前线程4");
        
    dispatch_async(queue, ^{
       NSLog(@"开始写入磁盘---%@",[NSThread currentThread]);
       [NSThread sleepForTimeInterval:1.0f]; // 模拟下载耗时1s
       NSLog(@"完成写入磁盘---%@",[NSThread currentThread]);
    });
    
    NSLog(@"当前线程5");
}



#pragma mark - dispatch_queue

/**
 *  dispatch queue是一个工作队列，其背后是一个全局的线程池。
 提交到队列的任务会在后台线程异步执行。
 所有线程共享同一个后台线程池，这使得系统更有效率。
 
 GCD还提供了很多精心设计的功能，为了简单起见，本文将把它们都略过。
 比如线程池的线程数量会根据待完成的任务数和系统CPU的使用率动态作调整。
 如果你已经有一堆任务占满了CPU，然后再扔给它另一个任务，GCD不会再创建另外的工作线程，因为CPU已经被100%占用，再执行别的任务只会更低效。
 
 这里我会写死线程数而不做模拟动态调整。同时我还会忽略并发队列的目标队列和调度屏障功能。
 
 我们目标是聚焦于dispatch queue的真髓：能串行、能并行、能同步、能异步以及共享同一个线程池。
 */

@end
