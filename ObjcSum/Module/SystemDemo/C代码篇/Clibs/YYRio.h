//
//  YYRio.h
//  MySimpleFrame
//
//  Created by sihuan on 15/3/24.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#ifndef __MySimpleFrame__YYRio__
#define __MySimpleFrame__YYRio__

#include <stdio.h>
#include <stdint.h>

#include "YYStr.h"

#pragma mark - rio是Redis为了I/O封装的一个类，提供了流读入/流读出方法，还有获取当前偏移量的方法,在rio中还提到了校验和的变量
typedef struct YYRio YYRio;

struct YYRio {
    /* 数据流的读方法 */
    size_t (*read)(YYRio *, void *buf, size_t len);
    
    /* 数据流的写方法 */
    size_t (*write)(YYRio *, const void *buf, size_t len);
    
    /* 获取当前的读写偏移量 */
    off_t (*tell)(YYRio *);
    
    /* 当读入新的数据块的时候，会更新当前的校验和 */
    void (*updateCksum)(YYRio *, const void *buf, size_t len);
    
    uint64_t cksum; /* 当前的校验和 */
    size_t processedBytes;  /* 当前读取的或写入的字节大小 */
    size_t maxProcessingChunk;  /* 最大的单次读写的大小 */
    
    /* rio中I/O变量 */
    union {
        struct {
            YYStr ptr;
            off_t pos;
        } buffer;
        
        struct {
            FILE *fp;
            off_t buffered;
            off_t autosync; //同步的大小
        } file;
    } io;
};

static inline size_t yyRioWrite(YYRio *r, const void *buf, size_t len) {
    while (len) {
        //判断当前操作字节长度是否超过最大长度
        size_t bytesToWrite = (r->maxProcessingChunk && r->maxProcessingChunk < len) ? r->maxProcessingChunk : len;
        
        if (r->updateCksum) {
            r->updateCksum(r, buf, bytesToWrite);
        }
        
        if (r->write(r, buf, bytesToWrite) == 0) {
            return 0;
        }
        buf = buf + bytesToWrite;
        len -= bytesToWrite;
        r->processedBytes += bytesToWrite;
    }
    return 1;
}

static inline size_t yyRioRead(YYRio *r, void *buf, size_t len) {
    while (len) {
        //判断当前操作字节长度是否超过最大长度
        size_t bytes_to_read = (r->maxProcessingChunk && r->maxProcessingChunk < len) ? r->maxProcessingChunk : len;
        //读数据方法
        if (r->read(r,buf,bytes_to_read) == 0)
            return 0;
        //读数据时，更新校验和
        if (r->updateCksum) r->updateCksum(r,buf,bytes_to_read);
        buf = (char*)buf + bytes_to_read;
        len -= bytes_to_read;
        r->processedBytes += bytes_to_read;
    }
    return 1;
}

static inline off_t yyRioTell(YYRio *r) {
    return r->tell(r);
}

/* 初始化rio中的file变量 */
void yyRioInitWithFile(YYRio *r, FILE *fp);
void yyRioInitWithBuffer(YYRio *r, YYStr s);

size_t yyRioWriteBulkCount(YYRio *r, char prefix, size_t count);
size_t yyRioWriteBulkDouble(YYRio *r, double d);
size_t yyRioWriteBulkLongLong(YYRio *r, long long l);
size_t yyRioWriteBulkString(YYRio *r, const char *prefix, size_t len);

/* 计算校验和用的是循环冗余校验算法 */
void yyRioGenericUpdateChecksum(YYRio *r, const void *buf, size_t len);
/* 设置多少大小值时进行，自动同步 */
void yyRioSetAutoSync(YYRio *r, off_t bytes);

#endif /* defined(__MySimpleFrame__YYRio__) */


















