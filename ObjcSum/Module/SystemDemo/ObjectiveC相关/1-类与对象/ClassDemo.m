//
//  ClassDemo.m
//  ObjcSum
//
//  Created by sihuan on 2016/6/26.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "ClassDemo.h"
#import "MyClass1.h"

#pragma mark - ## 类与对象基础数据结构

#pragma mark ### Class

//Objective-C类是由Class类型来表示的，它实际上是一个指向objc_class结构体的指针。它的定义如下：

//typedef struct objc_class * YYClass;
struct yy_class {
    //需要注意的是在Objective-C中，所有的类自身也是一个对象，这个对象的Class里面也有一个isa指针，它指向metaClass(元类)，我们会在后面介绍它。
    Class isa;
    
    //指向该类的父类，如果该类已经是最顶层的根类(如NSObject或NSProxy)，则super_class为NULL。
    Class super_class;
    
    // 类名
    const char *name;
    
    // 类的版本信息，默认为0
    /**
     我们可以使用这个字段来提供类的版本信息。这对于对象的序列化非常有用，它可以让我们识别出不同类定义版本中实例变量布局的改变。
     */
    long version;
    
    // 类信息，供运行期使用的一些位标识
    long info;
    
    // 该类的实例变量大小
    long instance_size;
    
    // 该类的成员变量链表
    struct objc_ivar_list *ivars;
    
    // 方法定义的链表
    struct objc_method_list **methodLists;
    
    // 方法缓存
    /**
     用于缓存最近使用的方法。一个接收者对象接收到一个消息时，它会根据isa指针去查找能够响应这个消息的对象。
     在实际使用中，这个对象只有一部分方法是常用的，很多方法其实很少用或者根本用不上。
     这种情况下，如果每次消息来时，我们都是methodLists中遍历一遍，性能势必很差。这时，cache就派上用场了。
     在我们每次调用过一个方法后，这个方法就会被缓存到cache列表中，下次调用的时候runtime就会优先去cache中查找，如果cache没有，才去methodLists中查找方法。
     这样，对于那些经常用到的方法的调用，但提高了调用的效率。
     */
    struct objc_cache *cache;
    
    // 协议链表
    struct objc_protocol_list *protocols;
};

#pragma mark ### objc_object与id

//objc_object是表示一个类的实例的结构体，它的定义如下(objc/objc.h)：
struct yy_object {
    Class isa;
};
typedef struct yy_object *yy_id;

#pragma mark ### objc_cache

//它用于缓存调用过的方法。这个字段是一个指向objc_cache结构体的指针，其定义如下：
struct yy_cache {
    /**
     一个整数，指定分配的缓存bucket的总数。在方法查找过程中，Objective-C runtime使用这个字段来确定开始线性查找数组的索引位置。
     指向方法selector的指针与该字段做一个AND位操作(index = (mask & selector))。这可以作为一个简单的hash散列算法。
     */
    unsigned int mask; /* total = mask + 1 */
    
    //一个整数，指定实际占用的缓存bucket的总数。
    unsigned int occupied;
    
    /**
     指向Method数据结构指针的数组。这个数组可能包含不超过mask+1个元素。
     需要注意的是，指针可能是NULL，表示这个缓存bucket没有被占用，另外被占用的bucket可能是不连续的。这个数组可能会随着时间而增长。
     */
    Method buckets[1];
};



void TestMetaClass(id self, SEL _cmd) {
    NSLog(@"this object is %p", self);
    NSLog(@"class is %@, super class is %@", [self class], [self superclass]);
    
    Class currentClass = [self class];
    for (int i = 0; i < 4; i++) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        currentClass = objc_getClass((__bridge void *)currentClass);
    }
    NSLog(@"NSObject's class is %p", [NSObject class]);
    
    NSLog(@"NSObject's meta class is %p", objc_getClass((__bridge void *)[NSObject class]));
}

#pragma mark - ## 元类(Meta Class)

@implementation ClassDemo

+ (void)launch {
    [self ex_registerClassPair];
    [self testClassFunctions];
    [self createClassDynamic];
    [self instanceMethodDemo];
}

#pragma mark - 查看元类demo
+ (void)ex_registerClassPair {
    //在运行时创建了一个NSError的子类TestClass，然后为这个子类添加一个方法testMetaClass，这个方法的实现是TestMetaClass函数。
    Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
    class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "v@:");
    objc_registerClassPair(newClass);
    
    id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
    [instance performSelector:@selector(testMetaClass)];
    
    /**
     >这里需要注意的是：我们在一个类对象调用class方法是无法获取meta-class，它只是返回类而已
     */
}

#pragma mark - 1.2-类与对象操作函数 Demo

