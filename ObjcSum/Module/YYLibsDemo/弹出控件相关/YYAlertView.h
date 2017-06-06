//
//  YYAlertView.h
//  ObjcSum
//
//  Created by yangyuan on 2017/6/1.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYAlertView : UIView

+ (void)showWithTitle:(NSString *)title cancel:(void (^)(void))cancel confirm:(void (^)(void))confirm;

@end
