//
//  YYBaseViewController+Navigation.m
//  ObjcSum
//
//  Created by sihuan on 2016/8/29.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYBaseViewController+Navigation.h"

@implementation YYBaseViewController (Navigation)

///< 返回到上个页面
- (void)backToPreviousControllerWithObject:(id)obj {
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

///< 导航栏返回按钮
- (void)setBackButton {
    
}
///< 返回左按钮
- (void)setLeftBackButton:(NSString *)title action:(SEL)action {
    
}
///< 普通的左按钮
- (void)setLeftButton:(NSString *)title action:(SEL)action {
    
}
///< 普通的右按钮
- (void)setRightButton:(NSString *)title action:(SEL)action {
    
}

@end



















