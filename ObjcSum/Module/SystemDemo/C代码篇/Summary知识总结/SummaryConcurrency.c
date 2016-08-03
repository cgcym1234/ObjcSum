//
//  SummaryConcurrency.c
//  MySumC
//
//  Created by sihuan on 15/4/3.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#include "SummaryConcurrency.h"
#include "YYDefine.h"
#include "SummaryThread.h"

#define MAXLINE 1000


void command() {
    char buf[MAXLINE];
    if (!fgets(buf, MAXLINE, stdin))
        exit(0); /* EOF */
    printf("%s", buf); /* Process the input command */
}



#pragma mark - 处理一组描述符准备好读的情况
void selectDemo1(int port) {
    int listenfd, confd;
    struct sockaddr_in clientaddr;
    socklen_t clientlen = sizeof(struct sockaddr_in);
    fd_set readSet, readySet;
    
    listenfd = openListenFd(port);
    
    FD_ZERO(&readSet);
    FD_SET(STDIN_FILENO, &readSet); /* Add stdin to read set */
    FD_SET(listenfd, &readSet); /* Add listenfd to read set */
    
    while (1) {
        readySet = readSet;
        select(listenfd+1, &readySet, NULL, NULL, NULL);
        
        //select返回就判断是哪个fd可读
        if (FD_ISSET(STDIN_FILENO, &readySet)) {
            command();  /* Read command line from stdin */
        }
        if (FD_ISSET(listenfd, &readySet)) {
            confd = accept(listenfd, (struct sockaddr*)&clientaddr, &clientlen);
            echo1(confd);    /* Echo client input until EOF */
            close(confd);
        }
    }
}



int byteTotal = 0; /* counts total bytes received by server */

YYClent *yyClientInit(int listenFd) {
    YYClent *client = malloc(sizeof(YYClent));
    yyClientConfig(client, listenFd);
    
    return client;
}

void yyClientConfig(YYClent *client, int listenFd) {
    int i;
    client->maxIndex = -1;
    for (i = 0; i < FD_SETSIZE; i++) {
        client->clientFd[i] = -1;
    }
    
    /* Initially, listenfd is only member of select read set */
    client->maxFd = listenFd;
    FD_ZERO(&client->readSet);
    FD_SET(listenFd, &client->readSet);
}

void yyClientAdd(YYClent *client, int conectedFd) {
    int i;
    client->readyNum--;
    for (i = 0; i < FD_SETSIZE; i++) {  /* Find an available slot */
        if (client->clientFd[i] < 0) {
            client->clientFd[i] = conectedFd;/* Add connected descriptor to the pool */
            rioConfigFd(&client->clientRio[i], conectedFd);
            
            FD_SET(conectedFd, &client->readSet);   /* Add the descriptor to descriptor set */
            
            if (conectedFd > client->maxFd) {
                client->maxFd = conectedFd; /* Update max descriptor and pool highwater mark */
            }
            
            if (i > client->maxIndex) {
                client->maxIndex = i;
            }
            break;
        }
    }
    
    if (i == FD_SETSIZE) {  /* Couldn't find an empty slot */
        ExitWithMessage("yyClientAdd error: Too many clients");
    }
}
void yyClientCheck(YYClent *client) {
    int i, connectedFd, n;
    char buf[MAXLINE];
    Rio rio;
    
    for (i = 0; (i <= client->maxIndex) && (client->readyNum > 0); i++) {
        connectedFd = client->clientFd[i];
        rio = client->clientRio[i];
        
        if ((connectedFd > 0) && (FD_ISSET(connectedFd, &client->readySet))) {
            client->readyNum--;
            
            /* If the descriptor is ready, echo a text line from it */
            if ((n = (int)rioReadLine(&rio, buf, MAXLINE)) != 0) {
                byteTotal += n;
                printf("Server received %d (%d total) bytes on fd %d\n",
                       n, byteTotal, connectedFd);
                rioWriten(&rio, buf, n);
            } else {    /* EOF detected, remove descriptor from pool */
                close(connectedFd);
                FD_CLR(connectedFd, &client->readSet);
                printf("client disconnected, fd: %d", connectedFd);
                client->clientFd[i] = -1;
            }
        }
    }
}


void selectDemo2(int port) {
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
        client->readyNum = select(client->maxFd+1, &client->readySet, Null, Null, Null);
        
        /* If listening descriptor ready, add new client to pool */
        if (FD_ISSET(listenFd, &client->readySet)) {
            connectedFd = accept(listenFd, (struct sockaddr *)&clientAddr, &clientLen);
            printf("client connected, addr: %s", inet_ntoa(clientAddr.sin_addr));
            yyClientAdd(client, connectedFd);
        }
        
        yyClientCheck(client);  /* Echo a text line from each ready connected descriptor */
    }
    
}



#pragma mark - 基于预线程化的（线程池）并发服务器

#define ThreadNums 4
#define SbufSize 16

Sbuf sbuf;

void *doTask(void *argptr) {
    pthread_detach(pthread_self());
    
    while (1) {
        int connectedFd = sbufRemove(&sbuf);    /* Remove connfd from buffer */
        echo1(connectedFd); /* Service client */
        close(connectedFd);
    }
}

void threadServer(int port) {
    int i, listenFd, connectedFd;
    socklen_t clientLen = sizeof(struct sockaddr_in);
    struct sockaddr_in clientAddr;
    
    listenFd = openListenFd(port);
    sbufInit(&sbuf, SbufSize);
    
    pthread_t tid;
    for (i = 0; i < ThreadNums; i++) {
        pthread_create(&tid, Null, doTask, Null);
    }
    
    /* Wait for listening/connected descriptor(s) to become ready */
    while (1) {
        connectedFd = accept(listenFd, (struct sockaddr *)&clientAddr, &clientLen);
        sbufInsert(&sbuf, connectedFd);
    }
}


















