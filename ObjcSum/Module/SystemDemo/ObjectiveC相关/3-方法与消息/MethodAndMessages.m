//
//  MethodAndMessages.m
//  ObjcSum
//
//  Created by sihuan on 2016/6/29.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "MethodAndMessages.h"
#import <objc/runtime.h>

#pragma mark - ### SEL
/**
 SEL又叫选择器，是表示一个方法的selector的指针，其定义如下：
 
 typedef struct objc_selector *SEL;
 
 Objective-C在编译时，会依据每一个方法的名字、参数序列，生成一个唯一的整型标识(Int类型的地址)，这个标识就是SEL。
 
 本质上，SEL只是一个指向方法的指针（准确的说，只是一个根据方法名hash化了的KEY值，能唯一代表一个方法），它的存在只是为了加快方法的查询速度。
 */

#pragma mark - ### IMP

/**
IMP实际上是一个函数指针，指向方法实现的首地址。其定义如下：

id (*IMP)(id, SEL, ...)
 
 这个函数使用当前CPU架构实现的标准的C调用约定。第一个参数是指向self的指针(如果是实例方法，则是类实例的内存地址；如果是类方法，则是指向元类的指针)，第二个参数是方法选择器(selector)，接下来是方法的实际参数列表。
 
 SEL就是为了查找方法的最终实现IMP的。
 
 通过取得IMP，我们可以跳过Runtime的消息传递机制，直接执行IMP指向的函数实现，这样省去了Runtime消息传递过程中所做的一系列查找操作，会比直接向对象发送消息高效一些。
*/

#pragma mark - ### Method
/**
 * Method用于表示类定义中的方法，则定义如下：
 typedef struct objc_method *Method;
 
 实际上相当于在SEL和IMP之间作了一个映射。
 */
struct yy_objc_method {
    SEL method_name;// 方法名
    char *method_types;
    IMP method_imp;// 方法实现
};


#pragma mark - ## 方法相关操作函数

/**
 ### 方法
 
 方法操作相关函数包括下以：
 
 ```
 // 调用指定方法的实现
 id method_invoke ( id receiver, Method m, ... );
 
 // 调用返回一个数据结构的方法的实现
 void method_invoke_stret ( id receiver, Method m, ... );
 
 // 获取方法名
 SEL method_getName ( Method m );
 
 // 返回方法的实现
 IMP method_getImplementation ( Method m );
 
 // 获取描述方法参数和返回值类型的字符串
 const char * method_getTypeEncoding ( Method m );
 
 // 获取方法的返回值类型的字符串
 char * method_copyReturnType ( Method m );
 
 // 获取方法的指定位置参数的类型字符串
 char * method_copyArgumentType ( Method m, unsigned int index );
 
 // 通过引用返回方法的返回值类型字符串
 void method_getReturnType ( Method m, char *dst, size_t dst_len );
 
 // 返回方法的参数的个数
 unsigned int method_getNumberOfArguments ( Method m );
 
 // 通过引用返回方法指定位置参数的类型字符串
 void method_getArgumentType ( Method m, unsigned int index, char *dst, size_t dst_len );
 
 // 返回指定方法的方法描述结构体
 struct objc_method_description * method_getDescription ( Method m );
 
 // 设置方法的实现
 IMP method_setImplementation ( Method m, IMP imp );
 
 // 交换两个方法的实现
 void method_exchangeImplementations ( Method m1, Method m2 );
 ```
 
 - `method_invoke`函数，返回的是实际实现的返回值。参数receiver不能为空。这个方法的效率会比`method_getImplementation和method_getName`更快。
 
 - `method_getName`函数，返回的是一个SEL。如果想获取方法名的C字符串，可以使用sel_getName(method_getName(method))。
 
 - method_getReturnType函数，类型字符串会被拷贝到dst中。
 
 - method_setImplementation函数，注意该函数返回值是方法之前的实现。
 
 ### 方法选择器
 
 选择器相关的操作函数包括：
 
 ```
 // 返回给定选择器指定的方法的名称
 const char * sel_getName ( SEL sel );
 
 // 在Objective-C Runtime系统中注册一个方法，将方法名映射到一个选择器，并返回这个选择器
 SEL sel_registerName ( const char *str );
 
 // 在Objective-C Runtime系统中注册一个方法
 SEL sel_getUid ( const char *str );
 
 // 比较两个选择器
 BOOL sel_isEqual ( SEL lhs, SEL rhs );
 ```
 
 - sel_registerName函数：在我们将一个方法添加到类定义时，我们必须在Objective-C Runtime系统中注册一个方法名以获取方法的选择器。
 */


/*
 消息转发
 
 当一个对象能接收一个消息时，就会走正常的方法调用流程。但如果一个对象无法接收指定消息时，又会发生什么事呢？
 默认情况下，如果是以[object message]的方式调用方法，如果object无法响应message消息时，编译器会报错。但如果是以perform...的形式来调用，则需要等到运行时才能确定object是否能接收message消息。如果不能，则程序崩溃。
 
 当一个对象无法接收某一消息时，就会启动所谓”消息转发(message forwarding)“机制，通过这一机制，我们可以告诉对象如何处理未知的消息。默认情况下，对象接收到未知的消息，会导致程序崩溃
 
 这段异常信息实际上是由NSObject的”doesNotRecognizeSelector“方法抛出的。不过，我们可以采取一些措施，让我们的程序执行特定的逻辑，而避免程序的崩溃。
 
 消息转发机制基本上分为三个步骤：
 
 1. 动态方法解析
 2. 备用接收者
 3. 完整转发
 
 */
