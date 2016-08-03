//
//  SummaryThread.c
//  MySumC
//
//  Created by sihuan on 15/4/9.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#include "SummaryThread.h"
#include "YYDefine.h"
#include "YYThreadPool.h"

//线程例程
void *thread(void *vargp) /* thread routine */  //line:conc:hello:beginthread
{
    //获取自己的tid
    pthread_t tid = pthread_self();
    
    printf("Hello, world!\n");
    return NULL;
    
    #pragma mark //例程返回时，线程隐式终止
    
    //显式终止，如果主线程调用pthread_exit，它会等待所有其他对等线程终止，再终止主线程和进程。
    pthread_exit(Null);
    
    //通过pthread_cancel终止另一个对等线程。
    pthread_cancel(tid);
}

void initRoutine() {
    
}

//第一个线程化程序
void demo1() {
    pthread_t tid;
    pthread_create(&tid, NULL, thread, Null);
    
    #pragma mark //分离线程
    /**
     *  线程是可结合的（joinable）或者是分离的（detached）
     
     可结合的线程能被其他线程回收和杀死，在被其他线程回收前，它的存储器资源是没有释放的。
     相反，分离的线程不能被其他线程回收和杀死，它的存储器资源在终止时系统自动释放。
     
     默认情况，新创建的线程是可结合的
     */
   
    pthread_detach(tid);
    
    //等待其他线程终止，会阻塞，直到tid终止，回收线程的所有资源
    pthread_join(tid, Null);
    
    
    #pragma mark //当需要初始化多个线程共享的全局变量时，pthread_once很有用
    //onceControl是一个全局或静态变量，
    static pthread_once_t onceControl = PTHREAD_ONCE_INIT;
    pthread_once(&onceControl, initRoutine);
    
    exit(0);
    
}


#pragma mark - 基于线程的并发服务器

/* thread routine */
void *doTask1(void *vargp)
{
    int connfd = *((int *)vargp);
    pthread_detach(pthread_self());
    echo1(connfd);
    close(connfd);
    return NULL;
}

void *doTask2(void *vargp)
{
    int connfd = *((int *)vargp);
    free(vargp);//释放掉
    pthread_detach(pthread_self());
    echo1(connfd);
    close(connfd);
    return NULL;
}

void echoServer1(int port) {
    int listenFd, connectedFd;
    socklen_t clientLen = sizeof(struct sockaddr_in);
    struct sockaddr_in clientAddr;
    
    listenFd = openListenFd(port);
    
    pthread_t tid;
    
    int *connfdPtr;
    while (1) {
        #pragma mark 竞争问题版（race）
        
        /**这里的connectedFd = accept(listenFd, (struct sockaddr *)&clientAddr, &clientLen);
         和 线程 doTask1 里的int connfd = *((int *)vargp); 产生了竞争
         如果 在下一个 accept之前 connfd得到了值，那么获得正确的值，否则 connfd是下一次的connectedFd了
         *
         */
        connectedFd = accept(listenFd, (struct sockaddr *)&clientAddr, &clientLen);
        pthread_create(&tid, NULL, doTask1, &connectedFd);
        
        #pragma mark 解决办法
        
        //每个connectedFd使用一个单独的内存
        connfdPtr = malloc(sizeof(int));
        *connfdPtr = accept(listenFd, (struct sockaddr *)&clientAddr, &clientLen);
        pthread_create(&tid, NULL, doTask2, connfdPtr);
    }
}


#pragma mark - 共享变量

/**
 *  一个变量是共享的，当且仅当它的一个实例被多个线程引用
 
 会引起同步错误（synchronization error）的可能性
 */
char **ptr;  /* global variable */
#define N 2

void *share(void *vargp)
{
    int myid = (int)vargp;  //本地自动变量，每个线程自己的
    
    static int cnt = 0; //本地静态变量，和全局变量一样只有一个实例，多个对等线程都读和写这个实例
    
    //对等线程通过全局变量直接访问主线程中栈的内容
    printf("[%d]: %s (cnt=%d)\n", myid, ptr[myid], ++cnt); //line:conc:sharing:stack
    return NULL;
}

void shareVar() {
    int i;
    pthread_t tid;
    char *msgs[N] = {
        "Hello from foo",
        "Hello from bar"
    };
    
    ptr = msgs;
    for (i = 0; i < N; i++)
        pthread_create(&tid, NULL, share, (void *)i);
    
    pthread_exit(NULL);
}


#pragma mark - 同步错误例子

/* Global shared variable */
volatile int counter = 0;

