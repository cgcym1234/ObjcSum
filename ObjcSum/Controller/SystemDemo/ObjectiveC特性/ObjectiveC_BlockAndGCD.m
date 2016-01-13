//
//  ObjectiveC_BlockAndGCD.m
//  ObjcSum
//
//  Created by sihuan on 16/1/6.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "ObjectiveC_BlockAndGCD.h"
#import <UIKit/UIKit.h>


@implementation ObjectiveC_BlockAndGCD

/**
 *  苹果用全新的方式设计了多线程，当前多线程编程的核心就是block和GCD。
 
 - block是一种可在C，C++，OC中使用的"词法闭包"(lexical closure)，使用block，可以将代码像对象一样传递，并在不同的context下运行。在block中，它可以访问其中所有变量。
 
 - GCD是一种与block相关的技术，基于"派发队列"（dispatch queue）提供了对线程的抽象。将block放入队列中，由GCD负责处理所有调度。
	- GCD会根据系统资源情况，适时的创建，复用，销毁后台线程，来处理每个队列。
	- GCD还可以很方便的完成常见编程任务，比如"只执行一次的线程安全代码"，或者根据可用系统资源来并发执行多个操作。
 */


#pragma mark - ### 第 37 条:理解block

/**
block可以实现闭包。这个特性是作为"扩展"（extension）加入GCC的。
*/

#pragma mark #### block基础知识

- (void)block {
    /**
     block与函数类似，但它是直接定义在另一个函数里，并和那个函数共享同一个范围内的东西。语法如下：
     *  return_type (^block_name)(parameters)
     */
    id b = ^{
    
    };
    //block其实就是个值，而且有相关类型。与int float或OC对象一样，可以赋给变量。语法和函数指针类似。
    
    //定义一个名为someBlock的变量。
    void (^someBlock)() = ^{
        /**
         *  block强大之处在于：在声明它的范围里，所有变量都可以被捕获。
         捕获的变量默认不能修改，除非加上__block关键字。
         */
    };
    
    if (b || someBlock) {
    }
    
    /**
     *  内联block（inline block）
     传给enumerateObjectsUsingBlock方法的block并未先赋值给局部变量，
     直接内联在函数调用里了。
     */
    NSArray *array = @[@0,@1,@2,@3,@4];
    __block NSInteger count = 0;
    [array enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj compare:@2] == NSOrderedAscending) {
            count++;
        }
    }];
    
    /**
     *  如果block捕获的变量是对象，那么会自动保留它。
     系统在释放这个block的时候，将对象一起释放。
     
     block本身是对象，有引用计数。
     需要注意如果如果block捕获了self，self指向的对象也保留了该block的话，
     会造成循环引用问题
     */
    
}

#pragma mark - Block内部结构

/**
 *  block本身是对象，在存放block对象的内存区域中，
 首个变量是指向Class对象的指针，isa。其他是所需的各种信息，如下：
 */


@end

struct Descriptor {
    unsigned long int reserved;
    unsigned long int size;
    void (*copy)(void *, void*);
    void (*dispose)(void *, void*);
};

struct Block {
    void *isa;
    int flags;
    int reserved;
    
    //invoke指向block实现代码的函数指针，第一个参数void *代表block对象
    void (*invoke)(void *, ...);
    
    /**
     *  descriptor声明了block的总体大小，
     copy和dispose在拷贝和丢弃block对象时运行，
     copy要保留捕获的对象，而dispose则将之释放
     */
    struct Descriptor *descriptor;
    /**
     *  后面的区域存放捕获到的变量
     block会把它所捕获的所有变量的指针拷贝一份。
     有多少变量就要占据多少内存。
     
     invoke需要把block对象作为参数传人的原因就在于，
     执行block时，要从内存中把这些捕获到的变量读出来
     */
};

#pragma mark - 全局block，栈block，堆block

/**
 *  block定义的时候，所占的内存是分配在栈中的。
 block只在它的那个范围内有效
 */
