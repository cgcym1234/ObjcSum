//
//  WebViewDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/12/7.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "WebViewDemo.h"
#import "YYWebViewController.h"
#import "UIViewController+Extension.h"

@interface WebViewDemo ()

@end

@implementation WebViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    if (weakSelf) {
        
    }
    int btnNum = 2;
    [self addButtonWithTitle:@"js oc相互调用（JavaScriptCore）" action:^(UIButton *btn) {
//        NSString *url = @"http://activity.yqrtv.com/ylxzb/index.php";
        NSString *url = @"http://www.baidu.com";
        [YYWebViewController pushNewInstanceFromViewController:weakSelf withUrlString:url title:@"title"];
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
}


@end
