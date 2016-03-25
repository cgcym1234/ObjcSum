//
//  JSPatchDemo.m
//  ObjcSum
//
//  Created by sihuan on 16/3/22.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "JSPatchDemo.h"
#import "JPEngine.h"

@interface JSPatchDemo ()<UIWebViewDelegate> {
//    __unsafe_unretained NSString *name;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation JSPatchDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = self.view.bounds;
    frame.size.height -=200;
    UIWebView *webview0 = [[UIWebView alloc] initWithFrame:frame];
    [self.view addSubview:webview0];
    webview0.delegate = self;
    _webView = webview0;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height+10, [UIScreen mainScreen].bounds.size.width, 50)];
    [btn setTitle:@"Push JPTableViewController" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:btn];
    
    [self loadJSFile];
    [self loadWebHtml];
}

- (void)loadWebHtml {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Second" ofType:@"html"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    [_webView loadRequest:request];
}

- (void)registerNativeFunToHtml {
    
}

- (void)loadJSFile {
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"JSPatchDemo" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    [JPEngine evaluateScript:script];
}

- (void)handleBtn:(id)sender
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self registerNativeFunToHtml];
}

@end