void blockMemory() {
    
    void (^stackBlock)();
    int a;
    
    /**
     *  下面的写法有危险，运行可能正确，也可能错误
     */
    if (a) {
        /**
         *  注意，这样是不安全的
         赋值给stackBlock的block是分配在栈内存中的，
         当它离开作用范围（这里是if{}）后，编译器可能把这块内存覆写掉
         */
        stackBlock = ^{
            NSLog(@"block A");
        };
    } else {
        /**
         *  应该这样写，发送copy消息后，把block从栈复制到堆了。
         就和标准的OC对象一样，有引用计数了
         */
        stackBlock = [^{
            NSLog(@"block B");
        } copy];
    }
    stackBlock();
}

/**
 *  还有一种全局block（global block）
 它不会捕捉任何状态（比如外围的变量等），运行时也无须有状态来参与。
 block所使用的整个内存区域，在编译期就已经完全确定了，因此可以声明在全局内存里。
 
 全局block的copy是个空操作，因为它不可能被系统回收，相当于单例
 */
#pragma mark 全局block

void (^gloadBlock)() = ^{
    NSLog(@"gloadBlock");
};


#pragma mark - ### 第 38 条:为常用的block类型创建typedef

typedef int (^SomeBlock)(int value);

void blockType() {
    //如下，不仅便于阅读，而且后面修改也方便
    
    SomeBlock block = ^(int value) {
        return value;
    };
    if (block) {
    }
}

/**
 *  对同一个类型block定义多个别名
 *  便于阅读和调整
 */
typedef int (^ViewDidClickBlock)(int value);
typedef int (^ViewLongPressedBlock)(int value);


#pragma mark - 39 用handler block降低代码分散程度

//成功和失败分开
typedef int (^NetworkFetcherSucessBlock)(id jsonDict);
typedef int (^NetworkFetcherFailureBlock)(NSError *error);

//成功和失败合在一起
typedef int (^NetworkFetcherCompletionBlock)(id jsonDict, NSError *error);

@interface NetworkFetcher :UIView

+ (void)startFetchSucess:(NetworkFetcherSucessBlock)success
                 failure:(NetworkFetcherFailureBlock)failure;

/**
 *  2中都不错，总体来说建议使用合在一起的。
 */
+ (void)startFetchCompletion:(NetworkFetcherCompletionBlock)completion;

@end


@interface NetworkFetcher () {
    NSString *_someString;
}

//串行队列
@property (nonatomic, strong) dispatch_queue_t syncQueue;
@end
@implementation NetworkFetcher

#pragma mark - 第 41 条:多用派发队列，少用同步锁

+(void)startFetchSucess:(NetworkFetcherSucessBlock)success failure:(NetworkFetcherFailureBlock)failure {
    
}
+ (void)startFetchCompletion:(NetworkFetcherCompletionBlock)completion {
    
}

/**
 *  多线程同步使用锁时，在CGD之前，有2种办法
 1.同步块（synchronization block）
 2.使用NSRecursiveLock（递归锁）
 */
- (void)synchronizedMethod {
    /**
     *  根据给定的对象，自动创建一个锁，里面代码执行完后，释放锁
     这2种方式，效率不是很高，同步块极端情况下可能导致死锁。
     */
    @synchronized(self) {
        //safe
    }
    
    /**
     *  GCD替代方案，使用串行同步队列
     */
    _syncQueue = dispatch_queue_create("ccc", DISPATCH_QUEUE_SERIAL);
}

#pragma mark GCD多线程同步方案一
/**
 *  将读和设置操作都放到一个串行队列里，
 这样所有加锁的任务都在GCD中处理，而GCD比较底层，能做很多优化。
 */
- (NSString *)someString {
    __block NSString *localSomeString;
    dispatch_sync(_syncQueue, ^{
        localSomeString = _someString;
    });
    return localSomeString;
}

- (void)setSomeString:(NSString *)someString {
    dispatch_sync(_syncQueue, ^{
        _someString = someString;
    });
    
    /**
     *  这里的设置操作还可以用异步方式
     但这样写，可能比上面还要慢，因为执行异步派发时，需要拷贝block，
     如果拷贝block的时间超过执行时间，就可能变慢，所有看情况使用。
     */
    dispatch_async(_syncQueue, ^{
        _someString = someString;
    });
}

