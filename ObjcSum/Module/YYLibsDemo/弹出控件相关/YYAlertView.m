//
//  YYAlertView.m
//  ObjcSum
//
//  Created by yangyuan on 2017/6/1.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "YYAlertView.h"
#import "ReactiveCocoa.h"

@implementation YYAlertView

+ (void)showWithTitle:(NSString *)title cancel:(void (^)(void))cancel confirm:(void (^)(void))confirm {
    UIAlertView *chooseAlert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [chooseAlert show];
    
    [[chooseAlert rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
        if ([indexNumber intValue] == 0) {
            if (cancel) {
                cancel();
            }
        } else if ([indexNumber intValue] == 1) {
            if (confirm) {
                confirm();
            }
        }
    }];
}

@end
