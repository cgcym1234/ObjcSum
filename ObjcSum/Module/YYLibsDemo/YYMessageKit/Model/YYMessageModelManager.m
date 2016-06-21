//
//  YYMessageModelManager.m
//  ObjcSum
//
//  Created by sihuan on 16/1/13.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYMessageModelManager.h"

@interface YYMessageModelManager ()

@property (nonatomic, strong) NSMutableArray *messageModelArray;
@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end

@implementation YYMessageModelManager

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        _serialQueue = dispatch_queue_create("YYMessageModelManager", DISPATCH_QUEUE_SERIAL);
        _messageModelArray = [NSMutableArray new];
    }
    return self;
}

- (NSInteger)count {
    __block NSInteger count = 0;
    dispatch_sync(_serialQueue, ^{
        count = _messageModelArray.count;
    });
    return count;
}

- (void)addMessage:(YYMessage *)message {
    dispatch_sync(_serialQueue, ^{
        [_messageModelArray addObject:[YYMessageModel modelWithMessage:message]];
    });
}

- (void)removeMessage:(YYMessage *)message {
    
}
- (void)removeMessageAtIndex:(NSInteger)index {
    dispatch_sync(_serialQueue, ^{
        if (index >= 0 && index < _messageModelArray.count) {
            [_messageModelArray removeObjectAtIndex:index];
        }
    });
}
- (void)removeAllMessages {
    dispatch_sync(_serialQueue, ^{
        [_messageModelArray removeAllObjects];
    });
}

- (void)sortMessagesByTime {
    dispatch_sync(_serialQueue, ^{
    });
}

- (YYMessageModel *)messageModelAtIndex:(NSInteger)index {
    __block YYMessageModel *model = nil;
    dispatch_sync(_serialQueue, ^{
        if (index >= 0 && index < _messageModelArray.count) {
            model = _messageModelArray[index];
        }
    });
    return model;
}

- (YYMessageModel *)messageModelFirst {
    __block YYMessageModel *model = nil;
    dispatch_sync(_serialQueue, ^{
        if (_messageModelArray.count > 0) {
            model = _messageModelArray[0];
        }
    });
    return model;
}

- (YYMessageModel *)messageModelLast {
    __block YYMessageModel *model = nil;
    dispatch_sync(_serialQueue, ^{
        if (_messageModelArray.count > 0) {
            model = _messageModelArray[_messageModelArray.count - 1];
        }
    });
    return model;
}

/**
 *  刷新model中缓存的布局信息
 */
- (void)refreshMessageModelLayoutWidth:(CGFloat)width {
    dispatch_sync(_serialQueue, ^{
        [_messageModelArray enumerateObjectsUsingBlock:^(YYMessageModel *messageMoel, NSUInteger idx, BOOL * _Nonnull stop) {
            [messageMoel cleanCacheLayout];
            [messageMoel calculateSizeInWidth:width];
        }];
    });
}

@end
