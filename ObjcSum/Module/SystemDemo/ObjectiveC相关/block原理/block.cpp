//
//  block.cpp
//  ObjcSum
//
//  Created by sihuan on 16/5/9.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#include <stdio.h>
#include <Block.h>




/**
 isa指针，如果我们对runtime了解的话，就明白isa指向Class的指针。 这里保存block的类型isa（如&_NSConcreteGlobalBlock）
 flags，当block被copy时，应该执行的操作
 reserved为保留字段
 funcPtr指针，指向block内的函数实现
 */
typedef struct blockImp {
    void *isa;
    int flags;
    int reserved;
    void *funcPtr;
} BlockImp;


typedef struct testBlockImpl {
    blockImp impl;
    struct testBlockDesc *desc;
    testBlockImpl(void *fp, struct testBlockDesc *_desc, int flags = 0) {
        //注：clang转换的代码和真实运行时有区别。应该为impl.isa = &_NSConcreteGlobalBlock
//        impl.isa = &_NSConcreteStackBlock;
        impl.isa = &_NSConcreteGlobalBlock;
        impl.flags = flags;
        impl.funcPtr = fp;
        desc = _desc;
    }
} TestBlockImpl;

/**
 reserved为保留字段默认为0
 blockSize为sizeof(struct testBlockImpl)，用来表示block所占内存大小。因为没有持有变量，block大小为impl的大小加上Desc指针大小
 
 testBlockDescData为testBlockDesc的一个结构体实例
 这个结构体，用来描述block的大小等信息。如果持有可修改的捕获变量时（即加__block），会增加两个函数（copy和dispose），我们后面会分析
 */
static struct testBlockDesc {
    size_t reserved;
    size_t blockSize;
}testBlockDescData = { 0, sizeof(struct testBlockImpl)} ;

static void testBlockFunc(struct testBlockImpl *cself) {
    printf("This is a block.");
}

//1. 最简单的block，不持有变量
void test() {
    void (^blk)(void) = ^() {
    };
    blk();
//    转换如下：
    
    /**
     *  我们可以看到，block其实就是指向testBlockImpl的结构体指针，这个结构体包含两个testBlockImpl和testBlockDescData两个结构体，和一个方法。
     */
//    void (*blk)(void) = &testBlockImpl(testBlockFunc, &testBlockDescData);
//    blk->funcPtr(blk);
}


//2. 持有变量的block begin
typedef struct test2BlockImpl {
    blockImp impl;
    struct testBlockDesc *desc;
    int i;//结构体多了一个变量i。这个变量用来保存test2函数的变量i。
    test2BlockImpl(void *fp, struct testBlockDesc *_desc, int _i, int flags = 0): i(_i) {
        //注：clang转换的代码和真实运行时有区别。应该为impl.isa = &_NSConcreteGlobalBlock
        //        impl.isa = &_NSConcreteStackBlock;
        impl.isa = &_NSConcreteGlobalBlock;
        impl.flags = flags;
        impl.funcPtr = fp;
        desc = _desc;
    }
} Test2BlockImpl;


static void test2BlockFunc(Test2BlockImpl *cself) {
    //在执行block时，取出的i为test2BlockImpl保存的值，这两个变量不是同一个。这就是为什么我们执行了i++操作，再执行block，i的值仍然不变的原因
    int i = cself->i;// bound by copy
    printf("i=%d", i);
}

//2. 持有变量的block END
void test2() {
    int i = 4;
    void (^blk)(void) = ^(){printf("i = %d", i);};
    i++;
    blk();
}


//3. 可修改持有变量的block BEGIN

//新增了结构体blockByRefi0，来保存变量值。

/**
 __isa指向变量Class
 ____forwarding，指向自己的指针，当从栈copy到堆时，指向堆上的block
 __flags，当block被copy时，标识被捕获的对象，该执行的操作
 __size，结构体大小
 i，持有的变量
 */
typedef struct blockByRefi0 {
    void *isa;
    struct blockByRefi0 *forwarding;
    int flags;
    int size;
    int i;
} BlockByRefi0;

typedef struct test3BlockImpl {
    blockImp impl;
    struct testBlockDesc *desc;
    BlockByRefi0 *i;//结构体多了一个变量i。这个变量用来保存test2函数的变量i。
    test3BlockImpl(void *fp, struct testBlockDesc *_desc, BlockByRefi0 *_i, int flags = 0): i(_i->forwarding) {
        //注：clang转换的代码和真实运行时有区别。应该为impl.isa = &_NSConcreteGlobalBlock
        //        impl.isa = &_NSConcreteStackBlock;
        impl.isa = &_NSConcreteGlobalBlock;
        impl.flags = flags;
        impl.funcPtr = fp;
        desc = _desc;
    }
} Test3BlockImpl;

