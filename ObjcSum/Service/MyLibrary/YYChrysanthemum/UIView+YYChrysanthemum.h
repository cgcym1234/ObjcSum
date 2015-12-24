//
//  UIView+YYChrysanthemum.h
//  ObjcSum
//
//  Created by sihuan on 15/12/16.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYChrysanthemum.h"

@interface UIView (YYChrysanthemum)

/*
 显示一个转圈的小菊花
 */
- (YYChrysanthemum *)yyChrysanthemumShow;
- (YYChrysanthemum *)yyChrysanthemumShowInView:(UIView *)superView;
- (YYChrysanthemum *)yyChrysanthemumShowInView:(UIView *)superView wrapInteraction:(BOOL)wrapInteraction dim:(BOOL)dim;

- (void)yyChrysanthemumDismiss;


@end
