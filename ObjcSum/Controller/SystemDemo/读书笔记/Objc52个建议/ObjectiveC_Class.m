//
//  ObjectiveC_Class.m
//  ObjcSum
//
//  Created by sihuan on 15/12/28.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "ObjectiveC_Class.h"
#import <objc/runtime.h>

@implementation ObjectiveC_Class

#pragma mark - 理解"类对象"的用意

/**
 *  消息的接受者是什么?是对象本身吗?运行时系统(runtime system)如何知道某个对象的类型呢?
 
 对象类型并非在编译期就绑定好了,而是要在运行时查找.还有个特殊类型id,它能指代任何Objective-C对象类型。
 
 在运行时检视对象类型，这一操作也叫做"类型信息查询（introspection，内省）"，这个强大的特性内置于Foundation框架的NSObject协议里，凡事由公共根类（common root class，即NSObject与NSProxy）继承而来的对象都要遵从此协议。
 */

- (void)test {
    //每个 Objective-C 对象实例都是指向某块内存数据的指针。所以在声明变量时,类型前面要 一个“*”字符:
    
    NSString *pointerVariable = @"Some string";
    
    //Objective-C 对象所用的数据结构定义在运行期程序库的头文件 ,id 类型如下:
    /*
     typedef struct objc_object {
        Class isa;
     } *id;
     */
    //由此可见，每个对象结构体的首个成员是Class类的变量。该变量定义了对象所属的类，通常称为"isa"指针。Class对象也定义在运行时程序库中：
    
    /**
     typedef struct objc_class *Class;
     struct objc_class {
     Class isa;
     Class super_class;
     const char *name;
     long ersion;
     long info;
     long instance_size;
     struct objc_ivar_list *ivars;
     struct objc_method_list **methodLists;
     struct objc_cache *cache;
     struct objc_protocol_list *protocols;
     };
     */
    
    #pragma mark - 在类继承体系中查询类型信息
    
    /**
     *  可以用类型信息查询方法来检查类继承体系。“ isMemberOfClass:”能   判断出对象是否是某个特定类的实例,而“isKindOfClass:” 能判断出对象是否为某类或其派生类的实例。例如:
     */
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict isMemberOfClass:[NSDictionary class]]; //< NO
    [dict isMemberOfClass:[NSMutableDictionary class]];  //  YES
    [dict isKindOfClass:[NSDictionary class]];   //< YES
    [dict isKindOfClass:[NSArray class]];   //< NO
    
    /**
     *  也可以用比较类对象是否等同的办法来做。使用 == 操作 ,而不要使用  Objective-C对象时常用的“isEqual:”方法。原因在于,类对象是 “单 例”(singleton),在应用程序范围内,每个类的 Class 仅有一个实例。  如下:
     */
    if (pointerVariable.class == [NSString class]) {
        /**
         *  但尽量不这样做，使用上面的判断
         
         因为前者可以正确处理那些使用了消息传递机制(参见第12 条)的对象。
         比如某个对象可能会把它收到的所有selector转发给另外一个对象。
         这样的对象叫做“代理”(proxy),对这种对象均以NSProxy为根类。
         */
    }
}

@end

#pragma mark - Class对象

/**
 *  该结构体objc_class存放类的"元数据（metadata）"，比如类的实例实现了几个方法，有多少个变量等信息。首个变量也是isa指针，这说明Class本身也是Objective-C对象。还有个super_class，定义了本类的父类。
 
 类对象所属的类型是另外一个类，叫做"元类"(metaclass)，用来表述类对象本身所具备的元数据。"类方法"就定义于此处。每个类仅有一个"类对象"，而每个"类对象"仅有一个与之相关的"元类"。
 */
typedef struct objc_class1 *Class;
struct objc_class1 {
    Class isa;
    Class super_class;
    const char *name;
    long ersion;
    long info;
    long instance_size;
    struct objc_ivar_list *ivars;
    struct objc_method_list **methodLists;
    struct objc_cache *cache;
    struct objc_protocol_list *protocols;
};