#pragma mark  GCD多线程同步方案二
/**
 *  其实上面是这样多个获取方法可以并发执行，而获取和设置方法不能并发。
 利用这个特点，还可以写出更快的一些代码。如下，使用并发队列（concurrent queue）
 和栅栏（barrier）
 */

- (NSString *)someString2 {
    _syncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block NSString *localSomeString;
    dispatch_sync(_syncQueue, ^{
        localSomeString = _someString;
    });
    return localSomeString;
}

- (void)setSomeString2:(NSString *)someString {
    /**
     *  在队列中，barrier block必须单独执行，不能和其他block并行，只对并发队列有意义。
     *  并发队列如果发现接下来要处理的是barrier block，就会一直等到当前所有并发block都执行完毕，
     才会单独执行这个barrier block。 barrier block执行完后，再按正常方式继续向下处理。
     */
    dispatch_barrier_async(_syncQueue, ^{
        _someString = someString;
    });
    //这样处理肯定比上面用同步队列方式快
    
    /**
     *  另外设置函数也可以用同步的barrier block，避免拷贝block
     */
    dispatch_barrier_sync(_syncQueue, ^{
        _someString = someString;
    });
}

#pragma mark - 第 42 条:多用GCD，少用performSelector系列方法

- (void)foo {
    
}

- (void)foo1 {
    
}
- (void)performSelectorDemo {
    int a;
    SEL selector;
    if (a) {
        selector = @selector(foo);
    } else {
        selector = @selector(foo1);
    }
    
    /**
     编译器不知道要运行的selector是什么，要运行时才能确定。可以很灵活的使用。
     这样做的代价是，ARC下会有如下警告：
     * PerformSelector may cause a leak because its selector is unknown
     可能会有内存泄露。。
     */
    [self performSelector:selector];
    /**
     *  原因是编译器不知道selector是什么，以及它的方法签名和返回值。
     所以没办法使用ARC的内存管理规则来判断返回值是否应该释放。
     所以ARC使用了比较谨慎的做法，不对返回值添加释放操作
     
     所以如果selector返回的是新创建的对象，就会造成内存泄露，连static analyzer 都很难检测到
     */
    
    #pragma mark performSelector延时调用导致的内存泄露的案例
    /**
     *  performSelector 的另一个可能造成内存泄露的地方在编译器对方法中传入的对象进行保留。
     performSelector关于内存管理的执行原理是这样的执行
     [self performSelector:@selector(method1:) withObject:self.tableLayer afterDelay:3]; 的时候，
     系统会将tableLayer的引用计数加1，执行完这个方法时，将tableLayer的引用计数减1，
     而在我的游戏里这个延时执行函数是被多次调用的，有时切换场景时延时函数已经被调用但还没有执行，
     这时tableLayer的引用计数没有减少到0，也就导致了切换场景dealloc方法没有被调用，出现了内存泄露。
     */
    
    #pragma mark - GCD替代 performSelector
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self foo];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self foo];
    });
}

#pragma mark - 使用performSelector延时调用实现长按钮的实现思路
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //在touchBegan里面
    [self performSelector:@selector(longPressMethod:) withObject:nil afterDelay:2];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //然后在end 或cancel里做判断，如果时间不够长按的时间调用：
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(longPressMethod:) object:nil];
}

- (void)longPressMethod:(id)obj {
}


#pragma mark - 第 43 条:掌握GCD及操作队列的使用时机

/**
 *  在执行后台任务时，GCD并不一定是最佳方式。另外一种NSOperationQueue
 GCD是纯C的API，而NSOperationQueue是OC对象。
 
 其实在iOS4和OXX 10.6后，NSOperationQueue底层使用GCD实现的
 */

/**
 *  NSOperationQueue能实现GCD的绝大部分功能，以及一些更复杂的操作，使用 NSOperationQueue的好处：
 
 - 方便的取消某个操作。在NSOperation对象上调用cancel方法，会设置对象内的标志位，表示此任务不需要执行，不过已经启动的任务无法取消。如果是把block放到GCD中，是无法取消的。它是（fire and forget）的。
 - 指定操作间的依赖关系。一个操作可以依赖其他多个操作。
 - 通过KVO监控NSOperation对象的属性。比如isCancelled判断是否取消，isFinished，是否完成等。
 - 指定操作的优先级。可以指定线程优先级和任务优先级，而GCD只有队列的优先级，不能单独设置某个block任务的优先级。
 - 复用NSOperation对象
 */

