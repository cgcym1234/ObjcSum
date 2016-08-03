//
//  SummaryIO.c
//  MySumC
//
//  Created by sihuan on 15/4/2.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#include "SummaryIO.h"
#include "YYDefine.h"
#include "SummaryNetwork.h"

#pragma mark - 打开和关闭文件
int yyOpenAndClose(char *filename) {
    
    /**flags知名进程如何访问文件
     *  O_RDONLY：只读
     *  O_WRONLY：只写
     *  O_RDWR：可读可写
     
     也可以是一个或者更多位掩码的或：
     *  O_CREAT：如果文件不存在，就创建一个截断的文件（空文件）
     *  O_TRUNC：如果文件已经存在，就截断它（清空文件）
     *  O_APPEND：没次写操作前，设置文件位置到文件结尾处（往文件末尾添加数据）
     */
    int flags = O_RDONLY|O_WRONLY|O_RDWR|O_CREAT|O_TRUNC|O_APPEND;
    
    
    /**mode指定了新文件的访问权限
     *  S_IRUSR：使用者（拥有者）能够读这个文件
     *  S_IWUSR：使用者（拥有者）能够写这个文件
     *  S_IXUSR：使用者（拥有者）能够执行这个文件
     
     *  S_IRGRP：拥有者所在的组成员能够读这个文件
     *  S_IWGRP：拥有者所在的组成员能够写这个文件
     *  S_IXGRP：拥有者所在的组成员能够执行这个文件
     
     *  S_IROTH：其他人（任何人）能够读这个文件
     *  S_IWOTH：其他人（任何人）能够写这个文件
     *  S_IXOTH：其他人（任何人）能够执行这个文件
     
     */
    mode_t mode = S_IRUSR|S_IWUSR|S_IXUSR|S_IRGRP|S_IWGRP|S_IXGRP|S_IROTH|S_IWOTH|S_IXOTH;
    
    /**
     *  每个进程都有一个umask，当进程通过带mode参数的open函数调用来创建一个新的文件时，文件的访问权限位被设置为mode & ~umask，如下：
     */
    mode_t umaskDefault = S_IXGRP|S_IROTH;
    umask(umaskDefault);//这样就屏蔽了S_IXGRP|S_IROTH 2个权限，mode中加了这2个也无效了
    
    
    //进程通过open函数来打开一个已经存在的文件或者创建一个新的文件
    int retValue = open(filename, flags, mode);
    //成功:retValue > 0  失败：retValue =  -1
    
    
    /**
     *  通过close关闭打开的文件
     注意：关闭一个已经关闭的描述符会出错
     */
    close(retValue);
    
    return retValue;
}

#pragma mark - 读和写文件
void yyReadAndWrite(char *filename) {
    
    /**
     ssize_t read(int fd, void *buf, size_t n);
     返回值：
     成功： 读到的字节数
     读到EOF：0
     出错：-1
     
     ssize_t write(int fd, const void *buf, size_t n);
     返回值：
     成功： 写的字节数
     出错：-1
     */
    
    /**
     *  在某些情况下read和write传送的字节比我们要求的要少。返回不足值，但不表示有错误。原因如下：
     
     1  读时遇到EOF：文件只有20个字节，我们使用 ret = read(fd, buf, 50)读，
        这样第一次读，ret=20，后面再读 ret=0表示读到EOF
     
     2  从终端读文本行：打开文件是与终端想关联的（如键盘或显示器），那么每次read将一次传送一个文本行，返回的不足值为文本行的大小
     
     3  读和写网络套接字：文件是网络套接字的时候，内部缓存约束和较长的网络延迟会引起read和write返回不足值。
     
     4  读和写Unix管道文件也可能返回不足值
     
     */
    
    // 在读和写磁盘文件时，不会遇到不足值
    
}


static int rioRead(Rio *rp, char *usrbuf, size_t n);


Rio *rioInit(const char *fileName) {
    int fd = open(fileName, O_RDWR);
    return rioInitFd(fd);
}
Rio *rioInitFd(int fd) {
    if (fd < 0 ) {
        return Null;
    }
    
    Rio *rio = malloc(sizeof(Rio));
    rioConfigFd(rio, fd);
    
    return rio;
}
void rioConfigFd(Rio *rp, int fd) {
    rp->rioFd = fd;
    rp->rioRemain = 0;
    rp->rioBufPtr = rp->rioBuf;
}

