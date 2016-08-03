//
//  SummaryConcurrency.h
//  MySumC
//
//  Created by sihuan on 15/4/3.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#ifndef __MySumC__SummaryConcurrency__
#define __MySumC__SummaryConcurrency__

#include "SummaryNetwork.h"
#include "SummaryIO.h"

#pragma mark - 并发编程

#pragma mark - 基于I/O多路复用的并发编程
/**
 *  I/O多路复用（I/O multiplexing）基本思路是使用select函数，要求内核挂起进程，
 只有在一个或者多个I/O事件发生后，才能将控制返回给应用程序。如下一种情况：
 {0，4}中任意的描述符准备好读时返回
 {1，2，7}中任意的描述符准备好写时返回
 如果在等待一个I/O 事件发生时，超过了100秒，就超时。
 */

#pragma mark 下面讨论一种情况：一组描述符准备好读

/*返回：成功：已经准备好的描述符的非0个数。出错：-1
int select_(int n, fd_set *fdset, NULL, NULL, NULL);
 
 fd_set：描述符集合
 
FD_ZERO(fd_set *fdset); //fdset清0
FD_CLR(int fd, fd_set *fdset);  //将fd从fdset中清除
FD_SET(int fd, fd_set *fdset);  //将fd加入到fdset中
FD_ISSET(int fd, fd_set *fdset);    //判断fd是否在fdset中
 
 针对我们目的，select函数有2个输入：一个读集合的fdset，该读集合的基数（其实是任何描述符集合的最大基数）
 select会一直阻塞，直到fdset中至少有一个描述符准备好读（从该描述符读取一个字节的请求不会阻塞，表示它准备好可以读了）。
 副作用：参数fdset会被改成所有准备好读描述符的集合，所以需要在调用select前重新设置fdset
 
*/

//处理一组描述符准备好读的情况
void selectDemo1();


#pragma mark - 基于I/O多路复用的并发事件驱动服务器
/**
 *  I/O多路复用可以用作并发事件驱动（event-driven）程序的基础。
 在事件驱动程序中，流是因为某种事件而前进的。一般概念是将逻辑流模型转化为状态机。
 一个状态机（state machine）就是一组
 状态（state），
 输入事件（input event）
 转移（transition）：将状态和输入事件映射到状态。每个转移都将一个（输入状态，输入事件）对，映射到一个输出状态。
 自循环（self-loop）是同一输入和输出状态之间的转移。
 通常把状态机画成有向图，节点表示状态，有向弧表示转移，弧上的标号表示输入事件。
 一个状态机从某种初始状态开始执行。
 每个输入事件都会引发一个从当前状态到下一状态的转移。
 */

/* represents a pool of connected descriptors */
typedef struct YYClent {
    int maxFd;      /* largest descriptor in read_set */
    fd_set readSet; /* set of all active descriptors */
    fd_set readySet;/* subset of descriptors ready for reading  */
    int readyNum;   /* number of ready descriptors from select */
    int maxIndex;   /* highwater index into client array */
    int clientFd[FD_SETSIZE];   /* set of active descriptors */
    Rio clientRio[FD_SETSIZE];  /* set of active read buffers */
} YYClent;


YYClent *yyClientInit(int listenFd);
void yyClientConfig(YYClent *client, int listenFd);
void yyClientAdd(YYClent *client, int conectedFd);
void yyClientCheck(YYClent *client);

void selectDemo2(int port);


#pragma mark - 基于预线程化的（线程池）并发服务器

void threadServer(int port);


















#endif /* defined(__MySumC__SummaryConcurrency__) */