#pragma mark - 第 44 条:通过Dispatch Group根据系统资源情况来执行任务

/**
 *  dispatch group是GCD的一项特性，能把任务分组。
 其中最重要的用法是，把要并发执行的多个任务合为一组，调用者就知道这些任务何时才能全部执行完。
 */

- (void)dispatchGroupDemo {
    dispatch_group_t downloadGroup = dispatch_group_create();
    
    #pragma mark 2种使用方式。
    
    //第一种
    dispatch_group_async(downloadGroup, dispatch_get_main_queue(), ^{
    });
    
    //第二种，必须成对出现，如果enter后没有leave，那这一组任务永远无法完成。
    dispatch_group_enter(downloadGroup);
    dispatch_group_leave(downloadGroup);
    
    //用法demo，有3个下载任务
    NSArray *urlStrs = @[@"http1",@"http2",@"http3"];
    NSURLSession *sesstion = [NSURLSession sharedSession];
    
    //dispatch_group_async方式
    [urlStrs enumerateObjectsUsingBlock:^(NSString *urlstr, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //可以放到不同队列中
        dispatch_queue_t queue = urlstr ? dispatch_get_main_queue() : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_group_async(downloadGroup, queue, ^{
            NSURLSessionDataTask *task = [sesstion dataTaskWithURL:[NSURL URLWithString:urlstr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
            }];
            [task resume];
        });
    }];

    //dispatch_group_enter方式
    [urlStrs enumerateObjectsUsingBlock:^(NSString *urlstr, NSUInteger idx, BOOL * _Nonnull stop) {
        //加入分组
        dispatch_group_enter(downloadGroup);
        
        NSURLSessionDataTask *task = [sesstion dataTaskWithURL:[NSURL URLWithString:urlstr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            //任务完成，离开
            dispatch_group_leave(downloadGroup);
        }];
        [task resume];
    }];
    
    #pragma mark 2种方式知道分组任务完成
    
    /**
     *  第一种，阻塞方式，这里设置最多等待10秒，
     *  任务完成，或者等待超过了10秒，继续执行下面代码
     */
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 10*NSEC_PER_SEC);
    dispatch_group_wait(downloadGroup, timeout);
    
    /**
     *  第二种，异步通知方式
     分组中的任务完成后在指定线程中执行block
     */
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
        //上面3个下载任务完成后的回调
    });
    
    
    
    #pragma mark - 串行队列实现类似dispatch_group_notify功能
    
    dispatch_queue_t serialQueue = dispatch_queue_create("dd", DISPATCH_QUEUE_SERIAL);
    
    [urlStrs enumerateObjectsUsingBlock:^(NSString *urlstr, NSUInteger idx, BOOL * _Nonnull stop) {
            //异步方式放入串行队列中
            dispatch_async(serialQueue, ^{
                NSURLSessionDataTask *task = [sesstion dataTaskWithURL:[NSURL URLWithString:urlstr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                }];
                [task resume];
            });
    }];
    
    //类似dispatch_group_notify
    dispatch_async(serialQueue, ^{
        //上面任务执行完后的异步通知.
    });
    
    //类似dispatch_group_wait
    dispatch_sync(serialQueue, ^{
        //阻塞一直到上面任务执行完后
    });
    
    #pragma mark - dispatch_apply
    
    /**
     *  上面遍历数组执行任务，还可以用dispatch_apply方式
     不过dispatch_apply会持续阻塞，直到所有任务都执行完为止
     */
    dispatch_apply(urlStrs.count, dispatch_get_main_queue(), ^(size_t i) {
        NSURLSessionDataTask *task = [sesstion dataTaskWithURL:[NSURL URLWithString:urlStrs[i]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        }];
        [task resume];
    });
    
    
    
    #pragma mark - dispatch_sync死锁
    
    dispatch_sync(serialQueue, ^(){
        dispatch_sync(serialQueue, ^(){
            [self foo];
        });
    });
}

#pragma mark - 第 45 条:使用dispatch_once来执行只需运行一次的线程安全代码

