//
//  ObjectiveC_SystemFramework.m
//  ObjcSum
//
//  Created by sihuan on 16/1/11.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "ObjectiveC_SystemFramework.h"
#import <CoreFoundation/CoreFoundation.h>
#import "ObjectiveC_Memory.h"


@implementation ObjectiveC_SystemFramework

#pragma mark - 第 48 条:多用枚举block，少用for循环

- (void)enumerate {
    NSArray *arr = @[@"aaa", @"bbb"];
    
    /**
     *  NSEnumerationConcurrent通过GCD来并发执行遍历操作，NSEnumerationReverse来反向遍历
     */
    [arr enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
}

#pragma mark - 第 49 条:对自定义内存管理的collection使用无缝桥接

- (void)bridge {
    
    #pragma mark 使用无缝桥接技术，实现Foundation对象和CoreFoundation中的C数据结构相互转换
    NSArray *arr = @[@"aaa", @"bbb"];
    
    /**
     *  使用__bridge实现无缝桥接
     *  __bridge本身的意思是：ARC任具有这个OC对象的所有权（自动管理内存）
     */
    CFArrayRef cfArr = (__bridge CFArrayRef)arr;
    NSLog(@"%li", CFArrayGetCount(cfArr));
    
    /**
     *  __bridge_transfer:把CoreFoundation中的数据结构转换成Foundation对象
     */
    NSArray *arr2 = (__bridge_transfer NSArray *)(cfArr);
    NSLog(@"%li", arr2.count);
    /**
     *  __bridge retained则相反，表示ARC将交出对象的所有权
     *  用完后需要手动调用CFRelease释放数组。
     */
    CFArrayRef cfArr2 = (__bridge_retained CFArrayRef)arr;
    NSLog(@"%li", CFArrayGetCount(cfArr2));
    CFRelease(cfArr2);
}

#pragma mark 使用Foundation字典的一个局限性

/**
 *  NSDictionary对key的内存管理行为是copy，而对value是retain
 *  这是无法改变的，除非使用CFDictionaryRef
 如果传入的key不支持copy操作，会导致崩溃
 [xxx copyWithZone:] unrecognized selector send to instance xxx;
 */

const void* YYRetainCallback(CFAllocatorRef allocator, const void *value) {
    return CFRetain(value);
}

void YYReleaseCallback(CFAllocatorRef allocator, const void *value) {
    CFRelease(value);
}

- (void)CFMutableDictionary {
    /**
     *  
     typedef struct {
         CFIndex				version;
         CFDictionaryRetainCallBack		retain;
         CFDictionaryReleaseCallBack		release;
         CFDictionaryCopyDescriptionCallBack	copyDescription;
         CFDictionaryEqualCallBack		equal;
         CFDictionaryHashCallBack		hash;
     } CFDictionaryKeyCallBacks;
     */
    
    /**
     *  copyDescription默认的实现就很好了
     CFEqual和CFHash与NSMutableDictionary的默认实现相同,
     CFEqual最终会调用NSObject的isEqual
     CFHash最终调用hash方法。
     
     retain和release使用自定义的函数，
     
     */
    CFDictionaryKeyCallBacks keyCallbacks = {
        0,
        YYRetainCallback,
        YYReleaseCallback,
        NULL,
        CFEqual,
        CFHash
    };
    
    /**
     *  
     typedef struct {
     CFIndex				version;
     CFDictionaryRetainCallBack		retain;
     CFDictionaryReleaseCallBack		release;
     CFDictionaryCopyDescriptionCallBack	copyDescription;
     CFDictionaryEqualCallBack		equal;
     } CFDictionaryValueCallBacks;
     */
    CFDictionaryValueCallBacks valueCallbacks = {
        0,
        YYRetainCallback,
        YYReleaseCallback,
        NULL,
        CFEqual,
    };
    
    
    /**
     *  创建CFMutableDictionaryRef字典
     *
     *  @param allocator#>      内存分配器，负责分配和回收内存，通常传NULL，使用默认分配器
     *  @param capacity#>       字典初始大小
     *  @param keyCallBacks#>   key遇到各种事件应该执行何种操作
     *  @param valueCallBacks#> value遇到各种事件应该执行何种操作
     *
     */
    CFMutableDictionaryRef cfDict = CFDictionaryCreateMutable(NULL, 0, &keyCallbacks, &valueCallbacks);
    //再转换成NSMutableDictionary，即可完成自定制操作。
    NSMutableDictionary *nsDict = (__bridge_transfer NSMutableDictionary *)cfDict;
    if (nsDict) {
    }

}

#pragma mark - 第 50 条:构建缓存时用NSCache而非NSDictionary

/**
 *  NSCache特点：
 
 - 当系统资源要耗尽时，可以自动删减缓存。而且使用LRU（lease recently used）算法，先删除最久未使用的对象。
 - 对key不是copy，而是retain
 - 线程安全
 - 可以设置上限：包括大小，数量
 - NSPurgeableData和NSCache搭配使用，可以实现自动清楚数据功能：当NSPurgeableData对象所占内存被系统丢弃时，对象本身也会从缓存中移除。
 */
- (void)NSCacheDemo {
    NSCache *cache = [NSCache new];
    
    //最多存100个对象
    cache.countLimit = 100;
    
    //最大100M
    cache.totalCostLimit = 100*1000*1000;
    
    NSURL *url = [NSURL URLWithString:@"http:www"];
    NSPurgeableData *cachedData = [cache objectForKey:url];
    if (cachedData) {
        
    } else {
        NSData *data;
        
        /**
         *  要使用NSPurgeableData对象，可以调用beginContentAccess告诉它不应该丢弃所占用的内存
         用完后，调用endContentAccess，告诉它必要时可以丢弃所占用内存。
         */
        NSPurgeableData *purgeableData = [NSPurgeableData dataWithData:data];
        [cache setObject:purgeableData forKey:url cost:purgeableData.length];
        
        /**
         *  注意：创建好NSPurgeableData对象后，其purge 引用计数会多1，
         所有无需手动调用beginContentAccess，
         但后面必须调用endContentAccess，来把多的1抵消掉
         */
//        [purgeableData beginContentAccess];
        
        //数据可能被
        [purgeableData endContentAccess];
    }
}

#pragma mark - 第 51 条:精简initialize与load的实现代码

/**load
 *  对于加入运行时系统的每个类和分类来说，必定会调用此方法，而且仅调用一次
 对iOS是在程序启动后调用。分类和类都定义了load，会先调用类的，然后再掉分类的。
 
 load方法问题：
 1.在load中使用其他类是不安全的。
 2.不遵从继承规则，如果某个类没实现load，那么就不会往上调用它父类的load方法
 3.执行load时，应用会阻塞，所以需要精简一些
 
 执行load方法时，运行时系统处于"脆弱状态"（），在执行子类load前，
 必须先执行所有父类load方法。如果还依赖了其他程序库，也会执行相关load，
 但无法判断加载顺序，所以在load中使用其他类是不安全的。
 */
+ (void)load {
    //nslog ok，因为Foundation肯定在运行load前就已经载入系统了
    NSLog(@"load %@", [self class]);
    
    ObjectiveC_Memory *obj = [ObjectiveC_Memory new];
    if (obj) {
        /**
         使用其他的类是不安全的，
         也许ObjectiveC_Memory在load里面做了些重要的操作
         
         */
    }
}


/**
 *  在首次用该类之前调用，且只调用一次。
 由运行时系统调用，不能手动调用。与load不同点：
 
 1. "惰性调用"，只有用到该类了，才会调用
 2. 运行时在执行该方法时，是处于正常状态，且能确保initialize在线程安全的环境执行
 3. 同其他类方法，如果某个类未实现它，而它的父类实现了，那会运行父类的实现代码。
 
 
 initialize中也不要执行耗时或需要加锁的任务，
 1. 类可能在UI线程中完成初始化
 2. 开发者无法控制类的初始化时机
 3. 某个类可能用到其他类，用到的类又可能依赖本类的数据，而造成某些数据没初始化好
 4. 无法在编译期设定的全局常量，可以放在initialize方法里
 */
+ (void)initialize {
    
    /**
     *  添加一个判断，可以避免子类引起的调用，2种情况
     1. 子类未实现
     2. 子类手动调用[super initialize]
     */
    if (self == [ObjectiveC_SystemFramework class]) {
    }
    NSLog(@"initialize %@", [self class]);
    /**
     子类未实现initialize时，输出如下：
     initialize ObjectiveC_SystemFramework 
     父类自己的输出
     
     initialize ObjectiveC_SystemFramework_sub 
     由于子类未实现该方法，但它的父类实现了，所以会调用父类的initialize方法
     而这时候，在父类中打印的self是ObjectiveC_SystemFramework_sub
    
     */
}

@end

@interface ObjectiveC_SystemFramework_sub : ObjectiveC_SystemFramework

@end

@implementation ObjectiveC_SystemFramework_sub

+ (void)load {
    NSLog(@"load_1 %@", [self class]);
}

//+ (void)initialize {
//    NSLog(@"initialize_1 %@", [self class]);
//}




@end


#pragma mark - 第 52 条:NSTimer会保留其目标对象

/**
 *  直到自身失效后再释放目标对象。
 */

@interface NSTimer (Block)

@end

@implementation NSTimer (Block)

/**
 *  使用block方式封装，target是NSTimer类对象，单例，所以没问题
 */
+ (NSTimer *)yy_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)blockInvoke:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end

























