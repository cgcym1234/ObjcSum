//
//  YYThreadPool.c
//  MySimpleFrame
//
//  Created by sihuan on 15/4/11.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#include "YYThreadPool.h"

#define YYThreadPoolKeyTaskAdd "KeyTaskAdd"
#define YYThreadPoolKeyTaskGet "KeyTaskGet"
#define YYThreadPoolKeyTaskDo "KeyTaskDo"

void yyThreadPoolTaskListConfig(YYThreadPoolTaskList *list) {
    list->head = list->tail = list->recycle = NULL;
}

void yyThreadPoolTaskListRelease(YYThreadPoolTaskList *list) {
    YYThreadPoolTaskNode *node;
    
//    while (list->head) {
//        node = list->head;
//        free(node);
//        list->head = list->head->next;
//    }
    while (list->recycle) {
        node = list->recycle;
        free(node);
        list->recycle = list->recycle->next;
    }
}

//从头部放
static inline void yyThreadPoolTaskListAdd(YYThreadPoolTaskList *list, yyTaskFun func, void *arg) {
    YYThreadPoolTaskNode *node;
    if (!list->recycle) {
        list->recycle = malloc(sizeof(YYThreadPoolTaskNode));
        list->recycle->next = NULL;
        list->recycle->prev = NULL;
    }
    
    node = list->recycle;
    list->recycle = node->next;
    
    node->fun = func;
    node->arg = arg;
    
    //如果是第一个节点，就是尾节点
    if (!list->head) {
        list->tail = node;
    } else {
        list->head->prev = node;
    }
    
    AddNodeToHead(node, list->head);
}

//从尾部取
static inline YYThreadPoolTaskNode *yyThreadPoolTaskListPop(YYThreadPoolTaskList *list) {
    YYThreadPoolTaskNode *node = list->tail;
    if (node) {
        list->tail = node->prev;
        node->next = NULL;
        AddNodeToHead(node, list->recycle);
    }
    return node;
}

#pragma mark - 工作线程

void yyThreadPoolWorkerInit(YYThreadPoolWorker *wp, int threadNums) {
    wp->head = NULL;
    wp->nums = threadNums;
}
void yyThreadPoolWorkerAdd(YYThreadPoolWorker *wp, pthread_t tid) {
    YYThreadPoolWorkerNode *node = malloc(sizeof(YYThreadPoolWorkerNode));
    node->tid = tid;
    AddNodeToHead(node, wp->head);
}
void yyThreadPoolWorkerDel(YYThreadPoolWorker *wp, pthread_t tid) {
    
    if (wp->head) {
        if (pthread_equal(wp->head->tid, tid)) {
            wp->head = wp->head->next;
            wp->nums--;
        } else {
            YYThreadPoolWorkerNode *node = wp->head;
            while (node->next) {
                if (pthread_equal(node->next->tid, tid)) {
                    node->next = node->next->next;
                    wp->nums--;
                }
                node = node->next;
            }
        }
    }
}
void yyThreadPoolWorkerRelease(YYThreadPoolWorker *wp) {
    YYThreadPoolWorkerNode *node;
    while (wp->head) {
        node = wp->head;
        free(node);
        wp->head = wp->head->next;
    }
}

static void yyThreadPoolAddWorker(YYThreadPool *pt);
static void *yyThreadPoolDoTask(void *argp);
static void yyThreadPoolAddWorker(YYThreadPool *pt);

static void *yyThreadPoolDoTask(void *argp) {
    YYThreadPool *pt = argp;
    YYThreadPoolTaskNode *taskNode;
    
    while (1) {
        P(pt->taskDo);
        P(pt->taskGet);
        taskNode = yyThreadPoolTaskListPop(&pt->taskQueueNomal);
        V(pt->taskGet);
        if (taskNode) {
            taskNode->fun(taskNode->arg);
        }
    }
    
    return NULL;
}

static void yyThreadPoolAddWorker(YYThreadPool *pt) {
    //pthread_t *tid = malloc(sizeof(pthread_t));
    pthread_t tid ;
    int ret = pthread_create(&tid, NULL, yyThreadPoolDoTask, (void *)pt);
    if(ret != 0)
    {
        fprintf(stderr, "yyThreadPoolAddWorker() failed:[%s]\n", strerror(ret));
        return;
    }
    pthread_detach(tid);
    
    yyThreadPoolWorkerAdd(&pt->workers, tid);
    //yyListAddNodeHead(&pt->workers, tid);
    
}

#pragma mark - 线程池
YYThreadPool *yyThreadPoolCreate(int minThreads, int maxThreads) {
    YYThreadPool *pt = malloc(sizeof(YYThreadPool));
    ExitIfFailWithMessage(pt, "yyThreadPoolCreate() failed, out Of Memory!!!");
    
    gettimeofday(&pt->createdTime, NULL);
    
    yyThreadPoolWorkerInit(&pt->workers, minThreads);
    yyThreadPoolTaskListConfig(&pt->taskQueueNomal);
    yyThreadPoolTaskListConfig(&pt->taskQueueEmerg);
    
    pt->taskAdd = sem_open(YYThreadPoolKeyTaskAdd, O_CREAT, 0644, 1);
    pt->taskGet = sem_open(YYThreadPoolKeyTaskGet, O_CREAT, 0644, 1);
    pt->taskDo = sem_open(YYThreadPoolKeyTaskDo, O_CREAT, 0644, 0);
    
    for (int i = 0; i < minThreads; i++) {
        yyThreadPoolAddWorker(pt);
    }
    
    return pt;
}
int yyThreadPoolDispatch(YYThreadPool *pt, yyTaskFun task, void *arg) {
    
    P(pt->taskAdd);
    
    yyThreadPoolTaskListAdd(&pt->taskQueueNomal, task, arg);
    
    V(pt->taskAdd);
    V(pt->taskDo);
    
    return 1;
}

void yyThreadPoolDestory(YYThreadPool *pt, int waitAllTasks) {
    yyThreadPoolWorkerRelease(&pt->workers);
    yyThreadPoolTaskListRelease(&pt->taskQueueNomal);
    //sem_close(pt->taskAdd);
    //sem_close(pt->taskGet);
    //sem_close(pt->taskDo);
sem_unlink(YYThreadPoolKeyTaskAdd);
sem_unlink(YYThreadPoolKeyTaskGet);
sem_unlink(YYThreadPoolKeyTaskDo);
    free(pt);
    
}




















