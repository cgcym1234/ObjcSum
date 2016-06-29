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


@implementation MethodAndMessages

@end