ssize_t rioWriten(Rio *rp, void *usrbuf, size_t n) {
    return rioWritenFd(rp->rioFd, usrbuf, n);
}

ssize_t rioWritenFd(int fd, void *usrbuf, size_t n) {
    size_t nleft = n;
    ssize_t nwritten;
    char *bufp = usrbuf;
    
    while (nleft > 0) {
        nwritten = write(fd, bufp, nleft);
        if (nwritten <= 0) {
            if (errno == EINTR) {   /* interrupted by sig handler return */
                nwritten = 0;   /* and call write() again */
            } else {
                return -1;  /* errno set by write() */
            }
        }
        nleft -= nwritten;
        bufp += nwritten;
    }
    
    return n;
}


ssize_t rioReadn(Rio *rp, void *usrbuf, size_t n) {
    size_t nleft = n;
    ssize_t nread;
    char *bufp = usrbuf;
    
    while (nleft > 0) {
        if ((nread = rioRead(rp, bufp, nleft)) < 0) {
            if (errno == EINTR) {   /* interrupted by sig handler return */
                nread = 0;  /* call read() again */
            } else {
                return -1;  /* errno set by read() */
            }
        } else if (nread == 0) break;   /* EOF */
        
        nleft -= nread;
        bufp += nread;
    }
    
    return (n - nleft); /* return >= 0 */
}

ssize_t rioReadLine(Rio *rp, void *usrbuf, size_t maxlen) {
    ssize_t n, rc;
    char c, *bufp = usrbuf;
    
    for (n = 1; n < maxlen; n++) {
        rc = rioRead(rp, &c, 1);
        if (rc == 1) {
            *bufp++ = c;
            if (c == '\n') {
                break;
            }
        } else if(rc == 0) {
            if (n == 1) {
                return 0;   /* EOF, no data read */
            } else {
                break;  /* EOF, some data was read */
            }
        } else {
            return -1;  /* error */
        }
    }
    *bufp = 0;
    return n;
}

static int rioRead(Rio *rp, char *usrbuf, size_t n)
{
    size_t cnt;
    
    //先从自己的缓存里面读
    while (rp->rioRemain <= 0) {  /* refill if buf is empty */
        rp->rioRemain = (int)read(rp->rioFd, rp->rioBuf,
                           sizeof(rp->rioBuf));
        if (rp->rioRemain < 0) {
            if (errno != EINTR) {   /* interrupted by sig handler return */
                return -1;
            }
        } else if(rp->rioRemain == 0) {
            return 0;
        } else {
            rp->rioBufPtr = rp->rioBuf;
        }
    }
    
    /* Copy min(n, rp->rio_cnt) bytes from internal buf to user buf */
    cnt = rp->rioRemain < n ? rp->rioRemain : n;
    memcpy(usrbuf, rp->rioBufPtr, cnt);
    rp->rioBufPtr += cnt;
    rp->rioRemain -= cnt;
    
    return (int)cnt;
}






#pragma mark - echo
void echo1(int connfd)
{
    size_t n;
    char buf[Len1024];
    Rio rio;
    rioConfigFd(&rio, connfd);
    
    while((n = rioReadLine(&rio, buf, Len1024)) != 0) {
        printf("server received %zu bytes\n", n);
        rioWriten(&rio, buf, n);
    }
}

static int byteCnt = 0;
static sem_t mutex;

static void initEchoSafe() {
    sem_init(&mutex, 0, 1);
    byteCnt = 0;
}

void echoSafe(int connectedFd) {
    int n;
    char buf[Len1024];
    Rio rio;
    rioConfigFd(&rio, connectedFd);
    static pthread_once_t once = PTHREAD_ONCE_INIT;
    
    pthread_once(&once, initEchoSafe);
    
    while((n = rioReadLine(&rio, buf, Len1024)) != 0) {
        P(&mutex);
        byteCnt += n;
        printf("thread %d received %d (%d total) bytes on fd %d\n",
               (int) pthread_self(), n, byteCnt, connectedFd);
        V(&mutex);
        rioWriten(&rio, buf, n);
    }
}




