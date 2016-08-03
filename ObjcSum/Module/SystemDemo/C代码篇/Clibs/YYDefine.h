//
//  YYDefine.h
//  MySimpleFrame
//
//  Created by sihuan on 15/3/19.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#ifndef MySimpleFrame_YYDefine_h
#define MySimpleFrame_YYDefine_h

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <ctype.h>
#include <setjmp.h>
#include <signal.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <errno.h>
#include <math.h>
#include <pthread.h>
#include <semaphore.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define Null NULL
#define VoidPtr (void *)

#define Len8       8
#define Len16      16
#define Len32      32
#define Len64      64
#define Len128     128
#define Len256     256
#define Len512     512
#define Len1024    1024
#define Len2048    2048
#define Len4096    4096

#define FileNameLen Len256  //文件名长度

//#define P(sem)  ExitIfFailWithMessage((sem_wait(sem) < 0), "P error")
//#define V(sem)  ExitIfFailWithMessage((sem_post(sem) < 0), "V error")
#define P(sem)  sem_wait(sem)
#define V(sem)  sem_post(sem)


#define DebugFmt "[File:%s Line:%d Fun:%s()]: "
#define DebugArgs __FILE__,__LINE__,__FUNCTION__

#define DebugPrint(fmt, ...) do{                      \
printf(DebugFmt fmt, DebugArgs, ##__VA_ARGS__);   \
}while(0)

#define SwapCommon(a, b) { typeof(a) c = a; a = b; b = c; }
#define SwapInt(a, b) { (a)^=(b)^=(a)^=(b); }


#define AddNodeToHead(node, head) { (node)->next = (head);(head) = (node); }
#define AddNodeToTail(node, tail) { (tail)->next = (node);(tail) = (node); }

// 把一个整数按8取整，比如RoundUp8(6) = 8，RoundUp8(11) = 16
#define RoundUp8(bytes) (((bytes) + Len8-1)&~(Len8 - 1))


#define NbitGet(m, n) ((m >> (n-1)) & 1)//获得m的第n位的值
#define NbitSetTo1(m, n) (m | (1 << n-1))//m的第n位设置成1
#define NbitSetTo0(m, n) (m & ~(1 << n-1))//m的第n位设置成0

#define ReturnWithMessage(msg)     do{   \
        fprintf(stderr, msg);          \
        return;                       \
    }while(0)


#define ExitWithMessage(msg)     do{   \
        fprintf(stderr, msg);          \
        exit(1);                       \
    }while(0)

#define ExitIfFailWithMessage(expr, msg)     do{ \
        if(!(expr)) {                            \
            fprintf(stderr, msg);                \
            exit(1);                             \
        }; }while(0)

#define ReturnIfFailWithMessage(expr, msg)     do{ \
        if(!(expr)) {                            \
            fprintf(stderr, msg);                \
            exit(1);                             \
        }; }while(0)














#endif
