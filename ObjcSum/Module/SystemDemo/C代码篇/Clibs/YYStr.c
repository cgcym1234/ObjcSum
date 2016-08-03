//
//  YYStr.c
//  MySimpleFrame
//
//  Created by sihuan on 15/3/19.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#include "YYStr.h"
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <assert.h>


/* 创建新字符串方法，传入目标长度，初始化方法 */
YYStr yyStrNewLength(const void *init, size_t initLen) {
    YYStrHolder *sh;
    if (init) {
        sh = malloc(sizeof(YYStrHolder)+initLen+1);
    } else {
        sh = calloc(1, sizeof(YYStrHolder)+initLen+1);
    }
    if (sh == Null) {
        return Null;
    }
    sh->len = initLen;
    sh->free = 0;
    if (initLen && init) {
        memcpy(sh->buf, init, initLen);
    }
    //最末端同样要加‘\0’结束符
    sh->buf[initLen] = '\0';
    //最后是通过返回字符串结构体中的buf代表新的字符串
    return sh->buf;
}

YYStr yyStrNew(const void *init) {
    size_t len = (init == Null) ? 0 : strlen(init);
    return yyStrNewLength(init, len);
}

/* 其实就是创建一个长度为0的空字符串 */
YYStr yyStrNewEmpty() {
    return yyStrNewLength("", 0);
}

YYStr yyStrDup(const YYStr s) {
    return yyStrNewLength(s, yyStrLength(s));
}

void yyStrFree(YYStr s) {
    if (s == Null) {
        return;
    }
    free(s - sizeof(YYStrHolder));
}

/* 在原有字符串中取得更大的空间，并返回扩展空间后的字符串 */
YYStr yyStrMakeRoomFor(YYStr s, size_t addLen) {
    YYStrHolder *sh, *newsh;
    size_t free = yyStrAvail(s);
    size_t len, newLen;
    
    //如果当前可用空间已经大于需要值，直接返回原字符串
    if (free >= addLen) {
        return s;
    }
    
    len = yyStrLength(s);
    sh = (void *)(s - sizeof(YYStrHolder));
    newLen = len + addLen;
    if (newLen < YYStrMaxPrealloc) {
        newLen *= 2;
    } else {
        newLen += YYStrMaxPrealloc;
    }
    newsh = realloc(sh, newLen+sizeof(YYStrHolder)+1);
    if (newsh == Null) {
        return Null;
    }
    newsh->free = newLen - len;
    return newsh->buf;
}

/* 移除字符串中的空闲空间 */
YYStr yyStrRemoveFreeSpace(YYStr s) {
    YYStrHolder *sh = (void *)(s - sizeof(YYStrHolder));
    sh = realloc(s, sizeof(YYStrHolder)+sh->len+1);
    sh->free = 0;
    return sh->buf;
}

/* 返回字符串的总大小,包括
 * 1.字符串指针头部 2.字符串正在使用的长度3.字符串空闲的buffer长度4.末尾的空值 */
size_t yyStrAllocSize(YYStr s) {
    YYStrHolder *sh = (void *)(s - sizeof(YYStrHolder));
    return sizeof(YYStrHolder) + sh->len + sh->free + 1;
}

/* 扩展字符串到指定的长度 */
YYStr yyStrGrowZero(YYStr s, size_t len) {
    YYStrHolder *sh = (void *)(s - sizeof(YYStrHolder));
    size_t totalLen, curLen = sh->len;
    
    if (len <= curLen) {
        return s;
    }
    s = yyStrMakeRoomFor(s, len - curLen);
    if (s == Null) {
        return Null;
    }
    sh = (void *)(s - sizeof(YYStrHolder));
    memset(s+curLen, 0, (len - curLen + 1));
    totalLen = sh->len + sh->free;
    sh->len = len;
    sh->free = totalLen - sh->free;
    return s;
}

/* 以t作为新添加的len长度buf的数据，实现追加操作 */
YYStr yyStrCatlength(YYStr s, const void *t, size_t len) {
    YYStrHolder *sh;
    size_t curLen = yyStrLength(s);
    
    s = yyStrMakeRoomFor(s, len);
    if (s == Null) {
        return Null;
    }
    sh = (void *)(s - sizeof(YYStrHolder));
    //多余的数据以t作初始化
    memcpy(s+curLen, t, len);
    sh->len = curLen + len;
    sh->free = sh->free-len;
    s[curLen+len] = '\0';
    return s;
}

/* 连接YYStr型字符串 */
YYStr yyStrCatStr(YYStr s, const YYStr t) {
    return yyStrCatlength(s, t, yyStrLength(t));
}

/* 追加普通字符串 */
YYStr yyStrCat(YYStr s, const void *t) {
    return yyStrCatlength(s, t, strlen(t));
}


