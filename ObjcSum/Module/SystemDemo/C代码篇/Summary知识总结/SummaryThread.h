//
//  SummaryThread.h
//  MySumC
//
//  Created by sihuan on 15/4/9.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#ifndef __MySumC__SummaryThread__
#define __MySumC__SummaryThread__

#include "SummaryNetwork.h"
#include "SummaryIO.h"

#pragma mark - Posix线程

//第一个线程化程序
void demo1();


#pragma mark - 共享变量
void shareVar();

#pragma mark - 同步错误例子
void synchronizationErrorDemo();

#pragma mark - 使用信号量调度共享资源的访问，生产者-消费者问题
typedef struct Sbuf {
    int *buf;   /* Buffer array */
    int n;      /* Maximum number of slots */
    int front;  /* buf[(front+1)%n] is first item */
    int rear;   /* buf[rear%n] is last item */
    sem_t *mutex;/* Protects accesses to buf */
    sem_t *slots;/* Counts available slots */
    sem_t *items;/* Counts available items */
} Sbuf;

void sbufInit(Sbuf *sp, int n);
void sbufDinit(Sbuf *sp);

/**
 *  等待一个可用的槽位，对互斥锁加锁，
 添加项目，
 互斥解锁，发信号通知一个新的项目可用
 */
void sbufInsert(Sbuf *sp, int item);

/**
 * 等待一个可用的项目，对互斥锁加锁，
 取出项目，
 互斥解锁，发信号通知一个新的槽位可用
 */
int sbufRemove(Sbuf *sp);


#pragma mark - 使用信号量调度共享资源的访问，读者写者问题

//某些线程只读，某些只写
//读者优先，
//写着优先。
//注意解决这个问题时，都可能导致一群读者让写着无限等待，或者相反。 即饥饿（starvation）现象


#pragma mark - 线程池测试
void threadPoolTest();

#pragma mark - 线程安全

/**
 *  函数是线程安全的：当且仅当被多个并发线程反复调用时，它会一直产生正确的结果。
 
  4种线程不安全的函数：
 
 1.不保护共享变量的函数。
 
 2.保持跨越多个调用状态的函数。
 
 3.返回指向静态变量的指针的函数。
 
 4.调用线程不安全函数的函数。
 */


#endif /* defined(__MySumC__SummaryThread__) */
