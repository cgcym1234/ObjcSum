//
//  UIView+Extension.m
//  YYPasswordManager
//
//  Created by sihuan on 15/7/13.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

#pragma mark - 获取subView
- (UIView*)subviewOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child subviewOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}

- (id)subviewWithTag:(NSInteger)tag{
    for(UIView *view in [self subviews]){
        if(view.tag == tag){
            return view;
        }
    }
    
    return nil;
}

#pragma mark - 获取view的UIViewController
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
