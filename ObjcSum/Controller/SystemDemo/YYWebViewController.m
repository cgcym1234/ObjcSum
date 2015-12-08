//
//  YYWebViewController.m
//  MLLLight
//
//  Created by sihuan on 15/6/30.
//

#import "YYWebViewController.h"
#import "YYHud.h"
#import "TestJSObjectProtocol.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface YYWebViewController ()<UIWebViewDelegate>


@property (nonatomic, strong) NSString *currentRequestUrl;

@end

@implementation YYWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.view addSubview:self.webView];
  self.webView.delegate = self;
  self.view.backgroundColor = [UIColor whiteColor];
  
  if (self.currentRequestUrl) {
      [self loadUrlStr:_currentRequestUrl];
  }
}


- (void)dealloc {
  [YYHud dismiss];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
  self.webView.frame = self.view.bounds;
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

- (UIWebView *)webView {
  if (!_webView) {
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor clearColor];
    _webView = webView;
  }
  return _webView;
}

#pragma mark - Oc Call Js

//iOS 调用js
- (void)callJs {
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *alertJS=@"alert('test js OC')"; //准备执行的js代码
    [context evaluateScript:alertJS];//通过oc方法调用js的alert
}

#pragma mark - Js call Oc
/**
 *  js调用iOS分两种情况
 一，js里面直接调用方法
 二，js里面通过对象调用方法
 */

//第一种情况,js里面直接调用方法
- (void)ocCallJsDemo1 {
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    /**
     *  其中test1就是js的方法名称，赋给是一个block 里面是iOS代码
     此方法最终将打印出所有接收到的参数，js参数是不固定的 我们测试一下就知道
     */
    context[@"text1"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            NSLog(@"%@",obj);
        }
    };
    
    /**
     *  此处我们没有写后台（但是前面我们已经知道iOS是可以调用js的，我们模拟一下）
     首先准备一下js代码，来调用js的函数test1 然后执行
     一个参数
     */
    NSString *jsFuncArg1 = @"text1('参数a')";
    [context evaluateScript:jsFuncArg1];
    
    //2个
    NSString *jsFuncArg2 = @"text1('参数a', 'arg b')";
    [context evaluateScript:jsFuncArg2];
}

//二，js里面通过对象调用方法
- (void)ocCallJsDemo2 {
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSExportDemoTest *testJs = [JSExportDemoTest new];
    context[@"textObject"] = testJs;
    //同样我们也用刚才的方式模拟一下js调用方法
    NSString *jsStr1=@"textObject.TestNOParameter()";
    [context evaluateScript:jsStr1];
    NSString *jsStr2=@"textObject.TestOneParameter('参数1')";
    [context evaluateScript:jsStr2];
    NSString *jsStr3=@"textObject.TestTowParametersecondParameter('参数A','参数B')";
    [context evaluateScript:jsStr3];
    
    
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  
//  [YYHud show:@"努力加载中..." maskType:YYHudDim];
    [YYHud showSpinner];
  NSString *urlStr = [request.URL absoluteString];
  NSLog(@"Load req:%@",urlStr);
  
  if ([request.URL.scheme isEqualToString:@"http"]) {
    self.currentRequestUrl = urlStr;
  }
    
  
  return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  NSLog(@"webViewDidStartLoad:%@",webView.request.URL.absoluteString);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [YYHud dismiss];
  //    NSString *errorInfor = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
  NSLog(@"didFailLoadWithError:%@",error);
  
  NSLog(@"didFailLoadWithError:%@",webView.request.URL.absoluteString);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [YYHud dismiss];
  NSString *urlStr = [webView.request.URL absoluteString];
  NSLog(@"webViewDidFinishLoad req:%@",urlStr);
  
  if ([webView.request.URL.scheme isEqualToString:@"http"]) {
    self.currentRequestUrl = urlStr;
  }
  
  
}

#pragma mark - Public
- (void)updateUI {
  
}


- (void)loadUrlStr:(NSString *)url {
  NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
  [_webView loadRequest:req];
}

+ (void)pushNewInstanceFromViewController:(UIViewController *)fromVc withUrlString:(NSString *)urlString title:(NSString *)title {
  YYWebViewController *webVc = [[YYWebViewController alloc] init];
  webVc.title = title;
  webVc.currentRequestUrl = urlString;
  [fromVc.navigationController pushViewController:webVc animated:YES];
}


@end
