//
//  SummaryNetwork.h
//  MySumC
//
//  Created by sihuan on 15/4/2.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#ifndef __MySumC__SummaryNetwork__
#define __MySumC__SummaryNetwork__

#include "YYDefine.h"

#pragma mark - IP地址
/**
 *  一个ip地址就是一个32位无符号整数，放在如下结构体中
 放在结构体中是因为历史原因。。。
 */
struct in_addr_ {
    unsigned int s_addr;
};

/**
 *  主机可以有不同的字节序列，TCP/IP定义了统一的网络字节顺序（network byte order）为大端字节顺序，下面函数实现转换：
 */

//主机转网络
unsigned long int htonl_(unsigned long int hostlong);
unsigned short int htons_(unsigned long int hostlong);

//网络转主机
unsigned long int ntohl_(unsigned long int hostlong);
unsigned short int ntohs_(unsigned long int hostlong);

/**
 *  ip通常以点分十进制表示，192.168.1.1
 下面函数实现转换
 */

/**
 *  将192.168.x.x 转换成一个网络字节顺序的ip地址
 *
 *  @return 成功返回1，出错0  application to network
 */
int inet_aton_(const char *cp, struct in_addr *inp);

char *inet_ntoa_(struct in_addr in);


#pragma mark - 因特网域名
/**
 *  因特网定义了域名集合和IP地址之间的映射，通过世界范围内的数据库（DNS（Domain Name System），域名系统）来维护。结构如下：
 */
struct hostent_ {
    char *h_name;   /* official name of host */
    char **h_aliases;   /* array of domain names */
    int h_addrtype; /* host address type (AF_INET)*/
    int h_length;   /* length of address */
    char **h_addr_list; /* array of in_addr structs */
};

/**
 *  返回和域名name相关的主机条目
 *
 *  @return 出错：NULL指针，同时设置h_errno
            成功：非NULL指针
 */
struct hostent *gethostbyname_(const char *name);

/**
 *  返回和ip地址相关的主机条目
 *
 *  @return 出错：NULL指针，同时设置h_errno
    成功：非NULL指针
*/
struct hostent *gethostbyaddr_(const char *addr, int len, int);

#pragma mark 查看DNS信息
void hostInfo(char *arg);


#pragma mark - 因特网连接
/**
 *  客户端和服务器通过 连接 来通信，它是点对点，全双工，可靠的
 
 一个 套接字 是连接的一个端点。比如：
 
 客户端的套接字地址：128.2.194.242:51213（端口由内核自动分配的）
 服务器的套接字地址：208.163.181.15:80（端口要事先知道）
 
 而一个连接由它2端的套接字地址唯一确定，称为套接字对
 （128.2.194.242:51213, 208.163.181.15:80）
 */

#pragma mark - 套接字接口
/**
 *  结构体如下：
 */

//实际套接字结构，用的时候要转换成下面的
struct sockaddr_in_ {
    unsigned short sin_family;  /* 地址簇 (always AF_INET)*/
    unsigned short sin_port;    /* 16位的端口号 大端*/
    struct in_addr sin_addr;    /* IP地址 */
    unsigned char sin_zero[8];  /* 凑数的，凑到32个字节 Pad to sizeof(struct sockaddr)*/
};


//用来connet,bind,accept的通用套接字结构
struct sockaddr_ {
    unsigned short sa_family;   //Protocol family
    char sa_data[14];   //Address data
};


/**
 *  创建一个套接字描述符（socket descriptor）
 *
 *  @param domain   AF_INET
 *  @param type     SOCK_STREAM
 *  @param protocol 0
 *
 *  @return -1：出错， 成功：非负整数
 
 socket返回的clientfd描述符紧是部分打开的，还不能用于读写。
 如何完成打开套接字的工作，取决于是客户端还是服务器。
 */
int socket_(int domain, int type, int protocol);


/**
 *  connect函数试图与套接字地址为serv_addr的服务器建立一个Inter网连接
 它会一直阻塞，一直到连接成功或者发生错误。成功后sockfd就能读写了
 *
 *  @return 成功：0， 出错：-1
 */
int connect_(int sockfd, struct sockaddr *serv_addr, int addrlen);


/**
 *  建立链接
 *
 *  @param hostname 服务器域名或ip地址
 *  @param port     端口
 *
 *  @return 成功：打开的套接字描述符；失败：-1
 */
int openClientFd(char *hostname, int port);




#pragma mark - bind,listen,accept

/**
 *  bind函数告诉内核将my_addr中的服务器套接字地址和套接字描述符sockfd联系起来
 *
 *  @return 成功：0；失败：-1
 */
int bind_(int sockfd, struct sockaddr_in *my_addr, int addrlen);

/**
 *  将sockfd从主动套接字转化为一个监听套接字，可以接受来自客户端的连接请求。
 *
 *  @param backlog 让内核在开始拒绝连接请求前，放入队列中等待的未完成连接的请求数量。通常设置大一点，1024
 *
 *  @return 成功：0；失败：-1
 */
int liseten_(int sockfd, int backlog);


/**
 *  返回一个监听描述符，在port上接受连接请求。
 *
 *  @return @return 成功：0；失败：-1
 */
int openListenFd(int port);


/**
 *  等待来自客户端的连接请求，返回一个新的已连接描述符（connected descriptor），并在addr中填写客户端的套接字信息，
 *
 *  @return 成功：连接的套接字描述符；失败：-1
 */
int accept_(int listenfd, struct sockaddr *addr, int *addlen);



#pragma mark - EOF表示什么
/**
 *  其实并没有像EOF字符这样的东西，EOF是内核检测到的一种条件。
 应用程序在它接受到一个由read函数返回的0时，就会发现EOF条件。
 
 对于磁盘文件，当前文件位置超出文件长度时，就会发生EOF。
 对于因特网连接，当一个进程关闭连接它的那一端时，发生EOF
 */

#pragma mark - Tiny Http 服务器
/*
 * A simple, iterative HTTP/1.0 Web server that uses the
 *     GET method to serve static and dynamic content.
 */

void yyHttpServer1(int port);































#endif /* defined(__MySumC__SummaryNetwork__) */