void *addCounter(void *argp) {
    int i, n = *(int *)argp;
    
    /**分析是哪里出错了，可以把下面的循环分解成5部分：
     
     *  H:在循环头部的指令块
     
        L:加载共享变量counter到寄存器%eax的指令
        U:更新（增加）寄存器中%eax的值
        S:将eax的更新值存回到共享变量counter的指令
     
        T:循环尾部的指令块
     
     头和尾只操作本地栈变量，所以不影响，
     而L,U,S操作共享计数器变量的内容，中间和别的线程发生交叉，就会出错
     */
    for (i = 0; i < n; i++) {
        counter++;
    }
    return Null;
}
void synchronizationErrorDemo() {
    int n = 100;
    pthread_t tid1, tid2;
    
    /* Create threads and wait for them to finish */
    pthread_create(&tid1, NULL, addCounter, &n);
    pthread_create(&tid2, NULL, addCounter, &n);
    pthread_join(tid1, NULL);
    pthread_join(tid2, NULL);
    
    if (counter  != 2 * n) {
        printf("BOOM! cnt=%d\n", counter);
    } else
        printf("OK cnt=%d\n", counter);
    
   #pragma mark 运行结果： BOOM! 。。。 而且每次都不一样
}

#pragma mark - 信号量

//信号量（semaphore）s是具有非负整数值的全局变量，只能由P，V操作处理

//P(s): Proberen（测试） 如果s != 0，那么s - 1，并立即返回；如果s == 0，那么就挂起这个线程，直到s非零

//V(s): Verhogen（增加） 将s+1，如果有任何线程阻塞在P操作，那么V操作会任意启动一个线程，让它完成P操作

//P中的测试和减1是不可分割的， V中的加1操作也是不可分割的，所以P和V就确保了一个正在运行的程序绝不会出现信号量s < 0的状态，称为信号量的不变性（semaphore invariant）

/**
 操作信号量的函数
 
 ret：成功0，出错-1
 
 int sem_init(sem_t *sem, 0, unsigned int value);
 int sem_wait(sem_t *sem);
 int sem_post(sem_t *sem);
 
 1）sem_wait() 递减(锁定)由 sem 指向的信号量。如果信号量的值大于零，那么递减被执行，并且函数立即返回。如果信号量的当前值是零，那么调用将阻塞到它可以执行递减操作为止(如信号量的值又增长超过零)，或者调用被信号打断。
 
 （2）sem_trywait() 与 sem_wait() 类似，只是如果递减不能立即执行，调用将返回错误(errno 设置为EAGAIN)而不是阻塞。
 
 （3）sem_timedwait() 与 sem_wait() 类似，只不过 abs_timeout 指定一个阻塞的时间上限，如果调用因不能立即执行递减而要阻塞。abs_timeout 参数指向一个指定绝对超时时刻的结构，这个结果由自 Epoch，1970-01-0100:00:00 +0000(UTC) 秒数和纳秒数构成。
 */

#pragma mark 使用信号量修改上面的同步错误，用作互斥锁

static sem_t mutex;


void *addCounterOk(void *argp) {
    
    //sem_init(&mutex, 0, 1);
    
    int i, n = *(int *)argp;
    
    for (i = 0; i < n; i++) {
        P(&mutex);
        counter++;
        V(&mutex);
    }
    return Null;
}

#pragma mark 使用信号量调度共享资源的访问，生产者-消费者问题

void sbufInit(Sbuf *sp, int n) {
    sp->buf = calloc(n, sizeof(int));
    sp->n = n;                       /* Buffer holds max of n items */
    sp->front = sp->rear = 0;        /* Empty buffer iff front == rear */
    
    sp->mutex = sem_open("mut", O_CREAT, 0644, 1);
    sp->slots = sem_open("slots", O_CREAT, 0644, n);
    sp->items = sem_open("items", O_CREAT, 0644, 1);
    //sem_init(&sp->mutex, 0, 1);      /* Binary semaphore for locking */
    //sem_init(&sp->slots, 0, n);      /* Initially, buf has n empty slots */
    //sem_init(&sp->items, 0, 0);      /* Initially, buf has zero data items */
}
void sbufDinit(Sbuf *sp) {
    free(sp->buf);
    
    sem_unlink("mut");
    sem_unlink("slots");
    sem_unlink("items");
}
void sbufInsert(Sbuf *sp, int item) {
    P(sp->slots);                          /* Wait for available slot */
    P(sp->mutex);                          /* Lock the buffer */
    sp->buf[(++sp->rear)%(sp->n)] = item;   /* Insert the item */
    V(sp->mutex);                          /* Unlock the buffer */
    V(sp->items);                          /* Announce available item */
}
int sbufRemove(Sbuf *sp) {
    int item;
    P(sp->items);                          /* Wait for available item */
    P(sp->mutex);                          /* Lock the buffer */
    item = sp->buf[(++sp->front)%(sp->n)];  /* Remove the item */
    V(sp->mutex);                          /* Unlock the buffer */
    V(sp->slots);                          /* Announce available slot */
    return item;
}


