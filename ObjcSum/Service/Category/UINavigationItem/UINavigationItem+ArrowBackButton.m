//
//  UINavigationItem+ArrowBackButton.m
//  ObjcSum
//
//  Created by sihuan on 15/10/31.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "UINavigationItem+ArrowBackButton.h"
#import <objc/runtime.h>

@implementation UINavigationItem (ArrowBackButton)

static char kArrowBackButtonKey;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method m1 = class_getInstanceMethod(self, @selector(backBarButtonItem));
        Method m2 = class_getInstanceMethod(self, @selector(arrowBackButton_backBarButtonItem));
        method_exchangeImplementations(m1, m2);
    });
}

- (UIBarButtonItem *)arrowBackButton_backBarButtonItem {
    UIBarButtonItem *item = [self arrowBackButton_backBarButtonItem];
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
