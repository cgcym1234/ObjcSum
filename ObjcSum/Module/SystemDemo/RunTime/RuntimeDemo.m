//
//  RuntimeDemo.m
//  ObjcSum
//
//  Created by sihuan on 16/3/25.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "RuntimeDemo.h"
#import "MethodForword.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation RuntimeDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MethodForword new] test];
    [MethodForword test];
}

#pragma mark - 消息转发过程

- (void)messageForward {
    //以向MethodForword对象发送testInstance消息为例子
    MethodForword *obj = [MethodForword new];
    [obj performSelector:@selector(testInstance)];
    
    //1. 会被转换成如下C语言方式调用
    //objc_msgSend(obj, @selector(testInstance));
    
    /**
     objc_msgSend的动作比较清晰：
     1. 首先在 Class 中的缓存查找 IMP （没缓存则初始化缓存），如果没找到，则向父类的 Class 查找。
     2. 如果一直查找到根类仍旧没有实现，则用_objc_msgForward函数指针代替 IMP 。最后，执行这个 IMP 。
     */
}

#pragma mark - objc_msgSend伪代码

id yy_objc_msgSend(id self, SEL op, ...) {
    if (!self) {
        return nil;
    }
    //IMP imp = class_getMethodImplementation(self->isa, op);
    //imp(self, op, ...);//调用这个函数，伪代码...
    
    return nil;
}

//查找IMP
IMP yy_class_getMethodImplementation(Class cls, SEL sel) {
    if (!cls || !sel) {
        return nil;
    }
    IMP imp = lookUpImpOrNil(cls, sel);
    if (!imp) {
        /**
         _objc_msgForward是一个函数指针（和 IMP 的类型一样），是用于消息转发的：
         当向一个对象发送一条消息，但它并没有实现的时候，_objc_msgForward会尝试做消息转发。
         */
        return _objc_msgForward;//_objc_msgForward 用于消息转发
    }
    return imp;
}

IMP lookUpImpOrNil(Class cls, SEL sel) {
//    if (!cls->initialize()) {
//        _class_initialize(cls);
//    }
//    
//    Class curClass = cls;
//    IMP imp = nil;
//    do {//先查缓存,缓存没有时重建,仍旧没有则向父类查询
//        if (!curClass) break;
//        if (!curClass->cache) fill_cache(cls, curClass);
//        imp = cache_getImp(curClass, sel);
//        if (imp) break;
//    } while(curClass = curClass->superclass);
//    return imp;
    return nil;
}

#pragma mark -  _objc_msgForward消息转发做的几件事：

/**
 _objc_msgForward消息转发做的几件事：
 
 1. 调用resolveInstanceMethod:方法 (或 resolveClassMethod:)。允许用户在此时为该 Class 动态添加实现。
    1. 如果有实现了，则调用并返回YES，那么重新开始objc_msgSend流程。这一次对象会响应这个选择器，一般是因为它已经调用过class_addMethod。
    2. 如果仍没实现，继续下面的动作。
 
 2. 调用forwardingTargetForSelector:方法，尝试找到一个能响应该消息的对象。
    1. 如果获取到，则直接把消息转发给它，返回非 nil 对象。
    2. 否则返回 nil ，继续下面的动作。
    - 注意，这里不要返回 self ，否则会形成死循环。
 
 3. 调用methodSignatureForSelector:方法，尝试获得一个方法签名。
    1. 如果获取不到，则直接调用doesNotRecognizeSelector抛出异常。
    2. 如果能获取，则返回非nil：创建一个 NSlnvocation 并传给forwardInvocation:。
 
 4. 调用forwardInvocation:方法，将第3步获取到的方法签名包装成 Invocation 传入，如何处理就在这里面了，并返回非ni。
 
 5. 调用doesNotRecognizeSelector: ，默认的实现是抛出异常。如果第3步没能获得一个方法签名，执行该步骤。
 
 上面前4个方法均是模板方法，开发者可以override，由 runtime 来调用。最常见的实现消息转发：就是重写方法3和4，吞掉一个消息或者代理给其他对象都是没问题的
 
 也就是说_objc_msgForward在进行消息转发的过程中会涉及以下这几个方法：
 
 1. resolveInstanceMethod:方法 (或 resolveClassMethod:)。
 
 2. forwardingTargetForSelector:方法
 
 3. methodSignatureForSelector:方法
 
 4. forwardInvocation:方法
 
 5. doesNotRecognizeSelector: 方法
 */

#pragma mark - 下面回答下第二个问题“直接_objc_msgForward调用它将会发生什么？”

/**
 直接调用_objc_msgForward是非常危险的事，如果用不好会直接导致程序Crash，但是如果用得好，能做很多非常酷的事。
 
 就好像跑酷，干得好，叫“耍酷”，干不好就叫“作死”。
 */

#pragma mark - 有哪些场景需要直接调用_objc_msgForward？

/**
 最常见的场景是：你想获取某方法所对应的NSInvocation对象。举例说明：
 
 JSPatch （Github 链接）就是直接调用_objc_msgForward来实现其核心功能的：
 */

@end






