+ (void)testClassFunctions {
    NSLog(@"---------类与对象操作函数 Demo--------------");
    
    MyClass1 *myClass = [MyClass1 new];
    unsigned int outCount = 0;
    Class cls = myClass.class;
    
    NSLog(@"类名：%s", class_getName(cls));
    
    NSLog(@"父类：%s", class_getName(class_getSuperclass(cls)));
    
    NSLog(@"是否是元类： %@", class_isMetaClass(cls) ? @"yes" : @"no");
    
    Class metaClass = objc_getMetaClass(class_getName(cls));
    NSLog(@"class %s 的元类是： %s", class_getName(cls), class_getName(metaClass));
    
    NSLog(@"变量实例大小：%zu", class_getInstanceSize(cls));
    
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"实例变量名：%s, 位置：%d", ivar_getName(ivar), i);
    }
    free(ivars);
    
    Ivar string = class_getInstanceVariable(cls, "_string");
    if (string != NULL) {
        NSLog(@"class_getInstanceVariable获取实例变量：%s,", ivar_getName(string));
    }
    
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"属性名：%s, 位置: %d", property_getName(property), i);
    }
    free(properties);
    
    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"class_getProperty获取属性: %s", property_getName(array));
    }
    
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"方法签名：%s", sel_getName(method_getName(method)));
    }
    free(methods);
    
    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if (method1 != NULL) {
        NSLog(@"class_getInstanceMethod获取方法：%s", sel_getName(method_getName(method1)));
    }
    
    NSLog(@"MyClass1 is %@ responsd to selector:  method3WithArg1:arg2:", class_respondsToSelector(cls, @selector(method3WithArg1:arg2:)) ? @"" : @"not");
    
    IMP imp = class_getMethodImplementation(cls, @selector(method1));
    imp();
    
    objc_property_t *protocols = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t protocol = protocols[i];
        NSLog(@"协议name: %s", protocol_getName((__bridge Protocol *)(protocol)));
    }
    
//     NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));
    
}

#pragma mark - 动态创建类和对象
void imp_submethod1(id self, SEL _cmd) {
    NSLog(@"this object is %p", self);
    NSLog(@"class is %@, super class is %@", [self class], [self superclass]);
    
    Class currentClass = [self class];
    for (int i = 0; i < 4; i++) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        currentClass = objc_getClass((__bridge void *)currentClass);
    }
    NSLog(@"NSObject's class is %p", [NSObject class]);
    
    NSLog(@"NSObject's meta class is %p", objc_getClass((__bridge void *)[NSObject class]));
}


+ (void)createClassDynamic {
    NSLog(@"---------创建一个新类和元类 Demo--------------");
    /**
     创建一个新类和元类
     
     如果我们要创建一个根类，则superclass指定为Nil。
     extraBytes通常指定为0，该参数是分配给类和元类对象尾部的索引ivars的字节数。
     */
    Class cls = objc_allocateClassPair([MyClass1 class], "MySubClass1", 0);
    class_addMethod(cls, @selector(subMethod1), (IMP)imp_submethod1, "v@:");
    class_replaceMethod(cls, @selector(method1), (IMP)imp_submethod1, "v@:");
    
    class_addIvar(cls, "_ivar1", sizeof(NSString *), log(sizeof(NSString *)), "i");
    
    objc_property_attribute_t type = {"T", "@\"NSString\""};
    objc_property_attribute_t ownership = { "C", "" };
    objc_property_attribute_t backingivar = { "V", "_ivar1"};
    objc_property_attribute_t attrs[] = {type, ownership, backingivar};
    class_addProperty(cls, "property2", attrs, 3);
    
    objc_registerClassPair(cls);
    
    id instance = [[cls alloc] init];
    [instance performSelector:@selector(subMethod1)];
    [instance performSelector:@selector(method1)];

}

#pragma mark - ## 实例操作函数

+ (void)instanceMethodDemo {
    NSLog(@"---------实例操作函数 Demo--------------");
    /**
     有这样一种场景，假设我们有类A和类B，且类B是类A的子类。类B通过添加一些额外的属性来扩展类A。
     
     现在我们创建了一个A类的实例对象，并希望在运行时将这个对象转换为B类的实例对象，这样可以添加数据到B类的属性中。这种情况下，我们没有办法直接转换，因为B类的实例会比A类的实例更大，没有足够的空间来放置对象。此时，我们就要以使用以上几个函数来处理这种情况，如下代码所示：
     */
//    NSObject *a = [[NSObject alloc] init];
//    id newB = object_copy(a, class_getInstanceSize(self));
//    object_setClass(newB, self);
//    object_dispose(a);
    
    unsigned int numClass;
    Class *classes = NULL;
    /**
     获取已注册的类定义的列表。我们不能假设从该函数中获取的类对象是继承自NSObject体系的，所以在这些类上调用方法是，都应该先检测一下这个方法是否在这个类中实现。
     */
    numClass = objc_getClassList(NULL, 0);
    if (numClass > 0) {
//        classes = (Class *)malloc(sizeof(Class) * numClass);
        classes = objc_copyClassList(&numClass);
        numClass = objc_getClassList(classes, numClass);
        NSLog(@"number of classes: %d", numClass);
        for (int i = 0; i < numClass; i++) {
            Class cls = classes[i];
            NSLog(@"class name: %s", class_getName(cls));
        }
        free(classes);
    }
}

@end




















