//
//  ObjectiveC_Memory.m
//  ObjcSum
//
//  Created by sihuan on 16/1/4.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "ObjectiveC_Memory.h"
#import <objc/runtime.h>

@interface ObjectiveC_Memory ()

@property (nonatomic, strong) NSString *myStr;

@end

@implementation ObjectiveC_Memory

#pragma mark - 第 29 条:理解引用计数

/**
 *  Objective-C使用引用计数来管理内存，即每个对象都有个可以增减的计数器，增加计数表示想让对象继续存活；用完该对象后，应该递减计数；当计数等于0时，就销毁对象。
 
 NSObject 协议声明了下面3哥方法用于操作计数器:
 
 - retain 递增
 - release 递减
 - autorelease 待稍后清理"自动释放池（autorelease pool）时"，再递减保留计数。
 */

#pragma mark - 自动释放池

- (NSString *)stringValue {
    NSString *str = [[NSString alloc] initWithFormat:@"%@", @"333"];
    
    /**
     *  如果直接返回str，那么它的引用计数会比期望指+1
     因为调用了alloc，又没有与之对应的释放。
     意味着，调用者要负责处理这多出来的一次操作
     但是又不能在方法内释放str，否则str会被回收。。。
     */
    return str;
    
    /**
     *  所以应该返回[str autorelease]，
     这样使用者就不必做额外操作了
     */
//    return [str autorelease];
}

#pragma mark - 用ARC简化引用计数

/**
 *  引用计数仍然执行，只是保留和释放操作由ARC自动添加
 */
- (void)userARC {
    NSString *str = [[NSString alloc] initWithFormat:@"%@", @"333"];
    NSLog(@"%@",str);
    
    /**
     *  这样会有内存泄露,必须加上[str release];
     但是如果使用了ARC，那么就会自动加上这句
     */
    //[str release]; //add by ARC
}

#pragma mark - 使用ARC必须要遵循的命名规则

/**
 *  将内存管理在方法名中表现出来是Objective-C的惯例，ARC则确立为硬性规定。
 
 如果以下面词语开头，则表示返回对象归调用者所有(调用者要负责释放对象)：
 
 - alloc
 - new
 - copy
 - mutableCopy
 
 如果不是以上面4个开头，表示返回的对象会自动释放。调用者根据需要处理。
 */

- (void)doSomething {
    NSString *str1 = [self newString];
    NSString *str2 = [self someString];
    
    if (str1 && str2) {
        
    }
    /**
     *  规矩命名规范，就知道这里应该释放str1
     而str2不用做处理
     */
//    [str1 release];
}

- (NSString *)newString {
    return [[NSString alloc] initWithFormat:@"%@", @"newString"];
}

- (NSString *)someString {
    NSString *str = [[NSString alloc] initWithFormat:@"%@", @"someString"];
//    return [str autorelease];
    return str;
}

#pragma mark - ARC包含运行期组件来优化程序

- (void)optimize {
    //@property (nonatomic, strong) NSString *myStr;
    NSString *tmp = [self someString2];
    _myStr = tmp;//其实是_myStr = [tmp retain];
    /**
     *  优化成_myStr = objc_retainAutoreleasedReturnValue(tmp);
     */
    
    /**
     *  这里someString2中的autorelease和[tmp retain]都是多余的，
     可以删掉，但是ARC需要考虑向后兼容性（backward compatibility），
     来兼容没有使用ARC的代码。不能删掉
     
     但是，ARC可以在运行期检测到这一对多余的操作（autorealease 及紧跟其后的retain），并且在返回对象时候，不直接调用autorelease，而是调用特殊函数objc_autoreleaseReturnValue，
     */
    
    /**
     *  特殊函数objc_autoreleaseReturnValue和objc_retainAutoreleasedReturnValue使用全局数据结构（具体内容因处理器而异，编译器来优化）标志位处理，而不执行autorelease等，效率更高
     */
    
    //将内存管理交给编译器和运行时组件来做，可以使代码得到多种优化，上面只是一种。由此可以了解使用ARC的好处。
}

- (NSString *)someString2 {
    NSString *str = [[NSString alloc] initWithFormat:@"%@", @"someString"];
    /**
     *  return [str autorelease];
     调用下面这个
     *  return objc_autoreleaseReturnValue(str);
     */
    return str;
}

