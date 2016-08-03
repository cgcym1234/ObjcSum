//
//  YYMemPool.c
//  MySumC
//
//  Created by sihuan on 15/3/27.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#include "YYMemPool.h"
#include "YYDefine.h"

#include<string.h>
#include<stdlib.h>

#define YYMemErr -1

static int reapplySize = 80;

static int YYMemPoolChunkAlloc(YYMemPool *pool, int applySize) {
    YYChunk *chunk = malloc(sizeof(YYChunk));
    if (!chunk) {
        return YYMemErr;
    }
    
    chunk->start = calloc(applySize, pool->addressSize);
    if (!chunk->start) {
        return YYMemErr;
    }
    chunk->applySize = applySize;
    chunk->end = chunk->start + applySize * pool->addressSize;
    
    //把一个大块的内存循环分配到链表上
    YYAddress *temp;
    for (int i = 0; i < applySize; i++) {
        temp = (YYAddress *)(chunk->start + i * pool->addressSize);
        AddNodeToHead(temp, pool->head);
    }
    AddNodeToHead(chunk, pool->chunks);
    
    return 0;
}

YYMemPool *yyMemPoolCreate(int addressSize, int nums) {
    if (addressSize <= 0 || nums <= 0) {
        return Null;
    }
    
    YYMemPool *pool = malloc(sizeof(YYMemPool));
    ExitIfFailWithMessage(pool, "yyMemPoolCreate() failed,Out Of Memory!!!\n");
    
    pool->total = nums;
    pool->addressSize = RoundUp8(addressSize);
    pool->avail = nums;
    pool->head = Null;
    pool->chunks = Null;
    
    if (YYMemPoolChunkAlloc(pool, nums) == YYMemErr) {
        ExitWithMessage("YYMemPoolChunkAlloc() failed, Out Of Memory!!!\n");
    }
    
    return pool;
}
void yyMemPoolDestory(YYMemPool *pool) {
    if (!pool) {
        return;
    }
    
    YYChunk *temp;
    while (pool->chunks) {
        temp = pool->chunks;
        pool->chunks = temp->next;
        free(temp->start);
        free(temp);
    }
    free(pool);
}

void yyMemPoolInfo(YYMemPool *pool) {
    if(!pool) return;
    
    printf("total memory nums:%lu\ncurrent avails:%lu\ndata size:%lu\n",
           pool->total, pool->avail, pool->addressSize);
}

void *yyMemPoolAlloc(YYMemPool *pool) {
    if (!pool) {
        return Null;
    }
    
    if (pool->head) {
        void *p = pool->head;
        pool->head = pool->head->next;
        pool->avail--;
        return p;
    } else {
        if (YYMemPoolChunkAlloc(pool, reapplySize) == YYMemErr) {
            return Null;
        }
        
        pool->total += reapplySize;
        pool->avail += reapplySize;
        reapplySize *= 2;
        return yyMemPoolAlloc(pool);
    }
}

void yyMemPoolFree(YYMemPool *pool, void *p) {
    if(!pool || !p) return;
    
    YYAddress *temp = (YYAddress *)p;
    AddNodeToHead(temp, pool->head);
    pool->avail++;
}






























