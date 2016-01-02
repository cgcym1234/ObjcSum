//
//  ObjectiveC_objc_msgSend.m
//  ObjcSum
//
//  Created by sihuan on 15/12/27.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "ObjectiveC_objc_msgSend.h"
#import "ObjectiveCPointor.h"
#import <objc/runtime.h>



void functionForMethod1(id self, SEL _cmd) {
    NSLog(@"%@, %p", self, _cmd);
}

@implementation ObjectiveC_objc_msgSend


#pragma mark - 消息转发相关

- (id)getName:(NSString *)key {
    return @"name";
}

/**
 *  在 Objective-C 中,如果向对象发送消息,会使用动态绑定机制来决定需要调用的方法。
 而在底层,所有方法都是普通的 C 语言函数
 */
- (void)objc_msgSendDemo {
    
    id name = [self getName:@"key"];
    if (name) {
        
    }
    /**
     *  编译器看到此消息后,将其转换成标准的C语言函数调用,所调用的函数是消息传递机制中的核心函数,叫objc_msgSend,原型如下:
     void objc_msgSend(id self, SEL cmd, ...)
     第一个参数是接受者,第二个参数是selector,后续是参数,所以上面的消息被转换成如下函数:
     id name = objc_msgSend(self, @selector(getName:), @"key");
     */
    
    /**
     *  然后在接收者(self)所属的类中,查询它的"方法列表"(list of methods),如果能找到与selector名称相同的方法,  就跳至其实现代码。
     class_copyMethodList:可以获取方法列表
     */
}

#pragma mark - “消息转发”(message forwarding)机制

/**
 *  当对象收到无法解读的消息, 会启动“消息转发”(message forwarding)机制,我们可经由此过程告诉对象应如何处理未知消息。
 */

/**
 *  默认情况下，对象接收到未知的消息，会导致程序崩溃，通过控制台，我们可以看到以下异常信息：
 
 -[SUTRuntimeMethod method]: unrecognized selector sent to instance 0x100111940
 
 *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[SUTRuntimeMethod method]: unrecognized selector sent to instance 0x100111940'
 这段异常信息实际上是由NSObject的”doesNotRecognizeSelector”方法抛出的。不过，我们可以采取一些措施，让我们的程序执行特定的逻辑，而避免程序的崩溃。
 */

#pragma mark - 动态方法解析

/**
 *  在对象收到到无法解析的消息后, 首先将调用其所属类的类方法:
 + (BOOL)resol eInstanceMethod:(SEL)selector
 该方法的参数就是那个未知的selector,其放回值为 Boolean 类型,表示这个类是否能新增一个实例方法用以处理此selector。
 
 在继续往下执行转发机制之前,本类有机会新增一个处理该selector的方法。 如果未实现的方法不是实例方法而是类方法, 那么运行时系统会调用  另一个方法, “+ (BOOL)resolveClassMethod:(SEL)selector”。
 
 不过使用这种方法的前提是我们已经实现了该”处理方法”，只需要在运行时通过class_addMethod函数动态添加到类里面就可以了。下面代码演示了如何用“resolveInstanceMethod:”来实现 @dynamic 属性:
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    if ([selectorString isEqualToString:@"method1"]) {
        class_addMethod([self class], @selector(method1), (IMP)functionForMethod1, "@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

#pragma mark - 备用接收者

/**
 *  如果在上一步无法处理消息，则Runtime会继续调以下方法：
 
 参数aSelector代表上面未知的selector, 如果当前对象能找到备用接收者, 就将其返回, 否则返回nil。当然这个对象不能是self自身，否则就是出现无限循环。

 */
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([ObjectiveCPointor instancesRespondToSelector:aSelector]) {
        return [ObjectiveCPointor new];
    }
    return nil;
}

#pragma mark - 完整消息转发

/**
 *  运行时系统会在这一步给消息接收者最后一次机会将消息转发给其它对象。对象会创建一个表示消息的NSInvocation对象，把与尚未处理的消息有关的全部细节都封装在anInvocation中，包括selector，目标(target)和参数。我们可以在forwardInvocation方法中选择将消息转发给其它对象。
 
 这个方法可以实现得很简单:只需改变调用目标,使消息在新目标上得以调用 即可。这样实现出来的方法与“备用接收者”方案所实现的方法等效,所以很少有人用这么简单的实现方式。  比较有用的实现方式为:在触发消息前, 先以某种方式改变消息内容, 如追加一个新的参数,或是改变selector等等。
 
 另外，若发现某个消息不应由本类处理，则应调用父类的同名方法，以便继承体系中的每个类都有机会处理此调用请求。直到NSObject。如果调用了 NSObject 类的方法,那么该方法还会继而调用“ doesNotRecognizeSelector:”以抛出异常, 此异常表明selector最终未能得到处理。
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([ObjectiveCPointor instancesRespondToSelector:anInvocation.selector]) {
        return [anInvocation invokeWithTarget:[ObjectiveCPointor new]];
    }
}

/**
 *  我们必须重写以下方法
 
 *消息转发机制使用从这个方法中获取的信息来创建NSInvocation对象。因此我们必须重写这个方法，为给定的selector提供一个合适的方法签名。
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [ObjectiveCPointor instanceMethodSignatureForSelector:aSelector];
    }
    return signature;
}

@end



#pragma mark - C 语言的函数调用方式

/**
 由于 Objective-C 是 C 的超集,所以先理解 C 语言的函数调用方式。
 
 *  C 语言使用“静态绑定”(static binding), 在编译期能决定运行时所应调用的函数。下面是C的方式:
 */

void printHello() { printf("Hello, world! n"); }
void printGoodbye() { printf("goodbye, world! n"); }

/**
 *  如果不考虑“内联”(inline),那么编译器在编译代码的时就知道程序中有 printHello 与 printGoodbye 这2个函数了,于是会直接生成调用这些函数的指令。函数地址实际上是硬编码在指令之中的。
 */
void doSome(int type) {
    if (type == 0) {
        printHello();
    } else {
        printGoodbye();
    }
}

/**
 *  下面这种情况就得使用“动态绑定”(dynamic binding)了, 因为所要调用的函数直到运行期才能确定。
 编译器在这中情况下生成 的指令与上面不同,在上面,if 与 else 语句中都有函数调用指令。
 
 而在下面,只有一个函数调用指令,不过待调用的函数地址无法硬编码在指令之中,而是要在运行期读取出来。
 */
void doSome2(int type) {
    void (*func)();
    if (type == 0) {
        func = printHello;
    } else {
        func = printGoodbye;
    }
    func();
}