@implementation MethodAndMessages

+ (void)test1 {
	/*
	 一个方法选择器是一个C字符串，它是在Objective-C运行时被注册的。选择器由编译器生成，并且在类被加载时由运行时自动做映射操作。
	 可以通过下面三种方法来获取SEL:
	 
	 1. sel_registerName函数
	 2. Objective-C编译器提供的@selector()
	 3. NSSelectorFromString()方法
	 */
	NSLog(@"%s", sel_registerName("test1"));
	NSLog(@"%@", NSStringFromSelector(sel_registerName("test1")));
	NSLog(@"%@", NSStringFromSelector(@selector(test1)));
	NSLog(@"%@", NSStringFromSelector(NSSelectorFromString(@"test1")));
	/*
	 2018-06-18 11:11:15.752073+0800 ObjcSum[691:202412] test1
	 2018-06-18 11:11:15.752187+0800 ObjcSum[691:202412] test1
	 2018-06-18 11:11:15.752236+0800 ObjcSum[691:202412] test1
	 */
	
	/*
	 获取方法地址
	 
	 NSObject类提供了methodForSelector:方法，让我们可以获取到方法的指针，然后通过这个指针来调用实现代码。我们需要将methodForSelector:返回的指针转换为合适的函数类型，函数参数和返回值都需要匹配上。
	 */
	void(*test)(id, SEL) = [self methodForSelector:@selector(test1)];
//	test(self, @selector(test1));
	
}


#pragma mark - 1. 动态方法解析

/*
 对象在接收到未知的消息时，首先会调用所属类的类方法+resolveInstanceMethod:(实例方法)或者+resolveClassMethod:(类方法)。在这个方法中，我们有机会为该未知消息新增一个”处理方法””。不过使用该方法的前提是我们已经实现了该”处理方法”，只需要在运行时通过class_addMethod函数动态添加到类里面就可以了。
 
 不过这种方案更多的是为了实现@dynamic属性。
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
	NSString *methodName = NSStringFromSelector(sel);
	if ([methodName isEqualToString:@"method1"]) {
		class_addMethod(self, @selector(method1), (IMP)test2, "@:");
	}
	return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
	return [super resolveClassMethod:sel];
}
 
void test2(id self, SEL _cmd) {
	NSLog(@"%@, %p", self, _cmd);
}

#pragma mark -  2.备用接收者
/*
 如果在上一步无法处理消息，则Runtime会继续调以下方法：
 
 如果一个对象实现了这个方法，并返回一个非nil的结果，则这个对象会作为消息的新接收者，且消息会被分发到这个对象。当然这个对象不能是self自身，否则就是出现无限循环。当然，如果我们没有指定相应的对象来处理aSelector，则应该调用父类的实现来返回结果。
 
 使用这个方法通常是在对象内部，可能还有一系列其它对象能处理该消息，我们便可借这些对象来处理消息并返回，这样在对象外部看来，还是由该对象亲自处理了这一消息。
 
 这一步合适于我们只想将消息转发到另一个能处理该消息的对象上。但这一步无法对消息进行处理，如操作消息的参数和返回值。
 */
- (id)forwardingTargetForSelector:(SEL)aSelector {
	return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - 3.完整消息转发
/*
 如果在上一步还不能处理未知消息，则唯一能做的就是启用完整的消息转发机制了。此时会调用以下方法：
 
 运行时系统会在这一步给消息接收者最后一次机会将消息转发给其它对象。对象会创建一个表示消息的NSInvocation对象，把与尚未处理的消息有关的全部细节都封装在anInvocation中，包括selector，目标(target)和参数。我们可以在forwardInvocation方法中选择将消息转发给其它对象。
 
 forwardInvocation:方法的实现有两个任务：
 
 1. 定位可以响应封装在anInvocation中的消息的对象。这个对象不需要能处理所有未知消息。
 2. 使用anInvocation作为参数，将消息发送到选中的对象。anInvocation将会保留调用结果，运行时系统会提取这一结果并将其发送到消息的原始发送者。
 
 不过，在这个方法中我们可以实现一些更复杂的功能，我们可以对消息的内容进行修改，比如追回一个参数等，然后再去触发消息。另外，若发现某个消息不应由本类处理，则应调用父类的同名方法，以便继承体系中的每个类都有机会处理此调用请求。
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation {
	
}

///还有一个很重要的问题，我们必须重写以下方法：
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	 NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
	return signature;
}

/*
 NSObject的forwardInvocation:方法实现只是简单调用了doesNotRecognizeSelector:方法，它不会转发任何消息。这样，如果不在以上所述的三个步骤中处理未知消息，则会引发一个异常。
 
 从某种意义上来讲，forwardInvocation:就像一个未知消息的分发中心，将这些未知的消息转发给其它对象。或者也可以像一个运输站一样将所有未知消息都发送给同一个接收对象。这取决于具体的实现。
 */





@end






















