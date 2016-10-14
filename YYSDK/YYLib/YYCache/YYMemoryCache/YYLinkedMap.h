//
//  YYLinkedMap.h
//  ObjcSum
//
//  Created by sihuan on 15/12/2.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYLinkedMapNode : NSObject {
    @public
    __weak YYLinkedMapNode *_prev; // retained by dic
    __weak YYLinkedMapNode *_next; // retained by dic
    id _key;
    id _value;
    NSUInteger _cost;
    NSTimeInterval _time;
}

@end

/**
 *  It's not thread-safe and does not validate the parameters.
 */
@interface YYLinkedMap : NSObject{
    @public
    NSMutableDictionary *_dict; // do not set object directly
    NSUInteger _totalCost;
    NSUInteger _totalCount;
    YYLinkedMapNode *_head; // MRU, do not change it directly
    YYLinkedMapNode *_tail; // LRU, do not change it directly
    BOOL _releaseOnMainThread;
    BOOL _releaseAsynchronously;
}


@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) YYLinkedMapNode *head;
@property (nonatomic, strong) YYLinkedMapNode *tail;
@property (nonatomic, assign) NSUInteger totalCost;
@property (nonatomic, assign) NSUInteger totalCount;
@property (nonatomic, assign) BOOL releaseOnMainThread;
@property (nonatomic, assign) BOOL releaseAsynchronously;

/**
 *  Insert a node at head and update the total cost.
 *  Node and node.key should not be nil.
 */
- (void)insertNodeAtHead:(YYLinkedMapNode *)node;

/**
 *  Bring a inner node to header.
 *  Node should already inside the dic.
 */
- (void)bringNodeToHead:(YYLinkedMapNode *)node;

- (void)removeNode:(YYLinkedMapNode *)node;

- (YYLinkedMapNode *)removeTailNode;

- (void)removeAll;

@end
