//
//  WKWebViewDemo.m
//  ObjcSum
//
//  Created by yangyuan on 2017/3/30.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "WKWebViewDemo.h"
#import <WebKit/WebKit.h>
#import "UIViewController+Extension.h"
#import "Masonry.h"

static NSString * const loadUrlStr  = @"https://www.baidu.com/";

@interface WKWebViewDemo ()
<UITextFieldDelegate, WKNavigationDelegate, WKUIDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backwardButton;
@property (weak, nonatomic) IBOutlet UIProgressView *loadProgressView;

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation WKWebViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.containerView addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.top.equalTo(self.containerView);
        make.bottom.equalTo(self.containerView);
    }];
    
    
    /*
     WkWebView的三个可以使用kvo监听的属性：loading，estimatedProgress，title
     */
    
    [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadUrlStr]]];
    
    [self addRightBarButtonItemWithTitle:@"动画" action:@selector(animating)];
}

- (void)animating {
    CGRect frame = self.view.frame;
    [UIView animateWithDuration:2
                     animations:^{
                         self.view.frame = CGRectOffset(frame, 0, -300);
                     }
                     completion:^(BOOL finished) {
                         self.view.frame = frame;
                     }];
}

#pragma mark - 监听的处理方法

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString: @"loading"]) {
        _backwardButton.enabled = _webView.canGoBack;
        _forwardButton.enabled = _webView.canGoForward;
        
    }else if ([keyPath isEqualToString:@"estimatedProgress"]){
        
        _loadProgressView.hidden = _webView.estimatedProgress == 1 ? YES :NO;
        [_loadProgressView setProgress:_webView.estimatedProgress];
        
    }else if ([keyPath isEqualToString: @"title"]){
        self.navigationItem.title = _webView.title;
    }
    
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _inputTextField.text = loadUrlStr;
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:textField.text]]];
    return NO;
}

/*
 ###  网页加载的过程。
 
 网页加载由一个动作（Action）触发。这可能是任何导致网页加载的动作，比如：触碰一个链接、点击后退、前进和刷新按钮，JavaScript 设置了window.location属性，子窗口的加载或者对WKWebView的loadRequest（）方法的调用。
 
 然后一个请求被发送到了服务器，我们会得到一个响应（可能是有意义的也可能是错误状态码，比如：404）。最后服务器会发送更多地数据，并结束加载过程。
 
 WebKit允许你的App在动作（Action）和响应（Response）阶段之间注入代码，并决定是否继续加载，取消或是做你想做的事情。
 
 请求http://www.baidu.com成功后调用顺序，会被重定向到m.baidu.com
 webView(_:decidePolicyForNavigationAction:decisionHandler:)
 webView(_:didStartProvisionalNavigation:)
 webView(_:decidePolicyForNavigationAction:decisionHandler:)
 webView(_:didReceiveServerRedirectForProvisionalNavigation:)
 webView(_:didReceiveAuthenticationChallenge:completionHandler:)
 webView(_:decidePolicyForNavigationResponse:decisionHandler:)
 webView(_:didCommitNavigation:)
 webView(_:didFailNavigation:withError:)
 webView(_:decidePolicyForNavigationAction:decisionHandler:)
 webView(_:didStartProvisionalNavigation:)
 webView(_:decidePolicyForNavigationResponse:decisionHandler:)
 webView(_:didCommitNavigation:)
 webView(_:didFinishNavigation:)
 */
#pragma mark - WKNavigationDelegate
// MARK: - 用来追踪加载过程（页面开始加载、加载完成、加载失败）的方法

// 1 在发送请求之前，决定是否跳转，可能调用多次
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 2 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 3 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
    // 在收到服务器的响应头，根据response相关信息，决定是否跳转。decisionHandler必须调用，来决定是否跳转，参数WKNavigationActionPolicyCancel取消跳转，WKNavigationActionPolicyAllow允许跳转
}

// 4 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 5 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

// 6 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

// 接收到服务器跳转请求之后调用,服务器重定向请求触发
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 数据加载发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

// 需要响应身份验证时调用 同样在block中需要传入用户身份凭证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

// 进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    
}

#pragma mark - WKUIDelegate

/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(void (^)())completionHandler {
    
    NSLog(@"-------web界面中有弹出警告框时调用");
}

// 创建新的webView时调用的方法
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    NSLog(@"-----创建新的webView时调用的方法");
    return webView;
}

// 关闭webView时调用的方法
- (void)webViewDidClose:(WKWebView *)webView {
    
    NSLog(@"----关闭webView时调用的方法");
}

// 下面这些方法是交互JavaScript的方法
// JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    NSLog(@"%@",message);
    completionHandler(YES);
}
// JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    NSLog(@"%@",prompt);
    completionHandler(@"123");
}

// 默认预览元素调用
- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo {
    
    NSLog(@"-----默认预览元素调用");
    return YES;
}

// 返回一个视图控制器将导致视图控制器被显示为一个预览。返回nil将WebKit的默认预览的行为。
- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions {
    
    NSLog(@"----返回一个视图控制器将导致视图控制器被显示为一个预览。返回nil将WebKit的默认预览的行为。");
    return self;
}

// 允许应用程序向它创建的视图控制器弹出
- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController {
    
    NSLog(@"----允许应用程序向它创建的视图控制器弹出");
    
}

// 显示一个文件上传面板。completionhandler完成处理程序调用后打开面板已被撤销。通过选择的网址，如果用户选择确定，否则为零。如果不实现此方法，Web视图将表现为如果用户选择了取消按钮。
- (void)webView:(WKWebView *)webView runOpenPanelWithParameters:(WKOpenPanelParameters *)parameters initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSArray<NSURL *> * _Nullable URLs))completionHandler {
    
    NSLog(@"----显示一个文件上传面板");
    
}

#pragma mark - action

- (IBAction)go:(id)sender {
    [_webView loadRequest:[NSURLRequest requestWithURL:_webView.URL]];
}
- (IBAction)goback:(id)sender {
    [_webView goBack];
}
- (IBAction)goForward:(id)sender {
    [_webView goForward];
}

#pragma mark - 
- (WKWebView *)webView {
    if (!_webView) {
        WKPreferences *preferences = [WKPreferences new];
        preferences.minimumFontSize = 10;// 默认为0
        preferences.javaScriptEnabled = YES; // 默认认为true
        preferences.javaScriptCanOpenWindowsAutomatically = YES; //默认为NO，表示不能自动通过js打开窗口
        
        // web内容处理池
        WKProcessPool *processPool = [WKProcessPool new];
        
        //拥有一些属性来作为原生代码和网页之间沟通的桥梁。
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
        configuration.preferences = preferences;
        configuration.processPool = processPool;
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    
    return _webView;
    
}

@end












