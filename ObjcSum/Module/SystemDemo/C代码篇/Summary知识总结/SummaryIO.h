//
//  SummaryIO.h
//  MySumC
//
//  Created by sihuan on 15/4/2.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#ifndef __MySumC__SummaryIO__
#define __MySumC__SummaryIO__

#include <stdio.h>

#pragma mark - 系统级IO总结

#define YYioBufSize 8192

typedef struct Rio {
    int rioFd;                  //打开的文件描述符
    int rioRemain;              //buf中剩余的字节数
    char *rioBufPtr;            //buf中没有读到字节的指针位置
    char rioBuf[YYioBufSize];
}Rio;



Rio *rioInit(const char *fileName);
Rio *rioInitFd(int fd);
void rioConfigFd(Rio *, int fd);

ssize_t rioReadn(Rio *, void *usrbuf, size_t n);
ssize_t rioReadLine(Rio *rp, void *usrbuf, size_t maxlen);
ssize_t rioWriten(Rio *, void *usrbuf, size_t n);

ssize_t rioWritenFd(int fd, void *usrbuf, size_t n);

#pragma mark - echo
void echo1(int connfd);


#endif /* defined(__MySumC__SummaryIO__) */