//i++; blk();的转化
static void test3BlockFunc(Test3BlockImpl *cself) {
    blockByRefi0 *i = cself->i;
    (i->forwarding->i)++;
    printf("i=%d", (i->forwarding->i));
}

static void test3BlockCopy(struct test3BlockImpl* dst, struct test3BlockImpl*src) {
    _Block_object_assign((void*)&dst->i, (void*)src->i, 8/*BLOCK_FIELD_IS_BYREF*/);
}

static void test3BlockDispose(struct test3BlockImpl*src) {
    _Block_object_dispose((void*)src->i, 8/*BLOCK_FIELD_IS_BYREF*/);
}

static struct test3BlockDesc {
    size_t reserved;
    size_t blockSize;
    void (*copy)(struct test3BlockImpl* dst, struct test3BlockImpl*src);
    void (*dispose)(struct test3BlockImpl*src);
}test3BlockDescData = { 0, sizeof(struct test3BlockImpl), test3BlockCopy, test3BlockDispose} ;

void test3(){
    __block int i = 4;
    void (^blk)(void) = ^(){printf("i = %d", i);};
    i++;
    blk();
    
    
    //    int i = 4被转化成如下代码。它被转化成结构体blockByRefi0。blockByRefi0持有变量i。
    blockByRefi0 i1 = { (void*)0, (blockByRefi0 *)&i, 0, sizeof(blockByRefi0), 4 };

    i++; blk();//也转化成对blockByRefi0中的变量i进行++运算
    
    
}


//Block_copy(...)的实现

/**
 根据Block.h上显示，Block_copy(...)被定义如下：
 
 #define Block_copy(...) ((__typeof(__VA_ARGS__))_Block_copy((const void *)(__VA_ARGS__)))
 _Block_copy被声明在runtime.c中，对应实现：
 
 void *_Block_copy(const void *arg) {
 return _Block_copy_internal(arg, WANTS_ONE);
 }
 */

//该方法调用了

/**
  Copy, or bump refcount, of a block.  If really copying, call the copy helper if present. 
static void *_Block_copy_internal(const void *arg, const int flags) {
    struct Block_layout *aBlock;
    ...
    if (aBlock->flags & BLOCK_NEEDS_FREE) {
        // latches on high
        latching_incr_int(&aBlock->flags);
        return aBlock;
    }
    else if (aBlock->flags & BLOCK_IS_GLOBAL) {
        return aBlock;
    }
    
    // Its a stack block.  Make a copy.
    struct Block_layout *result = malloc(aBlock->descriptor->size);
    if (!result) return (void *)0;
    memmove(result, aBlock, aBlock->descriptor->size); // bitcopy first
    // reset refcount
    result->flags &= ~(BLOCK_REFCOUNT_MASK);    // XXX not needed
    result->flags |= BLOCK_NEEDS_FREE | 1;
    result->isa = _NSConcreteMallocBlock;
    if (result->flags & BLOCK_HAS_COPY_DISPOSE) {
        //printf("calling block copy helper %p(%p, %p)...\n", aBlock->descriptor->copy, result, aBlock);
        (*aBlock->descriptor->copy)(result, aBlock); // do fixup
        return result;
    }
}
当原始block在堆上时，引用计数+1。当为全局block时，copy不做任何操作

// Its a stack block.  Make a copy.
struct Block_layout *result = malloc(aBlock->descriptor->size);
if (!result) return (void *)0;
memmove(result, aBlock, aBlock->descriptor->size); // bitcopy first
// reset refcount
result->flags &= ~(BLOCK_REFCOUNT_MASK);    // XXX not needed
result->flags |= BLOCK_NEEDS_FREE | 1;
result->isa = _NSConcreteMallocBlock;
if (result->flags & BLOCK_HAS_COPY_DISPOSE) {
    //printf("calling block copy helper %p(%p, %p)...\n", aBlock->descriptor->copy, result, aBlock);
    (*aBlock->descriptor->copy)(result, aBlock); // do fixup
}
 */

//当block在栈上时，调用Block_copy，block将被copy到堆上。如果block实现了copy和dispose方法，则调用对应的方法，来处理捕获的变量。