/**
 *  dispatch_once用于实现单例模式（singleton）
 *使用dispatch_once可以简化代码并彻底保证线程安全，
 无需担心加锁或同步问题。只要调用时使用相同的标记dispatch_once_t即可。
 
 速度几乎是使用@synchronized的2倍
 */
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 第 45 条:不要使用dispatch_get_current_queue

/**
 *  dispatch_get_current_queue用于判断当前代码在哪个队列上执行。
 iOS在6.0后就弃用了，只应做调试使用。
 */


- (NSString *)getString {
    __block NSString *localString;
    
    #pragma mark 死锁问题
    /**
     *  这种写法有个问题，可能会导致死锁，如下：
     dispatch_sync(_syncQueue, ^{
        [self getString];
     });
     这种方法是不可重入的。
     */
    dispatch_sync(_syncQueue, ^{
        localString = _someString;
    });
    
    #pragma mark 改进版
    
    dispatch_block_t accessorBlock = ^{
        localString = _someString;
    };
    
    /**
     *  使用dispatch_get_current_queue判断,
     */
    if (dispatch_get_current_queue() == _syncQueue) {
        accessorBlock();
    } else {
        dispatch_sync(_syncQueue, accessorBlock);
    }
    
    /**
     *  不过这种写法仍然可能有问题。因为可能出现如下情况
     dispatch_queue_t queueA = dispatch_queue_create("queueA", NULL);
     dispatch_queue_t queueB = dispatch_queue_create("queueB", NULL);
     
     dispatch_sync(queueA, ^{
         dispatch_async(queueB, ^{
             dispatch_sync(queueA, ^{
                //Deadlock 死锁
             });
         });
     });
     */
    
    #pragma mark 队列之间的层级体系
    
    /**
     使用队列需要注意一个问题：队列之间会形成一套层级体系。
     层级里地位最高的那个总是全局并发队列（global concurrent queue）如下：
     
                全局并发队列
                /       \
            串行队列A   串行队列D
            /     \
        串行队列B  串行队列C
     
     B或C中的block，稍后会在A里依次执行，于是A，B，C中的block总是错开执行的。
     而在D中block，则可能和A里的block（包括B，C的block）并行执行。
     因为A和D的目标队列是一个并发队列。并发队列可能会用多个线程并行执行多个block。
     
     正因为队列间有层级关系，所以无法单用某个队列对象来描述"当前队列"这个概念
     上面用dispatch_get_current_queue检查当前队列来做安全判断操作，并不总是有效。
     
     解决这种问题的最好办法是使用GCD提供的设定"队列特有数据"（queue-specific data），
     查找时，会沿着队列层级体系向上查找，直至找到数据或到达根队列为止
     */
    
    //queueA的目标队列是默认优先级的全局并发队列。
    dispatch_queue_t queueA = dispatch_queue_create("com.queueA", NULL);
    dispatch_queue_t queueB = dispatch_queue_create("com.queueB", NULL);
    
    //queueB的目标队列为queueA
    dispatch_set_target_queue(queueB, queueA);
    
    static int kQueueSpecific;
    CFStringRef queueSpecificValue = CFSTR("queueA");
    
    /**
     *  使用dispatch_queue_set_specific在队列queueA上设置一个"队列特定值"
     *参数是key，value和value的析构函数。
     但是vuale在函数原型里叫做"context"，是void *,所以很难用OC对象作为值。
     这里使用CoreFoundation对象，ARC不会自动管理它的内存，非常适合。
     */
    dispatch_queue_set_specific(queueA, &kQueueSpecific, (void*)queueSpecificValue, (dispatch_function_t)CFRelease);
    dispatch_sync(queueB, ^{
        dispatch_block_t block = ^{ NSLog(@"No deadlock!"); };
        
        /**
         *  同使用dispatch_get_current_queue判断是一个思路，但是却可以避免上面可能遇到的陷阱
         dispatch_get_specific会沿着队列层级体系向上查找，直至找到数据或到达根队列为止。
         *
         */
        CFStringRef retrievedValue = dispatch_get_specific(&kQueueSpecific);
        if (retrievedValue) {
            block();
        } else {
            dispatch_sync(queueA, block);
        }
    });
    
    return localString;
}

@end



























