//
//  WeakDemo.m
//  ObjcSum
//
//  Created by yangyuan on 2017/3/28.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "WeakDemo.h"

/*
 1. weak 实现原理的概括
 
 Runtime维护了一个weak表，用于存储指向某个对象的所有weak指针。weak表其实是一个hash（哈希）表，Key是所指对象的地址，Value是weak指针的地址（这个地址的值是所指对象指针的地址）数组。
 */

/*
 2. weak 的实现原理可以概括一下三步：
 
 1、初始化时：runtime会调用objc_initWeak函数，初始化一个新的weak指针指向对象的地址。
 
 2、添加引用时：objc_initWeak函数会调用 objc_storeWeak() 函数， objc_storeWeak() 的作用是更新指针指向，创建对应的弱引用表。
 
 3、释放时，调用clearDeallocating函数。clearDeallocating函数首先根据对象地址获取所有weak指针地址的数组，然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录。

 */
@implementation WeakDemo

#pragma mark - 详解

- (void)weakDemo {
    NSObject *obj = [NSObject new];
    
    /*
     1. 当我们初始化一个weak变量时，runtime会调用 NSObject.mm 中的objc_initWeak函数。
     这个函数在Clang中的声明如下： id objc_initWeak(id *object, id value);
     */
    __weak id obj1 = obj;
    if (obj1) {
    }
    
    /*
     2、添加引用时：objc_initWeak函数会调用 objc_storeWeak() 函数， 
     objc_storeWeak() 的作用是更新指针指向，创建对应的弱引用表。
     */
    
    /*
     3、释放时，调用clearDeallocating函数。
     clearDeallocating函数首先根据对象地址获取所有weak指针地址的数组，然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录。
     
     看了objc-weak.mm的源码就明白了：其实Weak表是一个hash（哈希）表，然后里面的key是指向对象的地址，Value是Weak指针的地址的数组。
     */
}

@end


#pragma mark - objc_initWeak实现
//id yy_objc_initWeak(id *location, id newObj) {
//    // 查看对象实例是否有效
//    // 无效对象直接导致指针释放
//    if (!newObj) {
//        *location = nil;
//        return nil;
//    }
//    // 这里传递了三个 bool 数值
//    // 使用 template 进行常量参数传递是为了优化性能
//    return storeWeak,false/*old*/, true/*new*/, true/*crash*/>
//    (location, (objc_object*)newObj);
//}
/*
 这个函数仅仅是一个深层函数的调用入口，而一般的入口函数中，都会做一些简单的判断（例如 objc_msgSend 中的缓存判断），这里判断了其指针指向的类对象是否有效，无效直接释放，不再往深层调用函数。
 否则，object将被注册为一个指向value的__weak对象。而这事应该是objc_storeWeak函数干的。
 */

#pragma mark - objc_storeWeak

// HaveOld:     true - 变量有值
//             false - 需要被及时清理，当前值可能为 nil
// HaveNew:     true - 需要被分配的新值，当前值可能为 nil
//             false - 不需要分配新值
// CrashIfDeallocating: true - 说明 newObj 已经释放或者 newObj 不支持弱引用，该过程需要暂停
//             false - 用 nil 替代存储
//template bool HaveOld, bool HaveNew, bool CrashIfDeallocating>
//static id storeWeak(id *location, objc_object *newObj) {
//    // 该过程用来更新弱引用指针的指向
//    // 初始化 previouslyInitializedClass 指针
//    Class previouslyInitializedClass = nil;
//    id oldObj;
//    // 声明两个 SideTable
//    // ① 新旧散列创建
//    SideTable *oldTable;
//    SideTable *newTable;
//    // 获得新值和旧值的锁存位置（用地址作为唯一标示）
//    // 通过地址来建立索引标志，防止桶重复
//    // 下面指向的操作会改变旧值
//retry:
//    if (HaveOld) {
//        // 更改指针，获得以 oldObj 为索引所存储的值地址
//        oldObj = *location;
//        oldTable = &SideTables()[oldObj];
//    } else {
//        oldTable = nil;
//    }
//    if (HaveNew) {
//        // 更改新值指针，获得以 newObj 为索引所存储的值地址
//        newTable = &SideTables()[newObj];
//    } else {
//        newTable = nil;
//    }
//    // 加锁操作，防止多线程中竞争冲突
//    SideTable::lockTwoHaveOld, HaveNew>(oldTable, newTable);
//    // 避免线程冲突重处理
//    // location 应该与 oldObj 保持一致，如果不同，说明当前的 location 已经处理过 oldObj 可是又被其他线程所修改
//    if (HaveOld  &&  *location != oldObj) {
//        SideTable::unlockTwoHaveOld, HaveNew>(oldTable, newTable);
//        goto retry;
//    }
//    // 防止弱引用间死锁
//    // 并且通过 +initialize 初始化构造器保证所有弱引用的 isa 非空指向
//    if (HaveNew  &&  newObj) {
//        // 获得新对象的 isa 指针
//        Class cls = newObj->getIsa();
//        // 判断 isa 非空且已经初始化
//        if (cls != previouslyInitializedClass  &&
//            !((objc_class *)cls)->isInitialized()) {
//            // 解锁
//            SideTable::unlockTwoHaveOld, HaveNew>(oldTable, newTable);
//            // 对其 isa 指针进行初始化
//            _class_initialize(_class_getNonMetaClass(cls, (id)newObj));
//            // 如果该类已经完成执行 +initialize 方法是最理想情况
//            // 如果该类 +initialize 在线程中
//            // 例如 +initialize 正在调用 storeWeak 方法
//            // 需要手动对其增加保护策略，并设置 previouslyInitializedClass 指针进行标记
//            previouslyInitializedClass = cls;
//            // 重新尝试
//            goto retry;
//        }
//    }
//    // ② 清除旧值
//    if (HaveOld) {
//        weak_unregister_no_lock(&oldTable->weak_table, oldObj, location);
//    }
//    // ③ 分配新值
//    if (HaveNew) {
//        newObj = (objc_object *)weak_register_no_lock(&newTable->weak_table,
//                                                      (id)newObj, location,
//                                                      CrashIfDeallocating);
//        // 如果弱引用被释放 weak_register_no_lock 方法返回 nil
//        // 在引用计数表中设置若引用标记位
//        if (newObj  &&  !newObj->isTaggedPointer()) {
//            // 弱引用位初始化操作
//            // 引用计数那张散列表的weak引用对象的引用计数中标识为weak引用
//            newObj->setWeaklyReferenced_nolock();
//        }
//        // 之前不要设置 location 对象，这里需要更改指针指向
//        *location = (id)newObj;
//    }
//    else {
//        // 没有新值，则无需更改
//    }
//    SideTable::unlockTwoHaveOld, HaveNew>(oldTable, newTable);
//    return (id)newObj;
//}





