#pragma mark - 使用信号量调度共享资源的访问，读者写着问题

int readerCnt = 0;
sem_t mtx, w; /*Both initially = 1*/

//读者优先的算法
void readerPrior() {
    while (1) {
        P(&mtx);
        readerCnt++;
        if (readerCnt == 1) {   /* first in 只有第一个进入临界区的读者对w加锁*/
            P(&w);
        }
        V(&mtx);
        
        /*
         读临界区
         */
        
        P(&mtx);
        readerCnt--;
        if (readerCnt == 0) { /* last out 最后一个离开临界区的读者对w解锁， 写者每次进入都会对w加锁，这样就保证无论何时最多只有一个写者*/
            V(&w);
        }
        V(&mtx);
    }
}

void writer() {
    while (1) {
        P(&w);  //写者每次进入都会对w加锁
        
        /*
         写临界区
         */
        
        V(&w);
    }
}

int writerCnt = 0;

//写者优先的算法


#pragma mark - 线程池测试
FILE *fp;
void tvsub(struct timeval *out, struct timeval *in)
{
    if ( (out->tv_usec -= in->tv_usec) < 0) {
        --out->tv_sec;
        out->tv_usec += 1000000;
    }
    out->tv_sec -= in->tv_sec;
}

int starttime(struct timeval * ptv_start)
{
    return(gettimeofday(ptv_start, NULL));
}

unsigned long stoptime(struct timeval tv_start)
{
    unsigned long  clockus;
    struct timeval tv_stop;
    if (gettimeofday(&tv_stop, NULL) == -1)
        return 0;
    tvsub(&tv_stop, &tv_start);
    clockus = tv_stop.tv_sec * 1000000 + tv_stop.tv_usec;
    return(clockus); //return unit "us"
}
void test_fun(void *arg)
{
    int i = (int)arg;
    printf("%d\n", i);
    
    return;
}

void threadPoolTest() {
    
    long long int cost = 0;
    struct timeval tv;
    starttime(&tv);
    
    YYThreadPool *pt = yyThreadPoolCreate(2, 4);
    for (int i = 0; i < 1000; i++) {
        yyThreadPoolDispatch(pt, test_fun, (void *)i);
    }
    
    cost = stoptime(tv);
    sleep(4);
    yyThreadPoolDestory(pt, 1);
    printf("%lld\n", cost/1000);
    
}



#pragma mark - 线程安全

#pragma mark 1.不保护共享变量的函数
/**
 *  如上面的例子，
 解决办法：添加类似P，V的操作，程序不需要其他修改，但是同步操作会减慢程序执行时间
 */

#pragma mark 2.保持跨越多个调用状态的函数。
/**
 *  如下面的rand()函数
 解决办法：只能重写。。让它不依赖static数据
 */

unsigned int next = 1;
int rand() {
    next = next *12345 + 6543;
    return (unsigned int)(next/64432)%3232;
}

void srand(unsigned int seed) {
    next = seed;
}

#pragma mark 3.返回指向静态变量的指针的函数
/**
 *  比如ctime和gethostbyname,将计算结果放在一个static变量中，再返回指针。
 解决办法：创建一个新的函数，加锁，拷贝，如下：
 */
char *ctime_s(const time_t *timep, char *privatep) {
    char *sharedp;
    
    P(&mutex);
    sharedp = ctime(timep);
    strcpy(privatep, sharedp);
    V(&mutex);
    return privatep;
}

#pragma mark 4.调用线程不安全函数的函数。
/**
 *  这个就看情况了。。。
 */


#pragma mark - 可重入函数
/**
 *  一类重要的线程安全函数，叫做可重入函数（reentrant function）：
 
 当它被多个线程调用时，不会引起任何共享数据。
 
 分为2种情况
 
 1.显式可重入的（explicitly reentrant）
 所有参数都是值传递，并且所有数据都是引用本地自动变量。
 无论如何调用，都是可重入的
 
 2.隐式可重入的（implicitly reentrant）
 一些参数是引用传递的（指针），比如rand_r（）函数
 这种情况下如果线程小心的传递指向非共享数据的指针，那么它是可重入的
 
 如下将上面第二类函数重写，
 */
int rand_r(unsigned int *nextp) {
    *nextp = *nextp * 1263632 + 12244;
    return (unsigned int)(*nextp / 6323)%3212;
}

#pragma mark 所以要认识到，可重入性有时既是调用者也是被调用者的属性，并不只是被调用者单独的属性。









