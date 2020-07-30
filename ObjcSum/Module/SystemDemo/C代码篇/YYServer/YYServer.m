//
//  YYServer.m
//  ObjcSum
//
//  Created by yuany on 2020/2/22.
//  Copyright © 2020 sihuan. All rights reserved.
//

#import "YYServer.h"
#include "yyclib.h"





@implementation YYServer

void daytime_v4(const char *host) {
    int sockfd;
    size_t n;
    struct sockaddr_in serveraddr;
    
    /// socket函数创建一个网际（AF_INET）字节流（SOCK_STREAM）套接字，
    /// 它是TCP套接字的花哨名字。
    /// 该函数返回一个小整数描述符，
    /// 以后的所有函数调用（如随后的connect和read）就用该描述符来标识这个套接字。
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        err_quit("socket error");
    }
    
    /// 把服务器的IP地址和端口号填入一个网际套接字地址结构（一个名为servaddr的sockaddr_in结构变量）。
    /// 使用bzero把整个结构清零后，置地址族为AF_INET，
    /// 端口号为13（这是时间获取服务器的众所周知端口）。
    /// 网际套接字地址结构中IP地址和端口号这两个成员必须使用特定格式，
    /// 为此我们调用库函数htons（主机到网络短整数）去转换二进制端口号，
    /// 又调用库函数inet_pton（呈现形式到数值）去把ip字符串转换为合适的格式。
    /// 此处也许是你第一次遇到inet_pton函数。它是一个支持IPv6（详见附录A）的新函数。
    /// 以前的代码使用inet_addr函数来把ASCII点分十进制数串变换成正确的格式，
    /// 不过它有不少局限，而这些局限在inet_pton中都得以纠正。
    bzero(&serveraddr, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_port = htons(13);
    if (inet_pton(AF_INET, host, &serveraddr.sin_addr) <= 0) {
        err_quit("inet_pton error for %s", host);
    }
    
    /// connect函数应用于一个TCP套接字时，
    /// 将与由它的第二个参数指向的套接字地址结构指定的服务器建立一个TCP连接。
    /// 该套接字地址结构的长度也必须作为该函数的第三个参数指定
    if (connect(sockfd, (SA *)&serveraddr, sizeof(serveraddr)) < 0) {
        err_quit("connect error");
    }
    
    /// 使用read函数读取服务器的应答，并用标准的I/O函数fputs输出结果。
    /// 使用TCP时必须小心，因为TCP是一个没有记录边界的字节流协议。
    /// 服务器的应答通常是如下格式的26字节字符串：
    /// Mon May 26 20:58:40 2003\r\n
    /// 其中，\r是ASCII回车符，\n是ASCII换行符。
    /// 使用字节流协议的情况下，这26个字节可以有多种返回方式，
    /// 但是如果数据量很大，我们就不能确保一次read调用能返回服务器的整个应答。
    /// 因此从TCP套接字读取数据时，我们总是需要把read编写在某个循环中，
    /// 当read返回0（表明对端关闭连接）或负值（表明发生错误）时终止循环。
    char receiveline[MAXLINE + 1];
    while ((n = read(sockfd, receiveline, MAXLINE)) > 0) {
        receiveline[n] = 0;
        if (fputs(receiveline, stdout) == EOF) {
            err_quit("fputs error");
        }
    }
    
    /// 还可以用其他技术标记记录结束。
    /// 例如，SMTP（Simple Mail Transfer Protocol，简单邮件传送协议）
    /// 使用由ASCII回车符后跟换行符构成的2字节序列标记记录的结束；
    /// Sun远程过程调用（Remote Procedure Call，RPC）
    /// 以及域名系统（Domain Name System，DNS）在使用TCP承载应用数据时，
    /// 在每个要发送的记录之前放置一个二进制的计数值，给出这个记录的长度。
    /// 这里的重要概念是TCP本身并不提供记录结束标志：
    /// 如果应用程序需要确定记录的边界，它就要自己去实现，已有一些常用的方法可供选择。
    if (n < 0) {
        err_quit("read error");
    }
}