/**
 *  凡是具备强引用的变量，都必须释放。
 ARC会在dealloc方法中自动插入下面类似代码，而无需手动添加。
 
 ARC会借用Objective-C++的特性来生成清理例程（cleanup routine），
 不过如果有非Objective-C对象，比如CoreFoundation对象或malloc分配的内存，需要手动添加释放.
 */
- (void)dealloc {
//    [_myStr release];
//    [super dealloc];
    /**
     CFRelease(_xxx);//CoreFoundation
     
     free(xxx);//malloc
     */
}

#pragma mark - 编写异常安全代码时，留意内存管理问题

/**
 *  发生异常时，应该如何管理内存？
 在@try中，如果保留了某个对象，然后在释放它之前又抛出了异常，
 那么除非catch或finally能处理该问题，否则就会发生内存泄漏
 */
- (void)exception {
    
    NSString *str;
    @try {
       str = [[NSString alloc] initWithFormat:@"%@", @"exception"];
        //假如这里抛出了异常,
        [str pathExtension];
        
        /**
         *  ARC模式下，会造成str对象内存泄露，因为ARC默认不会自动处理，
         因为这样做需要加入大量样板代码，来跟踪待清理的对象，
         而这些代码会严重影响运行时性能，即使不抛异常。副作用较大。
         
         除非使用-fobjc-arc-exceptions这个编译器标志来开启该功能。
         所以建议使用NSError
         */
        
        /**
         *  MRC模式下，在这里释放的话仍然会造成str对象内存泄露
         因为异常会让执行过程终止并跳到catch块，后面代码不会执行
         */
//        [str release];
    }
    @catch (NSException *exception) {
    }
    @finally {
        /**
         *  MRC模式下，可以通过在@finally中手动释放来防止内存泄露
         */
//        [str release];
    }
}

#pragma mark - 第 34 条:用"autorelease pool"降低内存峰值

/**
 *  autorelease pool用于存放那些需要在稍后释放的对象。
 清空（drain）自动释放池时，系统会向其中的对象发送release消息。
 
 在OX X和iOS中，主线程和Grand Central Dispatch（中央调度，GCD）线程，都会默认创建自动释放池。
 每次执行时间循环（event loop）时，就会将其清空。
 */
- (void)autoreleasepool {
    /**
     *  autoreleasepool排布在栈中，对象收到autorelease消息后，系统将其放入最顶端的池里
     合理运用autoreleasepool可以降低内存峰值
     */
    @autoreleasepool {
        for (int i = 0; i < 10000; i++) {
            NSString *str = [[NSString alloc] initWithFormat:@"%@", @"exception"];
            NSLog(@"%@", str);
            
            //通过autoreleasepool，可以及时释放for循环中分配的10000个NSString内存
            @autoreleasepool {
                for (int j = 0; j < 10000; j++) {
                    NSString *str2 = [[NSString alloc] initWithFormat:@"%@", @"exception"];
                    NSLog(@"%@", str2);
                }
            }
        }
        
    }
}

#pragma mark - 第 35 条:用"僵尸对象"调试内存管理问题

/**
 *  默认该选项是关闭的，开启方式：
 
	编辑Scheme->Run->Diagnostics->勾选Enable Zombie Objects
 
 - 系统在回收对象时，可以不将其真的回收，而是把它转化成僵尸对象。通过环境变量NSZombieEnabled可开启此功能
 - 系统会修改对象的isa指针，令它指向特殊的僵尸类，让对象变成僵尸对象。僵尸对象能够响应所有的selector，响应方式：打印一条包含消息内容及其接受者的消息，然后终止程序。
 */

#pragma mark - 第 36 条:不要使用retainCount

- (void)retainCountDemo {
    
    NSString *str = @"some";
    NSNumber *num1 = @1;
    NSNumber *numf = @3.111;
    
    /**
     *OS X 10.8.2, Clang 4.1编译如下
     str retainCount = 2^64 - 1,
     num1 retainCount = 2^63 - 1,
     numf retainCount = 1
     */
    
    /**
     *  因为系统尽可能把NSString实现成单例对象。
     如果是编译期常量，那么编译器会把NSString对象所表示的数据放到应用二进制文件里，
     这样，运行时系统就可以直接使用，无需再创建NSString对象。
     
     NSNumber也类似，它使用"标签指针"（tagged pointer）来标注特定类型的数值。
     而不创建NSNumber对象。这种优化只在某些场合使用，上面浮点数就没有优化。
     */
    
    
    if (str || num1 || numf) {
    }
}











@end







