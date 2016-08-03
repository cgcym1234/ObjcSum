//
//  YYMemPool.h
//  MySumC
//
//  Created by sihuan on 15/3/27.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#ifndef __MySumC__YYMemPool__
#define __MySumC__YYMemPool__

#include <stdio.h>

#pragma mark - 一个简单的内存池，单链表维护，每个节点中的内存大小固定，适用于频繁使用小内存的情况

//每次申请新时，会直接申请一个很大的内存块，在上面分配需要的小内存
typedef struct YYChunk {
    char *start;
    char *end;
    u_long applySize;
    struct YYChunk *next;
}YYChunk;

//YYAddress指向的是可用地址，address->next指向的是下一个可用地址,这样设计不会因为维护链表而增加额外内存
typedef struct YYAddress {
    struct YYAddress *next;
}YYAddress;

typedef struct YYMemPool {
    u_long total;   //共申请了多少个
    u_long avail;   //剩余可用
    u_long addressSize; //创建时候的参数，每块内存的大小，自动调整为按8字节对齐
    
    YYAddress *head; //当前可用地址链表
    YYChunk *chunks; //申请的大块内存地址链表，当一个大块的内存被用完时，会再申请一块大的内存放进链表中
    
}YYMemPool;


YYMemPool *yyMemPoolCreate(int addressSize, int nums);
void yyMemPoolDestory(YYMemPool *pool);

void yyMemPoolInfo(YYMemPool *pool);
void *yyMemPoolAlloc(YYMemPool *pool);
void yyMemPoolFree(YYMemPool *pool, void *p);











#endif /* defined(__MySumC__YYMemPool__) */
