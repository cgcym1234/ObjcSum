//
//  MethodSwizzling.m
//  ObjcSum
//
//  Created by sihuan on 2016/7/11.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "MethodSwizzling.h"
#import <objc/runtime.h>

@implementation MethodSwizzling

#pragma mark - 跟踪在程序中每一个view controller展示给用户的次数

//Swizzling应该总是在+load中执行
+ (void)load {
    //## Swizzling应该总是在dispatch_once中执行
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        // 通过class_getInstanceMethod()函数从当前对象中的method list获取method结构体，如果是类方法就使用class_getClassMethod()函数获取。
        SEL originalSelector = @selector(viewWillAppear:);
        Method originalMethod = class_getInstanceMethod(cls, originalSelector);
        
        SEL swizzledSelector = @selector(ch_viewWillAppear:);
        Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
        
        /**
         *  我们在这里使用class_addMethod()函数对Method Swizzling做了一层验证，如果self没有实现被交换的方法，会导致失败。
         *  而且self没有交换的方法实现，但是父类有这个方法，这样就会调用父类的方法，结果就不是我们想要的结果了。
         *  所以我们在这里通过class_addMethod()的验证，如果self实现了这个方法，class_addMethod()函数将会返回NO，我们就可以对其进行交换了。
         */
        BOOL didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
			///如果这个类中没有实现这个方法，class_getInstanceMethod() 返回的是某个父类的 Method 对象，这样 method_exchangeImplementations() 就把父类的原始实现（IMP）跟这个类的 Swizzle 实现交换了。这样其他父类及其其他子类的方法调用就会出问题，最严重的就是 Crash。
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}


#pragma mark - Method Swizzling

- (void)ch_viewWillAppear:(BOOL)animated {
	///在swizzling的过程中，方法中的[self ch_viewWillAppear:animated]已经被重新指定到UIViewController类的-viewWillAppear:中。在这种情况下，不会产生无限循环。不过如果我们调用的是[self viewWillAppear:animated]，则会产生无限循环，因为这个方法的实现在运行时已经被重新指定为ch_viewWillAppear:了。
    [self ch_viewWillAppear:animated];
    NSLog(@"viewWillAppear: %@", self);
}

@end



















