//
//  UINavigationItem+YYExtension.m
//  ObjcSum
//
//  Created by sihuan on 15/12/15.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "UINavigationItem+YYExtension.h"
#import <objc/runtime.h>

static char kArrowBackButtonKey;

@implementation UINavigationItem (YYExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method m1 = class_getInstanceMethod(self, @selector(backBarButtonItem));
        Method m2 = class_getInstanceMethod(self, @selector(backBarButtonItemNoText));
        method_exchangeImplementations(m1, m2);
    });
}

#pragma mark - 替换UINavigationItem的backBarButtonItem，去掉返回按钮的文字
- (UIBarButtonItem *)backBarButtonItemNoText {
    UIBarButtonItem *item = [self backBarButtonItemNoText];
    if (item) {
        return item;
    }
    
    item = objc_getAssociatedObject(self, &kArrowBackButtonKey);
    if (!item) {
        item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:NULL];
        objc_setAssociatedObject(self, &kArrowBackButtonKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}

@end
