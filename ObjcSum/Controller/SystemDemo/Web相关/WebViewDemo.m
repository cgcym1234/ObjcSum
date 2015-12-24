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
        
        /*
         http://3g.ganji.com/cq_pub/form/?url=motuoche
         网页用的是 <input accept="image/*" type="file">，在IOS端点击时会提示选择图片或相机，安卓端要看浏览器对这两个属性的优化，部分浏览器会直接跳转到资源管理器，优化做得好的可以直接提示选择相册或相机。这两个属性的用法可以去w3cschool上面看看。
         */
        NSString *url = @"http://3g.ganji.com/cq_pub/form/?url=motuoche";
        [YYWebViewController pushNewInstanceFromViewController:weakSelf withUrlString:url title:@"title"];
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
}


@end
