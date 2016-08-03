//
//  YYYYList.c
//  MySimpleFrame
//
//  Created by sihuan on 15/3/19.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#include "YYList.h"

#include "YYList.h"
#include <malloc/malloc.h>
#include <stdlib.h>

//创建YYList列表
YYList *yyListCreate() {
    YYList *list = malloc(sizeof(YYList));
    if (list != Null) {
        yyListConfig(list);
    }
    return list;
}

void yyListConfig(YYList *list) {
    list->head = list->tail = Null;
    list->len = 0;
    list->dup = Null;
    list->free = Null;
    list->match = Null;
}

//列表的释放
void yyListRelease(YYList *list) {
    unsigned long len;
    YYListNode *current, *next;
    
    current = list->head;
    len = list->len;
    
    while (len--) {
        next = current->next;
        //如果列表有free释放方法定义，每个结点都必须调用自己内部的value方法
        if (list->free) {
            list->free(current->value);
        }
        free(current);
        current = next;
    }
    free(list);
}

//添加列表头结点
YYList *yyListAddNodeHead(YYList *list, void *value) {
    //定义新的YYListNode，并赋值指针
    YYListNode *node = malloc(sizeof(YYListNode));
    if (node == Null) {
        return Null;
    }
    node->value = value;
    if (list->len == 0) {
        //当此时没有任何结点时，头尾结点是同一个结点，前后指针为NULL
        list->head = list->tail = node;
        node->prev = node->next = Null;
    } else {
        //设置此结点next与前头结点的位置关系
        node->prev = Null;
        node->next = list->head;
        list->head->prev = node;
        list->head = node;
    }
    
    list->len++;
    return list;
}

//添加列表尾结点
YYList *yyListAddNodeTail(YYList *list, void *value) {
    //定义新的YYListNode，并赋值指针
    YYListNode *node = malloc(sizeof(YYListNode));
    if (node == Null) {
        return Null;
    }
    node->value = value;
    if (list->len == 0) {
        //当此时没有任何结点时，头尾结点是同一个结点，前后指针为NULL
        list->head = list->tail = node;
        node->prev = node->next = Null;
    } else {
        //设置此结点next与前头结点的位置关系
        node->prev = list->tail;
        node->next = Null;
        list->tail->next = node;
        list->tail = node;
    }
    
    list->len++;
    return list;
}

//某位置上插入及结点
YYList *yyListInsertNode(YYList *list, YYListNode *oldNode, void *value, int after) {
    //定义新的YYListNode，并赋值指针
    YYListNode *node = malloc(sizeof(YYListNode));
    if (node == Null) {
        return Null;
    }
    node->value = value;
    
    //如果是在目标结点的后面插入的情况，将新结点的next指针指向老结点的next
    if (after) {
        node->prev = oldNode;
        node->next = oldNode->next;
        //oldNode->next = node;
        if (list->tail == oldNode) {
            list->tail = node;
        }
    } else {
        //如果是在目标结点的前面插入的情况，将新结点的preview指针指向老结点的preview
        node->next = oldNode;
        node->prev = oldNode->prev;
        //oldNode->prev = node;
        if (list->head == oldNode) {
            list->head = node;
        }
    }
    
    //检查Node的前后结点还有没有未连接的操作
    if (node->prev != NULL) {
        node->prev->next = node;
    }
    if (node->next != NULL) {
        node->next->prev = node;
    }
    list->len++;
    return list;
    
}

//列表上删除给定的结点
void yyListDelNode(YYList *list, YYListNode *node) {
    if (node->prev) {
        //如果结点prev结点存在，prev的结点的下一及诶单指向Node的next结点
        node->prev = node->next;
    } else {
        //如果不存在说明是被删除的是头结点，则重新赋值Node的next为新头结点
        list->head = node->next;
    }
    
    if (node->next) {
        node->next->prev = node->prev;
    } else {
        list->tail = node->prev;
    }
    
    if (list->free) {
        list->free(node->value);
    }
    free(node);
    list->len--;
    
}

