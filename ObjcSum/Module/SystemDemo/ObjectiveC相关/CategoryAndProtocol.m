//
//  CategoryAndProtocol.m
//  ObjcSum
//
//  Created by sihuan on 2016/7/13.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "CategoryAndProtocol.h"
#import <objc/runtime.h>

@implementation CategoryAndProtocol

@end

#pragma mark - Category是表示一个指向分类的结构体的指针，其定义如下：
//typedef struct objc_category *Category;


struct yy_objc_category {
    char *category_name;// 分类名
    char *class_name;// 分类所属的类名
    struct objc_method_list *instance_methods;// 实例方法列表
    struct objc_method_list *class_methods;// 类方法列表
    struct objc_protocol_list *protocols;// 分类所实现的协议列表
};
/**
 *  这个结构体主要包含了分类定义的实例方法与类方法，其中instance_methods列表是objc_class中方法列表的一个子集，而class_methods列表是元类方法列表的一个子集。
 */


OBJC_ROOT_CLASS
OBJC_EXPORT
@interface YYRootClass

@end

@implementation YYRootClass



@end


















