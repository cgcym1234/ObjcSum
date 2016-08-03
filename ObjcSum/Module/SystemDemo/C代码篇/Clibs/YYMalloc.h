//
//  YYMalloc.h
//  MySimpleFrame
//
//  Created by sihuan on 15/3/24.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#ifndef __MySimpleFrame__YYMalloc__
#define __MySimpleFrame__YYMalloc__

#include <stdio.h>
#include <malloc/malloc.h>
#include "YYDefine.h"

/* 调用malloc申请size个大小的空间 */
void *yyMalloc(size_t size);

/* 调用系统函数calloc函数申请空间 */
void *yyCalloc(size_t size);

/* 原内存重新调整空间为size的大小 */
void *yyRealloc(void *ptr, size_t size);

/* 释放空间方法，并更新used_memory的值 */
void yyFree(void *ptr);

/* 字符串复制方法 */
char *yyStrdup(const char *s);

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

/* 原始系统free释放方法 */
void yyLibcFree(void *ptr);

#endif /* defined(__MySimpleFrame__YYMalloc__) */