//获取列表给定方向上的迭代器
YYListIter *yyListGetIterator(YYList *list, int direction) {
    YYListIter *iter = malloc(sizeof(YYListIter));
    if (iter == Null) {
        return Null;
    }
    
    //如果方向定义的是从头开始，则迭代器的next指针指向列表头结点
    if (direction == YYListStartHead) {
        iter->next = list->head;
    } else {
        iter->next = list->tail;
    }
    
    iter->direction = direction;
    return iter;
}

//释放列表迭代器
void yyListReleaseIterator(YYListIter *iter) {
    free(iter);
}

//获取迭代器内的下一结点
YYListNode *yyListNext(YYListIter *iter) {
    //获取当前迭代器的当前结点
    YYListNode *node = iter->next;
    if (node != Null) {
        if (iter->direction == YYListStartHead) {
            iter->next = node->next;
        } else {
            iter->next = node->prev;
        }
    }
    return node;
}

//列表的复制
YYList *yyListDup(YYList *orig) {
    YYList *copy;
    YYListIter *iter;
    YYListNode *node;
    
    if ((copy = yyListCreate()) == Null) {
        return Null;
    }
    copy->dup = orig->dup;
    copy->free = orig->free;
    copy->match = orig->match;
    
    iter = yyListGetIterator(orig, YYListStartHead);
    while ((node = yyListNext(iter)) != Null) {
        void *value;
        //如果定义了列表复制方法，则调用dup方法
        if (copy->dup) {
            value = copy->dup(node->value);
            if (value == Null) {
                //如果发生OOM内存溢出问题，直接释放所有空间
                yyListRelease(copy);
                yyListReleaseIterator(iter);
                return Null;
            }
        } else {
            value = node->value;
        }
        
        if (yyListAddNodeTail(copy, value) == Null) {
            yyListRelease(copy);
            yyListReleaseIterator(iter);
            return Null;
        }
    }
    
    //最后释放迭代器
    yyListReleaseIterator(iter);
    return copy;
    
}

/* 关键字搜索Node结点此时用到了YYList的match方法了 */
YYListNode *yyListSearchKey(YYList *list, void *key) {
    YYListIter *iter;
    YYListNode *node;
    
    iter = yyListGetIterator(list, YYListStartHead);
    while ((node = yyListNext(iter)) != Null) {
        if (list->match) {
            //如果定义了YYList的match方法，则调用match方法
            if (list->match(node->value, key)) {
                //如果方法返回true，则代表找到结点，释放迭代器
                yyListReleaseIterator(iter);
                return node;
            }
        } else {
            //如果没有定义YYList 的match方法，则直接比较指针
            if (key == node->value) {
                yyListReleaseIterator(iter);
                return node;
            }
        }
    }
    yyListReleaseIterator(iter);
    return NULL;
}

/* 根据下标值返回相应的结点*/
/*下标有2种表示形式，从头往后一次0， 1， 2，...从后往前是 ...-3， -2， -1.-1为最后一个结点*/
YYListNode *yyListIndex(YYList *list, long index) {
    YYListNode *node;
    
    if (index < 0) {
        //如果index为负数，则从后往前数
        index = (-index)-1;
        node = list->tail;
        while (index-- && node) {
            node = node->prev;
        }
    } else {
        node = list->head;
        while (index-- && node) {
            node = node->next;
        }
    }
    return node;
}

// 重置迭代器为方向从头开始
void yyListRewind(YYList *list, YYListIter *li) {
    li->next = list->head;
    li->direction = YYListStartHead;
}
//重置迭代器为方向从尾部开始
void yyListRewindTail(YYList *list, YYListIter *li) {
    li->next = list->tail;
    li->direction = YYListStartTail;
}

/* rotate操作其实就是把尾部结点挪到头部，原本倒数第二个结点变为尾部结点 */
void YYListRotate(YYList *list) {
    if (YYListLength(list) <= 1) {
        return;
    }
    
    //替换新的尾部结点，原结点后挪一个位置
    YYListNode *tail = list->tail;
    list->tail = tail->prev;
    list->tail->next = Null;
    
    /* 把原来的尾节点改成头结点 */
    list->head->prev = tail;
    tail->prev = Null;
    tail->next = list->head;
    list->head = tail;
}
