//
//  MethodAndMessages.m
//  ObjcSum
//
//  Created by sihuan on 2016/6/29.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "MethodAndMessages.h"

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

@implementation MethodAndMessages

@end



