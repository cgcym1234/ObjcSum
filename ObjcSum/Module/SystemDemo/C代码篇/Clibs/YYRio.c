//
//  YYRio.c
//  MySimpleFrame
//
//  Created by sihuan on 15/3/24.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#include "YYRio.h"
#include "YYUtil.h"

#include <string.h>
#include <stdio.h>
#include <unistd.h>


/* Define aof_fsync to fdatasync() in Linux and fsync() for all the rest */
#ifdef __linux__
#define aof_fsync fdatasync
#else
#define aof_fsync fsync
#endif


#pragma mark - 默认的读写操作等函数

#pragma mark buffer相关
static size_t yyRioBufferWrite(YYRio *r, const void *buf, size_t len) {
    r->io.buffer.ptr = yyStrCatlength(r->io.buffer.ptr, buf, len);
    r->io.buffer.pos += len;
    return 1;
}
static size_t yyRioBufferRead(YYRio *r, void *buf, size_t len) {
    if (yyStrLength(r->io.buffer.ptr) - r->io.buffer.pos < len) {
        return 0;
    }
    
    memcpy(buf, r->io.buffer.ptr+r->io.buffer.pos,len);
    r->io.buffer.pos += len;
    return 1;
}
static off_t yyRioBufferTell(YYRio *r) {
    return r->io.buffer.pos;
}

#pragma mark file相关
static size_t yyRioFileWrite(YYRio *r, const void *buf, size_t len) {
    size_t retval;
    
    retval = fwrite(buf, len, 1, r->io.file.fp);
    r->io.file.buffered += len;
    
    //判读是否需要同步
    if (r->io.file.autosync && r->io.file.buffered >= r->io.file.autosync) {
        fflush(r->io.file.fp);
        aof_fsync(fileno(r->io.file.fp));
        r->io.file.buffered = 0;
    }
    return retval;
}
static size_t yyRioFileRead(YYRio *r, void *buf, size_t len) {
    return fread(buf, len, 1, r->io.file.fp);
}
static off_t yyRioFileTell(YYRio *r) {
    return ftell(r->io.file.fp);
}

#pragma mark - 根据上面描述的方法，定义了BufferRio和FileRio
static const YYRio yyRioBufferIO = {
    yyRioBufferRead,
    yyRioBufferWrite,
    yyRioBufferTell,
    NULL,
    0,
    0,
    0,
    { { NULL, 0} }
};
static const YYRio yyRioFileIO = {
    yyRioFileRead,
    yyRioFileWrite,
    yyRioFileTell,
    NULL,
    0,
    0,
    0,
    { { NULL, 0} }
};


/* 初始化rio中的file变量 */
void yyRioInitWithFile(YYRio *r, FILE *fp) {
    *r = yyRioFileIO;
    r->io.file.fp = fp;
    r->io.file.buffered = 0;
    r->io.file.autosync = 0;
}
void yyRioInitWithBuffer(YYRio *r, YYStr s) {
    *r = yyRioBufferIO;
    r->io.buffer.ptr = s;
    r->io.buffer.pos = 0;
}

#pragma mark - /* rio写入不同类型数据方法，调用的是riowrite方法 */
/* Write multi bulk count in the format: "*<count>\r\n". */
size_t yyRioWriteBulkCount(YYRio *r, char prefix, size_t count) {
    char cbuf[128];
    int clen;
    
    cbuf[0] = prefix;
    clen = 1 + yyUtilLL2string(cbuf+1, sizeof(cbuf)-1, count);
    cbuf[clen++] = '\r';
    cbuf[clen++] = '\n';
    if (yyRioWrite(r, cbuf, clen) == 0) {
        return 0;
    }
    return clen;
}

/* Write binary-safe string in the format: "$<count>\r\n<payload>\r\n". */
size_t yyRioWriteBulkString(YYRio *r, const char *buf, size_t len) {
    size_t nwritten;
    
    if ((nwritten = yyRioWriteBulkCount(r, '$', len)) == 0) {
        return 0;
    }
    if (len > 0 && yyRioWrite(r, buf, len) == 0) {
        return 0;
    }
    if (yyRioWrite(r, "\r\n", 2) == 0) {
        return 0;
    }
    return nwritten+len+2;
}

size_t yyRioWriteBulkDouble(YYRio *r, double d) {
    char dbuf[128];
    int dlen;
    
    dlen = snprintf(dbuf, sizeof(dbuf), "%.17g", d);
    return yyRioWriteBulkString(r, dbuf, dlen);
}
size_t yyRioWriteBulkLongLong(YYRio *r, long long l) {
    char lbuf[32];
    int llen;
    
    llen = yyUtilLL2string(lbuf,sizeof(lbuf),l);
    return yyRioWriteBulkString(r, lbuf, llen);
}


/* 计算校验和用的是循环冗余校验算法 */
void yyRioGenericUpdateChecksum(YYRio *r, const void *buf, size_t len);
/* 设置多少大小值时进行，自动同步 */
void yyRioSetAutoSync(YYRio *r, off_t bytes) {
    //assert(r->read == yyRioFileIO.read);
    r->io.file.autosync = bytes;
}


















