//
//  YYThreadPool.h
//  MySimpleFrame
//
//  Created by sihuan on 15/4/11.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#ifndef __MySimpleFrame__YYThreadPool__
#define __MySimpleFrame__YYThreadPool__

#include "YYList.h"
#include "YYDefine.h"

typedef void (*yyTaskFun)(void *);

typedef enum YYTaskPriority {
    YYTaskPriorityNormal,
    YYTaskPriorityEmerg
} YYTaskPriority;

#pragma mark - 任务节点
typedef struct YYThreadPoolTaskNode{
    yyTaskFun fun;           //task function of the queue
    void *arg;               //arguments of the function
    struct YYThreadPoolTaskNode *next;
    struct YYThreadPoolTaskNode *prev;
} YYThreadPoolTaskNode;

typedef struct YYThreadPoolTaskList {
    YYThreadPoolTaskNode *head;      //the head of the task queue
    YYThreadPoolTaskNode *tail;      //the tail of the task queue
    YYThreadPoolTaskNode *recycle;   //the node of the task queue which is allocated memory, when a task is done, the node will be put into this list, for new tasks
} YYThreadPoolTaskList;

void yyThreadPoolTaskListConfig(YYThreadPoolTaskList *list);
void yyThreadPoolTaskListRelease(YYThreadPoolTaskList *list);

#pragma mark - 工作线程
typedef struct YYThreadPoolWorkerNode {
    pthread_t tid;
    struct YYThreadPoolWorkerNode *next;
} YYThreadPoolWorkerNode;

typedef struct YYThreadPoolWorker {
    YYThreadPoolWorkerNode *head;
    int nums;
} YYThreadPoolWorker;

void yyThreadPoolWorkerInit(YYThreadPoolWorker *wp, int threadNums);
void yyThreadPoolWorkerAdd(YYThreadPoolWorker *wp, pthread_t tid);
void yyThreadPoolWorkerDel(YYThreadPoolWorker *wp, pthread_t tid);
void yyThreadPoolWorkerRelease(YYThreadPoolWorker *wp);

#pragma mark - 线程池
typedef struct YYThreadPool {
    struct timeval createdTime; //创建时间
    
    YYThreadPoolWorker workers;            //工作线程信息
    YYThreadPoolTaskList taskQueueNomal;     //普通任务队列
    YYThreadPoolTaskList taskQueueEmerg;     //紧急任务队列
    
    sem_t *taskAdd;
    sem_t *taskGet;
    sem_t *taskDo;
    
} YYThreadPool;


YYThreadPool *yyThreadPoolCreate(int minThreads, int maxThreads);
int yyThreadPoolDispatch(YYThreadPool *pt, yyTaskFun task, void *arg);
void yyThreadPoolDestory(YYThreadPool *pt, int waitAllTasks);




#endif /* defined(__MySimpleFrame__YYThreadPool__) */
