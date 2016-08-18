//
//  SummaryNetwork.c
//  MySumC
//
//  Created by sihuan on 15/4/2.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#include "SummaryNetwork.h"
#include "SummaryConcurrency.h"


#include <string.h>

void hostInfo(char *arg) {
    if (!arg) {
        return;
    }
    
    struct in_addr addr;
    struct hostent *hostPtr;
    
    if (inet_aton(arg, &addr) != 0) {//arg是x.x.x.x
        hostPtr = gethostbyaddr(&addr, sizeof(addr), AF_INET);
    } else {
        hostPtr = gethostbyname(arg);
    }
    
    printf("official hostname: %s\n", hostPtr->h_name);
    
    char **pp;
    for (pp = hostPtr->h_aliases; *pp != NULL; pp++) {
        printf("alias: %s\n", *pp);
    }
    
    for (pp = hostPtr->h_addr_list; *pp != NULL; pp++) {
        struct in_addr *temp = (struct in_addr *)*pp;
        printf("address: %s\n", inet_ntoa(*temp));
    }
}

/**
 *  建立链接
 *
 *  @param hostname 服务器域名或ip地址
 *  @param port     端口
 *
 *  @return 成功：打开的套接字描述符；失败：-1
 */
int openClientFd(char *hostname, int port) {
    int clientfd;
    
    clientfd = socket(AF_INET, SOCK_STREAM, 0);
    if (clientfd < 0) {
        return -1;
    }
    
    struct in_addr addr;
    struct hostent *hostPtr;
    struct sockaddr_in serveraddr;
    
    if (inet_aton(hostname, &addr) != 0) {//arg是x.x.x.x
        hostPtr = gethostbyaddr(&addr, sizeof(addr), AF_INET);
    } else {
        hostPtr = gethostbyname(hostname);
    }
    
    if (hostPtr == NULL) {
        return -1;
    }
    
    bzero(&serveraddr, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    bcopy(hostPtr->h_addr_list[0], &serveraddr.sin_addr.s_addr, hostPtr->h_length);
    serveraddr.sin_port = htons(port);
    
    if (connect(clientfd, (struct sockaddr*)&serveraddr, sizeof(serveraddr)) < 0) {
        return -1;
    }
    
    return clientfd;
}

/**
 *  返回一个监听描述符，在port上接受连接请求。
 *
 *  @return 成功：0；失败：-1
 */
int openListenFd(int port) {
    int listenfd, optval = -1;
    struct sockaddr_in serveraddr;
    
    listenfd = socket(AF_INET, SOCK_STREAM, 0);
    if (listenfd < 0) {
        return -1;
    }
    
    if ((setsockopt(listenfd, SOL_SOCKET, SO_REUSEADDR, &optval, sizeof(optval))) < 0) {
        return -1;
    }
    
    bzero(&serveraddr, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    
    /**
     *  作为服务器，你要绑定【bind】到本地的IP地址上进行监听【listen】，但是你的机器上可能有多块网卡，也就有多个IP地址，这时候你要选择绑定在哪个IP上面，如果指定为INADDR_ANY，那么系统将绑定默认的网卡【即IP地址】。
     */
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    serveraddr.sin_port = htons(port);
    
    if ((bind(listenfd, (struct sockaddr *)&serveraddr, sizeof(serveraddr))) < 0) {
        return -1;
    }
    
    if (listen(listenfd, 1024) < 0) {
        return -1;
    }
    
    return listenfd;
}



#pragma mark - Tiny Http 服务器

void doit(int fd);
void clientError(int fd, char *cause, char *errNum,
                 char *shortMsg, char *longMsg);
void readRequestHeaders(Rio *rp);
int parseUri(char *uri, char *filename, char *cgiargs);
void serverStaic(int fd, char *fileName, int fileSize);
void getFileType(char *fileName, char *fileType);
void serverDynamic(int fd, char *fileName, char *args);

void yyHttpServer1(int port) {
    int listenFd, connectedFd;
    socklen_t clientLen = sizeof(struct sockaddr_in);
    struct sockaddr_in clientAddr;
    
    listenFd = openListenFd(port);
    YYClent *client = yyClientInit(listenFd);
    
    /* Wait for listening/connected descriptor(s) to become ready */
    while (1) {
        client->readySet = client->readSet;
        
        /*
         select函数检测到输入事件，yyClientAdd创建一个新的逻辑流（状态机），
         yyClientCheck函数通过回送输入行来执行状态转移，而且当客户端完成文本行发送时，
         它还要删除这个状态机。
         */
        client->readyNum = select(client->maxFd+1, &client->readSet, Null, Null, Null);
        
        /* If listening descriptor ready, add new client to pool */
        if (FD_ISSET(listenFd, &client->readSet)) {
            connectedFd = accept(listenFd, (struct sockaddr *)&clientAddr, &clientLen);
            doit(connectedFd);
            close(connectedFd);
        }
        
    }
}

void yyClientDoit(YYClent *client) {
    int i, connectedFd, n;
    char buf[Len1024];
    Rio rio;
    
    /* If the descriptor is ready, echo a text line from it */
    for (i = 0; (i < client->maxIndex) && (client->readyNum > 0); i++) {
        connectedFd = client->clientFd[i];
        rio = client->clientRio[i];
        
        if ((connectedFd > 0) && (FD_ISSET(connectedFd, &client->readySet))) {
            client->readyNum--;
            
        } else {    /* EOF detected, remove descriptor from pool */
            close(connectedFd);
            FD_CLR(connectedFd, &client->readSet);
            client->clientFd[i] = -1;
        }
    }
}


/*
 * doit - handle one HTTP request/response transaction
 */
/* $begin doit */
void doit(int fd) {
    int isStatic;
    struct stat sbuf;
    char buf[Len1024], method[Len1024], uri[Len1024], version[Len1024];
    char fileName[Len1024], cgiArgs[Len1024];
    Rio rio;
    
    rioConfigFd(&rio, fd);
    rioReadLine(&rio, buf, Len1024);
    printf("doit buf: %s\n", buf);
    sscanf(buf, "%s %s %s", method, uri, version);
    
    if (strcasecmp(method, "GET")) {
        clientError(fd, method, "501", "Not Implemented",
                    "Tiny does not implement this method");
        return;
    }
    
    readRequestHeaders(&rio);
    isStatic = parseUri(uri, fileName, cgiArgs);
    
    if (stat(fileName, &sbuf) < 0) {
        clientError(fd, fileName, "404", "Not found",
                    "Tiny couldn't find this file");
        return;
    }
    
    if (isStatic) {
        if (!(S_ISREG(sbuf.st_mode)) || !(S_IRUSR & sbuf.st_mode)) {
            clientError(fd, fileName, "403", "Forbidden",
                        "Tiny couldn't read the file");
            return;
        }
        
        serverStaic(fd, fileName, sbuf.st_size);
    } else {
        if (!(S_ISREG(sbuf.st_mode)) || !(S_IXUSR & sbuf.st_mode)) {
            clientError(fd, fileName, "403", "Forbidden",
                        "Tiny couldn't run the CGI program");
            return;
        }
        serverDynamic(fd, fileName, cgiArgs);
    }
    
    
    
}

/*
 * clienterror - returns an error message to the client
 */

void clientError(int fd, char *cause, char *errNum,
                 char *shortMsg, char *longMsg) {
    char buf[Len1024], body[Len1024];
    
    /* Build the HTTP response body */
    sprintf(body, "<html><title>Tiny Error</title>");
    sprintf(body, "%s<body bgcolor=""ffffff"">\r\n", body);
    sprintf(body, "%s%s: %s\r\n", body, errNum, shortMsg);
    sprintf(body, "%s<p>%s: %s\r\n", body, longMsg, cause);
    sprintf(body, "%s<hr><em>The tiny web server</em>\r\n", body);
    
    /* Print the HTTP response */
    sprintf(buf, "HTTP/1.0 %s %s\r\n", errNum, shortMsg);
    rioWritenFd(fd, buf, strlen(buf));
    
    sprintf(buf, "Content-type: text/html\r\n");
    rioWritenFd(fd, buf, strlen(buf));
    
    sprintf(buf, "Content-length: %lu\r\n\r\n", strlen(body));
    rioWritenFd(fd, buf, strlen(buf));
    rioWritenFd(fd, body, strlen(body));
}

void readRequestHeaders(Rio *rp) {
    char buf[Len1024];
    
    rioReadLine(rp, buf, Len1024);
    
    while (strcmp(buf, "\r\n")) {
        rioReadLine(rp, buf, Len1024);
        printf("%s ", buf);
    }
    return;
}


/*
 * parse_uri - parse URI into filename and CGI args
 *             return 0 if dynamic content, 1 if static
 */
int parseUri(char *uri, char *filename, char *cgiargs) {
    char *ptr;
    
    if (!strstr(uri, "cgi-bin")) {  /* Static content */ //line:netp:parseuri:isstatic
        strcpy(cgiargs, "");                             //line:netp:parseuri:clearcgi
        strcpy(filename, ".");                           //line:netp:parseuri:beginconvert1
        strcat(filename, uri);                           //line:netp:parseuri:endconvert1
        if (uri[strlen(uri)-1] == '/')                   //line:netp:parseuri:slashcheck
            strcat(filename, "home.html");               //line:netp:parseuri:appenddefault
        return 1;
    }
    else {  /* Dynamic content */                        //line:netp:parseuri:isdynamic
        ptr = index(uri, '?');                           //line:netp:parseuri:beginextract
        if (ptr) {
            strcpy(cgiargs, ptr+1);
            *ptr = '\0';
        }
        else
            strcpy(cgiargs, "");                         //line:netp:parseuri:endextract
        strcpy(filename, ".");                           //line:netp:parseuri:beginconvert2
        strcat(filename, uri);                           //line:netp:parseuri:endconvert2
        return 0;
    }
}

/*
 * serve_static - copy a file back to the client
 */
void serverStaic(int fd, char *fileName, int fileSize) {
    int srcFd;
    char *scrPtr, fileType[Len1024], buf[Len1024];
    
    /* Send response headers to client */
    getFileType(fileName, fileType);
    sprintf(buf, "HTTP/1.0 200 OK\r\n");    //line:netp:servestatic:beginserve
    sprintf(buf, "%sServer: Tiny Web Server\r\n", buf);
    sprintf(buf, "%sContent-length: %d\r\n", buf, fileSize);
    sprintf(buf, "%sContent-type: %s\r\n\r\n", buf, fileType);
    rioWritenFd(fd, buf, strlen(buf));
    
    /* Send response body to client */
    srcFd = open(fileName, O_RDONLY, 0);
    scrPtr = mmap(0, fileSize, PROT_READ, MAP_PRIVATE, srcFd, 0);
    close(srcFd);
    rioWritenFd(fd, scrPtr, fileSize);
    munmap(scrPtr, fileSize);
}

void getFileType(char *fileName, char *fileType) {
    if (strstr(fileName, ".html")) {
        strcpy(fileType, "text/html");
    } else if (strstr(fileName, ".gif")) {
        strcpy(fileType, "image/gif");
    } else if (strstr(fileName, ".jpg")) {
        strcpy(fileType, "image/jpeg");
    } else {
        strcpy(fileType, "text/plain");
    }
}

void serverDynamic(int fd, char *fileName, char *args) {
    char buf[Len1024];
    char *emptyList[] = { Null };
    
    sprintf(buf, "HTTP/1.0 200 OK\r\n");
    rioWritenFd(fd, buf, strlen(buf));
    
    sprintf(buf, "Server: Tiny Web Server\r\n");
    rioWritenFd(fd, buf, strlen(buf));
    
    if (fork() == 0) {  /* child */
        setenv("QUERY_STRING", args, 1);    /* Real server would set all CGI vars here */

        dup2(fd, STDOUT_FILENO);
        execve(fileName, emptyList, Null);  /* Run CGI program */
    }
    wait(Null); /* Parent waits for and reaps child */
}




































