//
//  YYStr.h
//  MySimpleFrame
//
//  Created by sihuan on 15/3/19.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#ifndef __MySimpleFrame__YYStr__
#define __MySimpleFrame__YYStr__

#include <stdio.h>
#include "YYDefine.h"

/* 最大分配内存1M */
#define YYStrMaxPrealloc (1024*1024)

typedef char* YYStr;

typedef struct YYStrHolder {
    //字符长度
    unsigned int len;
    //当前可用空间
    unsigned int free;
    //具体存放字符的buf
    char buf[];
} YYStrHolder;

#pragma mark - YYStr 和 YYStrHolder之间的转换 sizeof(YYStrHolder)+内容长度+1（结束'\0'）

/* 计算Str的长度，返回的size_t类型的数值 */
/* size_t,它是一个与机器相关的unsigned类型，其大小足以保证存储内存中对象的大小。 */
static inline size_t yyStrLength(const YYStr s) {
    YYStrHolder *str = VoidPtr(s - sizeof(YYStrHolder));
    return str->len;
}

/* 根据sdshdr中的free标记获取可用空间 */
static inline size_t yyStrAvail(const YYStr s) {
    YYStrHolder *str = VoidPtr(s - sizeof(YYStrHolder));
    return str->free;
}

YYStr yyStrNewLength(const void *init, size_t initLen);//根据给定长度，新生出一个sds
YYStr yyStrNew(const void *init);//根据给定的值，生出sds
YYStr yyStrNewEmpty();//创建一个长度为0的空字符串

size_t yyStrLength(const YYStr s);
YYStr yyStrDup(const YYStr s);
void yyStrFree(YYStr s);
size_t yyStrAvail(const YYStr s);
YYStr yyStrGrowZero(YYStr s, size_t len);
YYStr yyStrCatlength(YYStr s, const void *t, size_t len);
YYStr yyStrCatStr(YYStr s, const YYStr t);
YYStr yyStrCat(YYStr s, const void *t);
YYStr yyStrCopy(YYStr s, const char *t);
YYStr yyStrCopyLength(YYStr s, const char *t, size_t len);

YYStr yyStrPrintf(YYStr s, const char *fmt, ...)__attribute__((format(printf, 2, 3)));
YYStr yyStrFmt(YYStr s, const char *fmt, ...);
YYStr yyStrTrim(YYStr s, const char *cset);
void yyStrRange(YYStr s, int start, int end);

void yyStrUpdateLength(YYStr s);
void yyStrClear(YYStr s);
int yyStrCmp(const YYStr s1, const YYStr s2);
YYStr *yyStrSpliteLength(const char *s, int len, const char *sep, int seplen, int *count);

void yyStrToLower(YYStr s);
void yyStrToUpper(YYStr s);




















#endif /* defined(__MySimpleFrame__YYStr__) */
