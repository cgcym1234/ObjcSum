//
//  WebViewController.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/26.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "WebViewController.h"
#import "YYHud.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"


#define kUserAgent              @"in_app_ios"

@interface WebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    
    
    self.webView.delegate = self.progressProxy;
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
    
    [self loadUrl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //必须在这里加，否则不显示
    [self.navigationController.navigationBar addSubview:self.progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (UIWebView *)webView {
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc] init];
        webView.frame = self.view.bounds;
        _webView = webView;
    }
    return _webView;
}

- (NJKWebViewProgressView *)progressView {
    if (!_progressView) {
        NJKWebViewProgressView *progressView = [[NJKWebViewProgressView alloc] init];
        CGFloat progressBarHeight = 2.f;
        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
        progressView.frame = barFrame;
        
        _progressView = progressView;
    }
    return _progressView;
}

- (NJKWebViewProgress *)progressProxy {
    if (!_progressProxy) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
    }
    return _progressProxy;
}

- (void)loadUrl {
    _urlString = @"http://www.baidu.com";
    
    if (_urlString.length == 0) {
        return;
    }
    NSString *urlStr = [_urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:req];
}


#pragma mark - 设置UIWebView的 UserAgent
/**
 *  WebView 没有提供设置user-agent 的接口，无论是设置要加载的request，还是在delegate 中设置request，经测试都是无效的。如下：
 
 方案一：
 
 [objc] view plaincopy在CODE上查看代码片派生到我的代码片
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
 [request addValue:@"Jiecao/2.4.7" forHTTPHeaderField:@"user-agent"];
 [self.webView loadRequest:request];
 无效！！！
 
 方案二：
 
 [objc] view plaincopy在CODE上查看代码片派生到我的代码片
 #pragma mark - webview delegate
 
 - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
 NSMutableURLRequest *req = (NSMutableURLRequest *)request;
 [req addValue:@"Jiecao/2.4.7" forHTTPHeaderField:@"user-agent"];
 }
 
 无效！！！
 */

- (void)addUserAgentForWebView {
    UIWebView *webView = [[UIWebView alloc] init];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newAgent = [NSString stringWithFormat:@"%@ %@",userAgent, kUserAgent];
    
    /**
     *  经测试，每个 UIWebView 实例的创建都会去读这个 UserAgent 的设置，
     所以这个设置不是整个 App 生命周期的，你可以任意的控制具体的 UIWebView 用什么样的 User Agent。
     */
    NSDictionary *infoAgentDic = @{ @"UserAgent":newAgent };
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:infoAgentDic];
}

#pragma mark - NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    #pragma mark - UIWebViewNavigationType
    /**UIWebViewNavigationType
     
     UIWebViewNavigationTypeLinkClicked，用户触击了一个链接。
     UIWebViewNavigationTypeFormSubmitted，用户提交了一个表单。
     UIWebViewNavigationTypeBackForward，用户触击前进或返回按钮。
     UIWebViewNavigationTypeReload，用户触击重新加载的按钮。
     UIWebViewNavigationTypeFormResubmitted，用户重复提交表单
     UIWebViewNavigationTypeOther，发生其它行为。
     */
    
    
    NSString *urlStr = [request.URL absoluteString];
    NSLog(@"Load req:%@",urlStr);
    
    NSRange range = [urlStr rangeOfString:@"goods-"];
    if (range.length != 0) {
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSString *errorInfor = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    [YYHud showError:errorInfor];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
     //[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}

@end
