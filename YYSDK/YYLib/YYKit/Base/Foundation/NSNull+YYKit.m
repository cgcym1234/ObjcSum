//
//  NSNull+YYKit.m
//  ObjcSum
//
//  Created by sihuan on 16/3/25.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "NSNull+YYKit.h"

@implementation NSNull (YYKit)

/*
 对NSNull的unrecognized selector，运用 runtime 的知识，在forwarding时，对无法识别的selector，不抛出异常。
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [NSMethodSignature signatureWithObjCTypes:@encode(void)];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}

@end
