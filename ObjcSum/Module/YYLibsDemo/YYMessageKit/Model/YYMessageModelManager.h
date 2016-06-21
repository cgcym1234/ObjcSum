//
//  YYMessageModelManager.h
//  ObjcSum
//
//  Created by sihuan on 16/1/13.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYMessageModel.h"

@interface YYMessageModelManager : NSObject


#pragma mark - 线程安全的数据操作

- (NSInteger)count;

- (void)addMessage:(YYMessage *)message;

- (void)removeMessage:(YYMessage *)message;
- (void)removeMessageAtIndex:(NSInteger)index;
- (void)removeAllMessages;

- (void)sortMessagesByTime;

- (YYMessageModel *)messageModelAtIndex:(NSInteger)index;
- (YYMessageModel *)messageModelFirst;
- (YYMessageModel *)messageModelLast;

/**
 *  刷新model中缓存的布局信息
 */
- (void)refreshMessageModelLayoutWidth:(CGFloat)width;

@end
