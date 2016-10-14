//
//  UIView+YYChrysanthemum.m
//  ObjcSum
//
//  Created by sihuan on 15/12/16.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "UIView+YYChrysanthemum.h"
#import <objc/runtime.h>

static char YYChrysanthemumKey;

@implementation UIView (YYChrysanthemum)

- (YYChrysanthemum *)yyChrysanthemumShow {
    return [self yyChrysanthemumShowInView:self];
}
- (YYChrysanthemum *)yyChrysanthemumShowInView:(UIView *)superView {
    return [self yyChrysanthemumShowInView:superView wrapInteraction:NO dim:NO];
}

/*
 显示一个转圈的小菊花
 */
- (YYChrysanthemum *)yyChrysanthemumShowInView:(UIView *)superView wrapInteraction:(BOOL)wrapInteraction dim:(BOOL)dim {
    YYChrysanthemum *view = objc_getAssociatedObject(self, &YYChrysanthemumKey);
    if (!view) {
        view = [[YYChrysanthemum alloc] init];
        objc_setAssociatedObject(self, &YYChrysanthemumKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [view showInView:superView wrapInteraction:wrapInteraction dim:dim];
    return view;
}

- (void)yyChrysanthemumDismiss {
    YYChrysanthemum *view = objc_getAssociatedObject(self, &YYChrysanthemumKey);
    if (!view) {
        return;
    }
    [view dismiss];
    
    objc_setAssociatedObject(self, &YYChrysanthemumKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
