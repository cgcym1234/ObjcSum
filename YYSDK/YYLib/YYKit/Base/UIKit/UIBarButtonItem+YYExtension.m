//
//  UIBarButtonItem+YYExtension.m
//  ObjcSum
//
//  Created by sihuan on 15/12/14.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "UIBarButtonItem+YYExtension.h"
#import "UIControl+YYExtension.h"
#import <objc/runtime.h>

static const int block_key;

@implementation UIBarButtonItem (YYExtension)

- (void)setActionBlock:(void (^)(id sender))block {
    YYControlBlockTarget *target = [[YYControlBlockTarget alloc] initWithBlock:block];
    objc_setAssociatedObject(self, &block_key, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTarget:target];
    [self setAction:@selector(invoke:)];
}

- (void (^)(id)) actionBlock {
    YYControlBlockTarget *target = objc_getAssociatedObject(self, &block_key);
    return target.block;
}


@end
