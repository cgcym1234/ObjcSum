//
//  UIView+Extension.h
//  YYPasswordManager
//
//  Created by sihuan on 15/7/13.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

#pragma mark - 获取subView
- (UIView*)subviewOrSelfWithClass:(Class)cls;
- (UIView*)subviewWithTag:(NSInteger)tag;

#pragma mark - 获取view的UIViewController
- (UIViewController*)viewController;

@end