YYStr yyStrCopyLength(YYStr s, const char *t, size_t len) {
    YYStrHolder *sh = (void *)(s - sizeof(YYStrHolder));
    size_t totalLen = sh->free+sh->len;
    
    if (totalLen < len) {
        s = yyStrMakeRoomFor(s, len - sh->len);
        if (s == Null) {
            return Null;
        }
        sh = (void *)(s - sizeof(YYStrHolder));
        totalLen = sh->free+sh->len;
    }
    
    memcpy(s, t, len);
    s[len] = '\0';
    sh->len = len;
    sh->free = totalLen - len;
    return s;
}
YYStr yyStrCopy(YYStr s, const char *t) {
    return yyStrCopyLength(s, t, strlen(t));
}

YYStr yyStrPrintf(YYStr s, const char *fmt, ...)__attribute__((format(printf, 2, 3)));
YYStr yyStrFmt(YYStr s, const char *fmt, ...);

/**
 * Example:
 *
 * s = sdsnew("AA...AA.a.aa.aHelloWorld     :::");
 * s = sdstrim(s,"A. :");
 * printf("%s\n", s);
 *
 * Output will be just "Hello World".
 */
YYStr yyStrTrim(YYStr s, const char *cset) {
    YYStrHolder *sh = (void *)(s - sizeof(YYStrHolder));
    char *start, *end, *sp, *ep;
    size_t len;
    
    sp = start = s;
    ep = end = s + yyStrLength(s) - 1;
    while (sp <= end && strchr(cset, *sp)) {
        sp++;
    }
    while (sp > start && strchr(cset, *ep)) {
        ep--;
    }
    len = (sp > ep) ? 0 : ((ep-sp)+1);
    if (sh->buf != sp) {
        memmove(sh->buf, sp, len);
    }
    sh->buf[len] = '\0';
    sh->free = sh->free+(sh->len - len);
    sh->len = len;
    return s;
    
}

/**
 * Example:
 *
 * s = sdsnew("Hello World");
 * sdsrange(s,1,-1); => "ello World"
 */
void yyStrRange(YYStr s, int start, int end) {
    YYStrHolder *sh = (void *)(s - sizeof(YYStrHolder));
    
    size_t newlen, len = yyStrLength(s);
    
    if (len == 0) return;
    if (start < 0) {
        start = len+start;
        if (start < 0) start = 0;
    }
    if (end < 0) {
        end = len+end;
        if (end < 0) end = 0;
    }
    newlen = (start > end) ? 0 : (end-start)+1;
    if (newlen != 0) {
        if (start >= (signed)len) {
            newlen = 0;
        } else if (end >= (signed)len) {
            end = len-1;
            newlen = (start > end) ? 0 : (end-start)+1;
        }
    } else {
        start = 0;
    }
    if (start && newlen) memmove(sh->buf, sh->buf+start, newlen);
    sh->buf[newlen] = 0;
    sh->free = sh->free+(sh->len-newlen);
    sh->len = newlen;
}

void yyStrUpdateLength(YYStr s) {
    YYStrHolder *sh = (void *)(s - sizeof(YYStrHolder));
    int realLength = strlen(s);
    sh->free += (sh->len - realLength);
    sh->len = realLength;
}

/* 清空字符串 */
void yyStrClear(YYStr s) {
    YYStrHolder *sh = (void *)(s - sizeof(YYStrHolder));
    sh->free += sh->len;
    sh->len = 0;
    //字符串中的缓存其实没有被丢底，只是把第一个设成了结束标志，以便下次操作可以复用
    sh->buf[0] = '\0';
}

/* Compare two sds strings s1 and s2 with memcmp().
 *
 * Return value:
 *
 *     1 if s1 > s2.
 *    -1 if s1 < s2.
 *     0 if s1 and s2 are exactly the same binary string.
 */
int yyStrCmp(const YYStr s1, const YYStr s2) {
    size_t l1, l2, minLen;
    int cmp;
    
    l1 = yyStrLength(s1);
    l2 = yyStrLength(s2);
    minLen = l1 < l2 ? l1 : l2;
    cmp = memcmp(s1, s2, minLen);
    if (cmp == 0) {
        return l1-l2;
    }
    return cmp;
}
/* sds字符串分割方法类似java.lang.String的spilt方法 */
YYStr *yyStrSpliteLength(const char *s, int len, const char *sep, int seplen, int *count);

void yyStrToLower(YYStr s) {
    int len = yyStrLength(s), j;
    for (j = 0; j < len; j++) {
        s[j] = tolower(s[j]);
    }
}
void yyStrToUpper(YYStr s) {
    int len = yyStrLength(s), j;
    for (j = 0; j < len; j++) {
        s[j] = toupper(s[j]);
    }
}























