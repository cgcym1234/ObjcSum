//
//  MainShiDemo.m
//  ObjcSum
//
//  Created by sihuan on 16/5/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "MainShiDemo.h"
#import <objc/runtime.h>

/**
 synthesize 合成访问器方法
 实现property所声明的方法的定义。其实说直白就像是：property声明了一些成员变量的访问方法，synthesize则定义了由property声明的方法。
 
 他们之前的对应关系是:property 声明方法 ->头文件中申明getter和setter方法 synthesize定义方法 -> m文件中实现getter和setter方法。
 
 在Xcode4.5及以后的版本中，可以省略@synthesize，编译器会自动帮你加上get 和 set 方法的实现，并且默认会去访问_age这个成员变量，如果找不到_age这个成员变量，会自动生成一个叫做 _age的私有成员变量。在.m文件中同时实现getter和setter时候需要@synthesize age = _age.
 */


@interface MainShiDemo() {
    NSString *obj;
}

@property (nonatomic, strong) NSString *title;

@property NSString *firstName;
@property NSString *lastName;
@property NSString *obj;

@end

@implementation MainShiDemo

//重载
@synthesize title;

@synthesize firstName = _myFirstName;
@synthesize lastName = _myLastName;
//上述语法会将生成的实例变量命名为 _myFirstName 与 _myLastName ，而不再使用默认的名字。

/**
 总结下 @synthesize 合成实例变量的规则，有以下几点：
 
 1. 如果指定了成员变量的名称,会生成一个指定的名称的成员变量,
 2. 如果这个成员已经存在了就不再生成了.
 3. 如果是 @synthesize foo; 还会生成一个名称为foo的成员变量，也就是说：
    - 如果没有指定成员变量的名称会自动生成一个属性同名的成员变量,
 4. 如果是 @synthesize foo = _foo; 就不会生成成员变量了.
 */


#pragma mark - 25. _objc_msgForward函数是做什么的，直接调用它将会发生什么？

- (void)msgForwardDemo {
    //_objc_msgForward是 IMP 类型，用于消息转发的：当向一个对象发送一条消息，但它并没有实现的时候，_objc_msgForward会尝试做消息转发。
}


@end





