void daytime_v6(const char *host) {
    int sockfd;
    size_t n;
    struct sockaddr_in6 serveraddr;
    
    sockfd = socket(AF_INET6, SOCK_STREAM, 0);
    if (sockfd < 0) {
        err_quit("socket error");
    }
    
    bzero(&serveraddr, sizeof(serveraddr));
    serveraddr.sin6_family = AF_INET6;
    serveraddr.sin6_port = htons(13);
    if (inet_pton(AF_INET6, host, &serveraddr.sin6_addr) <= 0) {
        err_quit("inet_pton error for %s", host);
    }
    
    if (connect(sockfd, (SA *)&serveraddr, sizeof(serveraddr)) < 0) {
        err_quit("connect error");
    }
    
    char receiveline[MAXLINE + 1];
    while ((n = read(sockfd, receiveline, MAXLINE)) > 0) {
        receiveline[n] = 0;
        if (fputs(receiveline, stdout) == EOF) {
            err_quit("fputs error");
        }
    }
    if (n < 0) {
        err_quit("read error");
    }
}

void daytime_server_v4() {
    int listenfd, connfd;
    struct sockaddr_in serveraddr;
    
    listenfd = socket(AF_INET6, SOCK_STREAM, 0);
    if (listenfd < 0) {
        err_quit("socket error");
    }
    
    bzero(&serveraddr, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    serveraddr.sin_port = htons(13);
    /// 我们指定IP地址为INADDR_ANY，
    /// 这样要是服务器主机有多个网络接口，服务器进程就可以在任意网络接口上接受客户连接。以
    /// 后我们将了解怎样限定服务器进程只在单个网络接口上接受客户连接。
    bind(listenfd, (SA *)&serveraddr, sizeof(serveraddr));
    
    /// 调用listen函数把该套接字转换成一个监听套接字，
    /// 这样来自客户的外来连接就可在该套接字上由内核接受。
    /// socket、bind和listen这3个调用步骤是任何TCP服务器准备所谓的
    /// 监听描述符（listening descriptor，本例中为listenfd）的正常步骤。
    listen(listenfd, 1024);
    
    char buffer[MAXLINE];
    time_t ticks;
    while (1) {
        /// 通常情况下，服务器进程在accept调用中被投入睡眠，
        /// 等待某个客户连接的到达并被内核接受。
        /// TCP连接使用所谓的三路握手（three-way handshake）来建立连接。
        /// 握手完毕时accept返回，其返回值是一个称为已连接描述符（connected descriptor）的新描述符（本例中为connfd）。
        /// 该描述符用于与新近连接的那个客户通信。
        /// accept为每个连接到本服务器的客户返回一个新描述符。”
        connfd = accept(listenfd, (SA *) NULL, NULL);
        
        ticks = time(NULL);
        snprintf(buffer, sizeof(buffer), "%.24s\r\n", ctime(&ticks));
        write(connfd, buffer, strlen(buffer));
        close(connfd);
    }
}

int start(const char *host, int port, const char *serv, socklen_t *addrlenp) {
    int sockfd, n;
    struct addrinfo hints, *res, *ressave;
    
    bzero(&hints, sizeof(struct addrinfo));
    hints.ai_flags = AI_PASSIVE;
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_DGRAM;
    
    ///getnameinfo是getaddrinfo的互补函数，
    ///它以一个套接字地址为参数，返回描述其中的主机的一个字符串和描述其中的服务的另一个字符串。
    ///本函数以协议无关的方式提供这些信息，也就是说，
    ///调用者不必关心存放在套接字地址结构中的协议地址的类型，因为这些细节由本函数自行处理。
//    int getnameinfo(const struct sockaddr \*sockaddr, socklen_t addrlen,
//    　　　　　　　　　char \*host, socklen_t hostlen,
//    　　　　　　　　　char \*serv, socklen_t servlen, int flags);
    if ((n = getaddrinfo(host, serv, &hints, &res)) != 0) {
        
    }
    
    ressave = res;
    do {
        sockfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
        if (sockfd < 0) continue;
        if(bind(sockfd, res->ai_addr, res->ai_addrlen) == 0) break;
        close(sockfd);
    } while ((res = res->ai_next) != NULL);
        
    if (res == NULL) {
        
    }
    
    if (addrlenp) {
        *addrlenp = res->ai_addrlen;
    }
    
    return sockfd;
}


@end


