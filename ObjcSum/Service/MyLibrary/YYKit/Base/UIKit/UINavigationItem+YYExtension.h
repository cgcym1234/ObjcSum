//
//  UINavigationItem+YYExtension.h
//  ObjcSum
//
//  Created by sihuan on 15/12/15.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (YYExtension)

#pragma mark - 替换UINavigationItem的backBarButtonItem，去掉返回按钮的文字
- (UIBarButtonItem *)backBarButtonItemNoText;

@end
