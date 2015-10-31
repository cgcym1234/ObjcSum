//
//  YYAlertTextViewDemo.m
//  MySimpleFrame
//
//  Created by sihuan on 15/10/18.
//  Copyright © 2015年 huan. All rights reserved.
//

#import "YYAlertTextViewDemo.h"
#import "YYAlertTextView.h"
#import "UIViewController+Extension.h"

@interface YYAlertTextViewDemo ()

@property (nonatomic, strong) YYAlertTextView *alertView;

@end

@implementation YYAlertTextViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakSelf = self;
    int btnNum = 2;
    [self addButtonWithTitle:@"show" action:^(UIButton *btn) {
        [weakSelf.alertView show];
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
}

- (YYAlertTextView *)alertView {
    if (!_alertView) {
        __weak typeof(self) weakSelf = self;
        if (weakSelf) {
            
        }
        YYAlertTextView *alertView = [YYAlertTextView instanceFromNib];
        alertView.title = @"我是标题";
        alertView.placeHolder = @"我是placeHolder";
        alertView.didClickedBlock = ^(YYAlertTextView *view, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
            }
        };
        _alertView = alertView;
    }
    return _alertView;
}

@end
