//
//  LoadAndInitialize.m
//  ObjcSum
//
//  Created by yangyuan on 2017/3/10.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "LoadAndInitialize.h"

#pragma mark - 问题

//  大家来看一下下面的程序以及图一会输出什么？

////Father.m
//+ (void)load {
//    NSLog(@"Father:%s %@", __FUNCTION__, [self class]);
//}
//+ (void)initialize {
//    NSLog(@"Father:%s %@", __FUNCTION__, [self class]);
//}
////Son.m   Class Son Extends Father
//+ (void)load {
//    NSLog(@"Son:%s %@", __FUNCTION__, [self class]);
//}
////Son+load.m
//+ (void)load {
//    NSLog(@"Son+load:%s %@", __FUNCTION__, [self class]);
//}
////Other.m
//+ (void)load {
//    NSLog(@"Other:%s %@", __FUNCTION__, [self class]);
//}
//+ (void)initialize {
//    NSLog(@"Other:%s %@", __FUNCTION__, [self class]);
//}
////Other+initialize.m
//+ (void)initialize {
//    NSLog(@"Other+initialize:%s %@", __FUNCTION__, [self class]);
//}
////main.m
//int main(int argc, char * argv[]) {
//    NSLog(@"Main method start!");
//    return 0;
//}


#pragma mark - 结果
/*
 
 结果如下：
 
 2017-03-10 11:00:21.815 Load+Initialize[37189:988075] Other+initialize:+[Other(initialize) initialize] Other
 2017-03-10 11:00:21.817 Load+Initialize[37189:988075] Other:+[Other load] Other
 2017-03-10 11:00:21.817 Load+Initialize[37189:988075] Father:+[Father initialize] Father
 2017-03-10 11:00:21.818 Load+Initialize[37189:988075] Father:+[Father load] Father
 2017-03-10 11:00:21.818 Load+Initialize[37189:988075] Father:+[Father initialize] Son
 2017-03-10 11:00:21.819 Load+Initialize[37189:988075] Son:+[Son load] Son
 2017-03-10 11:00:21.820 Load+Initialize[37189:988075] Son+load:+[Son(load) load] Son
 2017-03-10 11:00:21.820 Load+Initialize[37189:988075] Other+initialize:+[Other(initialize) load] Other
 2017-03-10 11:00:21.821 Load+Initialize[37189:988075] Main method start!
 
 
 分类有自己的load，但会覆盖主类的initialize
 */

#pragma mark - 分析
/*
 首先来说一下调用时机：
 
 +load()方法：官方文档上说Invoked whenever a class or category is added to the Objective-C runtime;，意思是说当类被加载到runtime的时候就会运行，也就是说是在main.m之前~会根据Compile Sources中的顺序来加载，但还有一个需注意的加载顺序
 A class’s +load method is called after all of its superclasses’ +load methods.
 A category +load method is called after the class’s own +load method.
 意思是说有继承关系的会先调用父类+load，扩展的类在所有的类在方法之后再开始扩展方法的+load，每个类只会调用一次+load
 +initialize()方法：官方文档上说Initializes the class before it receives its first message.意思是在类接收第一条消息之前初始化类
 值得注意的点是：类初始化的时候每个类只会调用一次+initialize()，如果子类没有实现+initialize()，那么将会调用父类的+initialize()，也就是意味着父类的+initialize()可能会被多次调用
 最后说下使用场景：
 
 +load():通常用来进行Method Swizzle，尽量避免过于复杂以及不必要的代码
 +initialize():一般用于初始化全局变量或静态变量
 */


@implementation LoadAndInitialize

@end
