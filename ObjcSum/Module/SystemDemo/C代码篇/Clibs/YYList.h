//
//  YYList.h
//  MySimpleFrame
//
//  Created by sihuan on 15/3/19.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#ifndef __MySimpleFrame__YYList__
#define __MySimpleFrame__YYList__

#include <stdio.h>

#include <stdio.h>
#include "YYDefine.h"

#pragma mark - /* YYListNode结点 */
typedef struct YYListNode {
    struct YYListNode *prev;
    struct YYListNode *next;
    void *value;
} YYListNode;

#pragma mark /* YYList迭代器，只能为单向 */
typedef struct YYListIter {
    YYListNode *next;
    int direction;
} YYListIter;

/* 定义2个迭代方向，从头部开始往尾部，第二个从尾部开始向头部 */
#define YYListStartHead 0
#define YYListStartTail 1

#pragma mark /* YYList链表 */
typedef struct YYList {
    YYListNode *head;
    YYListNode *tail;
    
    /* 下面3个方法为所有结点公用的方法，分别在相应情况下回调用 */
    void *(*dup)(void *ptr);
    void *(*free)(void *ptr);
    void *(*match)(void *ptr, void *key);
    
    //列表长度
    unsigned long len;
} YYList;

#pragma mark - /* 宏定义了一些基本操作 */

#define YYListLength(l) ((l)->len)   //获取YYList长度
#define YYListFirst(l) ((l)->head)   //获取列表首部
#define YYListLast(l) ((l)->tail)    //获取列表尾部
#define YYListPrevNode(n) ((n)->prev)  //给定结点的上一结点
#define YYListNextNode(n) ((n)->next)  //给定结点的下一节点
#define YYListNodeValue(n) ((n)->value) //给点的结点的值，这个value不是一个数值类型，而是一个指针

#define YYListSetDupMethod(l,m) ((l)->dup = (m))  //列表的复制方法的设置
#define YYListSetFreeMethod(l,m) ((l)->free = (m)) //列表的释放方法的设置
#define YYListSetMatchMethod(l,m) ((l)->match = (m)) //列表的匹配方法的设置

#define YYListGetDupMethod(l) ((l)->dup) //列表的复制方法的获取
#define YYListGetFree(l) ((l)->free)     //列表的释放方法的获取
#define YYListGetMatchMethod(l) ((l)->match) //列表的匹配方法的获取

#pragma mark - /* 定义了方法的原型 */
YYList *yyListCreate();                                     //创建YYList列表

void yyListConfig(YYList *);

void yyListRelease(YYList *list);                             //列表的释放

YYList *yyListAddNodeHead(YYList *list, void *value);         //添加列表头结点
YYList *yyListAddNodeTail(YYList *list, void *value);         //添加列表尾结点

YYList *yyListInsertNode(YYList *list, YYListNode *oldNode, void *value, int flag); /* 在old_node结点的前面或后面插入新结点 */
void yyListDelNode(YYList *list, YYListNode *node);          //列表上删除给定的结点

YYListIter *yyListGetIterator(YYList *list, int directon);    //获取列表给定方向上的迭代器
void yyListReleaseIterator(YYListIter *iter);              //释放列表迭代器
YYListNode *yyListNext(YYListIter *iter);                     //获取迭代器内的下一结点

YYList *yyListDup(YYList *orig);                              //列表的复制
YYListNode *yyListSearchKey(YYList *list, void *key);         //关键字搜索具体结点
YYListNode *yyListIndex(YYList *list, long index);            //下标索引具体的结点
void yyListRewind(YYList *list, YYListIter *li);              // 重置迭代器为方向从头开始
void yyListRewindTail(YYList *list, YYListIter *li);          //重置迭代器为方向从尾部开始
void yyListRotate(YYList *list);                            //rotate操作其实就是把尾部结点挪到头部，原本倒数第二个结点变为尾部结点

#endif /* defined(__MySimpleFrame__YYYYList__) */
