//
//  ObjectiveC_method_swizzling.m
//  ObjcSum
//
//  Created by sihuan on 15/12/28.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "ObjectiveC_method_swizzling.h"
#import <objc/runtime.h>

@implementation ObjectiveC_method_swizzling

#pragma mark - 用method swizzling 调试 "黑盒方法"

/**
 *  类的方法列表会把selector的名称映射到相关的方法实现上,使"dynamic method dispatch system"能据此找到相应的方法.这些方法都是以函数指针的形式来表示,这种指针叫IMP,原型如下:
 
	id (*IMP)(id, SEL, ...);
 */

#pragma mark - method_exchangeImplementations

//交换2个已经写好的方法实现
- (void)exchangSelector:(SEL)aSel with:(SEL)bSel {
    Method method1 = class_getInstanceMethod(self.class, aSel);
    Method method2 = class_getInstanceMethod(self.class, bSel);
    method_exchangeImplementations(method1, method2);
}

#pragma mark - Method Swizzling

//使用my_func1替换原来的func1,且保留原func1原有功能
/**
 *  通过此方案,开发者可以为那些“完全不知道其具体实现的”(completely opaque,“完全不透明的”)黑盒方法添加记录功能,这非常有利于程序调试
 */
- (void)methodSwizzling {
    Method func1 = class_getInstanceMethod(self.class, @selector(func1));
    Method my_func1 = class_getInstanceMethod(self.class, @selector(my_func1));
    method_exchangeImplementations(func1, my_func1);
}

/**
 *  这段代码看上去会陷入无限递归调用的循环,但此方法是准备和 func1 方法交换的。
 所以,在运行期,my_func1 selector实际上对应于原有的 func1 方法实现。
 func1 selector对应my_func1方法实现
 */
- (void)my_func1 {
    [self my_func1];
    NSLog(@"my_func1");
}

- (void)func1 {
    NSLog(@"func1");
}
- (void)func2 {
    
}
- (void)func3 {
    
}
- (void)func4 {
    
}


@end
