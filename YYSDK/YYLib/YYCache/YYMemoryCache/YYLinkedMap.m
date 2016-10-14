//
//  YYLinkedMap.m
//  ObjcSum
//
//  Created by sihuan on 15/12/2.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "YYLinkedMap.h"


@interface YYLinkedMapNode () 

//@property (nonatomic, weak) YYLinkedMapNode *prev;
//@property (nonatomic, weak) YYLinkedMapNode *next;
//@property (nonatomic, strong) id key;
//@property (nonatomic, strong) id value;
//@property (nonatomic, assign) NSUInteger cost;
//@property (nonatomic, assign) NSTimeInterval time;


@end


@implementation YYLinkedMapNode

@end


@implementation YYLinkedMap

- (instancetype)init {
    if (self = [super init]) {
        _dict = [NSMutableDictionary dictionary];
        _releaseOnMainThread = NO;
        _releaseAsynchronously = YES;
    }
    return self;
}

#pragma mark - Public

/**
 *  Insert a node at head and update the total cost.
 *  Node and node.key should not be nil.
 */
- (void)insertNodeAtHead:(YYLinkedMapNode *)node {
    [_dict setObject:node forKey:node->_key];
    _totalCost += node->_cost;
    _totalCount++;
    if (_head) {
        node->_next = _head;
        _head->_prev = node;
        _head = node;
    } else {
        _head = _tail = node;
    }
}

/**
 *  Bring a inner node to header.
 *  Node should already inside the dic.
 */
- (void)bringNodeToHead:(YYLinkedMapNode *)node {
    if (_head == node) {
        return;
    }
    
    if (_tail == node) {
        _tail = node->_prev;
        node->_prev = nil;
    } else {
        node->_next->_prev = node->_prev;
        node->_prev->_next = node->_next;
    }
    node->_next = _head;
    node->_prev = nil;
    _head->_prev = node;
    _head = node;
}

- (void)removeNode:(YYLinkedMapNode *)node {
    [_dict removeObjectForKey:node->_key];
    _totalCost -= node->_cost;
    _totalCount--;
    
    if (node->_next) node->_next->_prev = node->_prev;
    if (node->_prev) node->_prev->_next = node->_next;
    if (_head == node) _head = node->_next;
    if (_tail == node) _tail = node->_prev;
}

- (YYLinkedMapNode *)removeTailNode {
    if (!_tail) {
        return nil;
    }
    
    YYLinkedMapNode *tail = _tail;
    [self removeNode:_tail];
    return tail;
}

- (void)removeAll {
    _totalCost = 0;
    _totalCount = 0;
    _head = nil;
    _tail = nil;
    
    if (_dict.count > 0) {
        if (_releaseAsynchronously) {
            dispatch_queue_t queue = _releaseOnMainThread ? dispatch_get_main_queue() : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            dispatch_async(queue, ^{
                [_dict removeAllObjects];
                _dict = nil;
            });
        } else if (_releaseOnMainThread) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_dict removeAllObjects];
                _dict = nil;
            });
        } else {
            [_dict removeAllObjects];
            _dict = nil;
        }
    }
}

@end
















