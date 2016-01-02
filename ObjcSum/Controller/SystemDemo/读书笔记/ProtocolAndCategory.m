//
//  ProtocolAndCategory.m
//  ObjcSum
//
//  Created by sihuan on 15/12/31.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "ProtocolAndCategory.h"

#pragma mark - class-continuation分类

@interface ProtocolAndCategory () {
    struct {
        int didResponseDelegate1:1;
        int didResponseDelegate2:1;
        int didResponseDelegate3:1;
    }_delegateFlags;
}

@end

@implementation ProtocolAndCategory

/**
 *  有必要的话，可以使用含有位段的结构体，将委托对象是否能响应相关协议方法缓存起来，如下
 */
- (void)setDelegate:(id<ProtocolAndCategoryDelegate>)delegate {
    _delegate = delegate;
    _delegateFlags.didResponseDelegate2 = [delegate respondsToSelector:@selector(protocolAndCategoryDelegate1)];
    _delegateFlags.didResponseDelegate2 = [delegate respondsToSelector:@selector(protocolAndCategoryDelegate2)];
    _delegateFlags.didResponseDelegate3 = [delegate respondsToSelector:@selector(protocolAndCategoryDelegate3)];
}

/**
 *  调用delegate相关方法就不用每次都用respondsToSelector:判断，
 可以提高效率
 */
- (void)response {
    if (_delegateFlags.didResponseDelegate1) {
        [_delegate protocolAndCategoryDelegate1];
    }
    if (_delegateFlags.didResponseDelegate2) {
        [_delegate protocolAndCategoryDelegate2];
    }
    if (_delegateFlags.didResponseDelegate3) {
        [_delegate protocolAndCategoryDelegate3];
    }
}


@end
