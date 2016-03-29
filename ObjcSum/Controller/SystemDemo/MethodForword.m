//
//  MethodForword.m
//  ObjcSum
//
//  Created by sihuan on 16/3/25.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "MethodForword.h"
#import <objc/runtime.h>

@implementation MethodParent

- (void)testInstance {
    NSLog(@"testInstance");
}

@end


@implementation MethodForword

- (void)test {
    [self performSelector:@selector(testInstance)];
    [self objc_msgSendDemo];
}
+ (void)test {
    [self performSelector:@selector(testClass)];
}
#pragma mark - 理解 objc_msgSend 的作用
/**
 *  在 Objective-C 中,如果向对象发送消息, 会使用动态绑定机制来决定需要调用的方法。
 在底层,所有方法都是普通的 C 语言函数, 对象收到消息后, 要调用哪个方法, 完全于运行期决定, 
 甚至可以在程序运行时改变,这些特性使得 Objective-C 成为一门真正的动态语言。
 */

- (NSString *)test1:(NSString *)name {
    return name;
}

#pragma mark - objc_msgSend过程
- (void)objc_msgSendDemo {
    id value = [self test1:@"test"];
    /**
     1.  编译器看到此消息后,将其转换成标准的C语言函数调用,
     所调用的函数是消息传递机制中的核心函数,叫objc_msgSend,原型如下:
     void objc_msgSend(id self, SEL cmd, ...);
     */
    
    /**
     *  第一个参数是接受者,第二个参数是selector,后续是参数,所以上面的消息被转换成如下函数:
     id value1 = objc_msgSend(self, @selector(test1:), @"test11");
     */
    
    
    /**
     2. 在接收者(someObject)所属的类中,查询它的"方法列表"(list of methods),
     如果能找到与selector名称相同的方法, 就调至其实现代码。
     */
    
    /**
     3. 如果找不到, 沿着继承体系结构向上查找,直到找到合适的方法再跳转。
     如果最终找不到相应的方法, 将执行“消息转发”(message forwarding)操作。
     */
    
    /**
     4. 如上所述调用一个方法需要很多步骤。不过objc_msgSend 会将匹配结果缓存 在“快速映射表”(fast map)中, 
     每个类都有这个缓存, 后面当收到相同的消息,执行起来就快了很多.
     
     不过这种“快速执行路径”(fast path)还是不如 “静态绑定的函数调用操作”(statically bound function call)迅速,
     但也不会慢很多,实际上,消息派发(message dispatch)并非应用程序的瓶颈所在。
     */
    if (value) {
    }
}

#pragma mark - 理解消息转发机制

/**
 *  当对象收到无法解读的消息, 会启动“消息转发”(message forwarding)机制,
 我们可经由此过程告诉对象应如何处理未知消息。
 
 默认情况下，对象接收到未知的消息，会导致程序崩溃
 
 由NSObject的”doesNotRecognizeSelector”方法抛出的。
 
 消息转发分为两大阶段：
 
 1. 动态方法解析(dynamic method resolution)
 2. 完整的消息转发机制(full forwarding mechanism)
    2.1 备用接收者
    2.2 完整的消息转发
 */

#pragma mark 动态方法解析
/**
 *1.  在对象收到到无法解析的消息后, 首先将调用该方法
 *
 *  @param sel 那个未知的selector
 *
 *  @return 表示这个类是否能新增一个实例方法来处理该selector
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"resolveInstanceMethod");
//    NSString *selectorString = NSStringFromSelector(sel);
//    if ([selectorString isEqualToString:@"method1"]) {
//        class_addMethod([self class], @selector(method1), (IMP)functionForMethod1, "@:");
//        return YES;
//    }
    return [super resolveInstanceMethod:sel];
}

/**
 *1.  如果未实现的方法不是实例方法而是类方法,将调用该方法
 *
 *  @param sel 那个未知的selector
 *
 *  @return 表示这个类是否能新增一个实例方法来处理该selector
 */
+ (BOOL)resolveClassMethod:(SEL)sel {
    NSLog(@"resolveClassMethod");
    return [super resolveClassMethod:sel];
}

#pragma mark 备用接收者

/**
 *  如果在上一步无法处理消息，则Runtime会继续调以下方法：
 *
 *  @param aSelector 代表上面未知的selector
 *
 *  @return 如果当前对象能找到备用接收者, 就将其返回, 否则返回nil。
 当然这个对象不能是self自身，否则就是出现无限循环。
 */
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"forwardingTargetForSelector");
    return nil;
}

#pragma mark 完整消息转发
/**
 *  如果在上一步还不能处理未知消息，则唯一能做的就是启用完整的消息转发机制了
 
 运行时系统会在这一步给消息接收者最后一次机会将消息转发给其它对象。
 
 对象会创建一个表示消息的NSInvocation对象，把与尚未处理的消息有关的全部细节都封装在anInvocation中，包括selector，目标(target)和参数。
 
 我们可以在forwardInvocation方法中选择将消息转发给其它对象。
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"forwardInvocation");
}

/**
 *  消息转发机制使用从这个方法中获取的信息来创建NSInvocation对象。
 因此我们必须重写这个方法，为给定的selector提供一个合适的方法签名。
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"methodSignatureForSelector");
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [NSMethodSignature signatureWithObjCTypes:@encode(void)];
    }
    return signature;
}

@end























