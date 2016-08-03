//
//  YYMalloc.c
//  MySimpleFrame
//
//  Created by sihuan on 15/3/24.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#include "YYMalloc.h"
#include <string.h>
#include <pthread.h>
#include <stdlib.h>


static size_t YYMemoryUsed = 0;
static int YYMemoryThreadSafe = 0;
pthread_mutex_t YYUsedMemoryMutex = PTHREAD_MUTEX_INITIALIZER;

#pragma mark - /* 申请空间时，发送oom内存溢出错误，终止操作 */
static void yyMallocDefaultOOM(size_t size) {
    fprintf(stderr, "zmalloc: Out of memory trying to allocate %zu bytes\n", size);
    fflush(stderr);
    abort();
}
#pragma mark - 线程安全的加减法法函数
static void (*yyMallocOOMHandler)(size_t) = yyMallocDefaultOOM;

#define YYPrefixSize (sizeof(size_t))


//#define update_zmalloc_stat_add(__n) __atomic_add_fetch(&used_memory, (__n), __ATOMIC_RELAXED)
//#define update_zmalloc_stat_sub(__n) __atomic_sub_fetch(&used_memory, (__n), __ATOMIC_RELAXED)

//gcc从4.1.2提供了__sync_*系列的built-in函数，用于提供加减和逻辑运算的原子操作。
#define YYMemoryUsedAdd(__n) __sync_add_and_fetch(&YYMemoryUsed, (__n))
#define YYMemoryUsedSub(__n) __sync_sub_and_fetch(&YYMemoryUsed, (__n))

/* 申请新的_n大小的内存，分为线程安全，和线程不安全的模式 */
#define YYMemoryUsedAlloc(__n) do { \
size_t _n = (__n); \
if (_n&(sizeof(long)-1)) _n += sizeof(long)-(_n&(sizeof(long)-1)); \
if (YYMemoryThreadSafe) { \
YYMemoryUsedAdd(_n); \
} else { \
YYMemoryUsed += _n; \
} \
} while(0)

#define YYMemoryUsedFree(__n) do { \
size_t _n = (__n); \
if (_n&(sizeof(long)-1)) _n += sizeof(long)-(_n&(sizeof(long)-1)); \
if (YYMemoryThreadSafe) { \
YYMemoryUsedSub(_n); \
} else { \
YYMemoryUsed -= _n; \
} \
} while(0)

/* 调用malloc申请size个大小的空间 */
void *yyMalloc(size_t size) {
    //实际调用的还是malloc函数
    void *ptr = malloc(size+YYPrefixSize);
    
    //如果申请的结果为null，说明发生了oom,调用oom的处理方法
    if (!ptr) {
        yyMallocOOMHandler(size);
    }
    
    YYMemoryUsedAlloc(size+YYPrefixSize);
    return ptr;
}

/* 调用系统函数calloc函数申请空间 */
void *yyCalloc(size_t size) {
    void *ptr = calloc(1, size+YYPrefixSize);
    if (!ptr) {
        yyMallocOOMHandler(size);
    }
    YYMemoryUsedAlloc(size+YYPrefixSize);
    return ptr;
}

/* 原内存重新调整空间为size的大小 */
void *yyRealloc(void *ptr, size_t size) {
    void *realPtr;
    
    size_t oldSize;
    void *newPtr;
    
    if (!ptr) {
        return yyMalloc(size+YYPrefixSize);
    }
    
    realPtr = ptr - YYPrefixSize;
    oldSize  = *((size_t *)realPtr);
    newPtr = realloc(realPtr, size + YYPrefixSize);
    if (!newPtr) {
        yyMallocOOMHandler(size);
    }
    
    *((size_t *)newPtr) = size;
    YYMemoryUsedFree(oldSize);
    YYMemoryUsedAlloc(size);
    return newPtr + YYPrefixSize;
}

/* 释放空间方法，并更新used_memory的值 */
void yyFree(void *ptr) {
    
}

/* 原始系统free释放方法 */
void yyLibcFree(void *ptr) {
    free(ptr);
}

/* 字符串复制方法 */
char *yyStrdup(const char *s) {
    size_t l = strlen(s) + 1;
    char *p = yyMalloc(l);
    
    memcpy(p, s, l);
    return p;
}

/* 获取当前已经占用的内存大小 */
size_t yyMallocUsedMemory();

/* 是否设置线程安全模式 */
void yyMallocEnableThreadSafeness();

/* 可自定义设置内存溢出的处理方法 */
void yyMallocSetOomHander(void (*oomHandler)(size_t));

/* 所给大小与已使用内存大小之比 */
float yyMallocGetFragmentationRatio(size_t rss);

size_t yyMallocGetRss();

/* 获取私有的脏数据大小 */
size_t yyMallocGetPrivateDirty();




















