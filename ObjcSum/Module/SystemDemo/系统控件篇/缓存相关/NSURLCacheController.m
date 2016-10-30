//
//  NSURLCacheController.m
//  MySimpleFrame
//
//  Created by sihuan on 15/6/3.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "NSURLCacheController.h"
#import "YYURLCache.h"
#import "UIViewController+Extension.h"

@interface NSURLCacheController ()<UIWebViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSURLCache *urlCache;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSMutableURLRequest *request;

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation NSURLCacheController

#pragma mark - NSURLCache 

/**
 *  为URL请求提供了内存中以及磁盘上的综合缓存机制。任何通过 NSURLConnection 加载的请求都将被 NSURLCache 处理。
 
 
 当一个请求完成下载来自服务器的回应，一个缓存的回应将在本地保存。
 下一次同一个请求再发起时，本地保存的回应就会马上返回，不需要连接服务器。NSURLCache 会 自动 且 透明 地返回回应。
 */


#pragma mark - NSURLRequestCachePolicy
/**
 *  NSURLRequest 有个 cachePolicy 属性，它根据以下常量指定了请求的缓存行为：
 
 NSURLRequestUseProtocolCachePolicy： 对特定的 URL 请求使用网络协议中实现的缓存逻辑。这是默认的策略。
 NSURLRequestReloadIgnoringLocalCacheData：数据需要从原始地址加载。不使用现有缓存。
 NSURLRequestReloadIgnoringLocalAndRemoteCacheData：不仅忽略本地缓存，同时也忽略代理服务器或其他中间介质目前已有的、协议允许的缓存。
 NSURLRequestReturnCacheDataElseLoad：无论缓存是否过期，先使用本地缓存数据。如果缓存中没有请求所对应的数据，那么从原始地址加载数据。
 NSURLRequestReturnCacheDataDontLoad：无论缓存是否过期，先使用本地缓存数据。如果缓存中没有请求所对应的数据，那么放弃从原始地址加载数据，请求视为失败（即：“离线”模式）。
 NSURLRequestReloadRevalidatingCacheData：从原始地址确认缓存数据的合法性后，缓存数据就可以使用，否则从原始地址加载。

 
 NSURLRequestReloadIgnoringLocalAndRemoteCacheData 和 NSURLRequestReloadRevalidatingCacheData 根本没有实现（Link to Radar）更加加深了混乱程度！
 
 关于NSURLRequestCachePolicy，以下才是你 实际 需要了解的东西：
 
 常量	意义
 UseProtocolCachePolicy	默认行为
 ReloadIgnoringLocalCacheData	不使用缓存
 ReloadIgnoringLocalAndRemoteCacheData	我是认真地，不使用任何缓存
 ReturnCacheDataElseLoad	使用缓存（不管它是否过期），如果缓存中没有，那从网络加载吧
 ReturnCacheDataDontLoad	离线模式：使用缓存（不管它是否过期），但是不从网络加载
 ReloadRevalidatingCacheData	在使用前去服务器验证
 */

#pragma mark - NSURLConnectionDelegate

/**
 *  一旦收到了服务器的回应，NSURLConnection 的代理就有机会在 -connection:willCacheResponse: 中指定缓存数据。
 
 NSCachedURLResponse 是个包含 NSURLResponse 以及它对应的缓存中的 NSData 的类。
 
 在 -connection:willCacheResponse: 中，cachedResponse 对象会根据 URL 连接返回的结果自动创建。因为 NSCachedURLResponse 没有可变部分，为了改变 cachedResponse 中的值必须构造一个新的对象，把改变过的值传入 –initWithResponse:data:userInfo:storagePolicy:，例如：
 */
//- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
//                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
//{
//    NSMutableDictionary *mutableUserInfo = [[cachedResponse userInfo] mutableCopy];
//    NSMutableData *mutableData = [[cachedResponse data] mutableCopy];
//    NSURLCacheStoragePolicy storagePolicy = NSURLCacheStorageAllowedInMemoryOnly;
//    
//    // ...
//    #pragma mark  如果 -connection:willCacheResponse: 返回 nil，回应将不会缓存。
//    return [[NSCachedURLResponse alloc] initWithResponse:[cachedResponse response]
//                                                    data:mutableData
//                                                userInfo:mutableUserInfo
//                                           storagePolicy:storagePolicy];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    int btnNum = 0;
    [self addButtonWithTitle:@"load again" action:^(UIButton *btn) {
        [weakSelf reloadWebView];
    }].frame = CGRectMake(10, 10, 200, 40);
    
    [self test];
}

- (void)test {
    NSString *paramURLAsString= @"https://www.baidu.com/";
    self.urlCache = [NSURLCache sharedURLCache];
    [self.urlCache setMemoryCapacity:10*1024*1024];
    //创建一个nsurl
    self.url = [NSURL URLWithString:paramURLAsString];
    //创建一个请求
    self.request=[NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    NSURLConnection *conection = [[NSURLConnection alloc] initWithRequest:self.request
                                                                     delegate:self
                                                             startImmediately:YES];
    self.connection = conection;
    
    [self.webView loadRequest:_request];
}

- (void)reloadWebView{
    //从请求中获取缓存输出
    NSCachedURLResponse *response =[self.urlCache cachedResponseForRequest:self.request];
    //判断是否有缓存
    if (response != nil){
        NSLog(@"如果有缓存输出，从缓存中获取数据");
        [self.request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
    }
    [self.webView loadRequest:self.request];
    
    self.connection = nil;
    
    NSURLConnection *newConnection = [[NSURLConnection alloc] initWithRequest:self.request
                                                                     delegate:self
                                                             startImmediately:YES];
    self.connection = newConnection;
}

- (UIWebView *)webView {
    if (!_webView) {
        CGRect frame = self.view.bounds;
        frame.origin.y = 40;
        _webView = [[UIWebView alloc] initWithFrame:frame];
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

#pragma mark - 使用下面代码，我将请求的过程打印出来
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse 接收响应包");
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)response {
    NSLog(@"willSendRequest 即将发送请求");
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"接受数据");
    NSLog(@"数据长度为 = %lu", (unsigned long)[data length]);
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    NSLog(@"willCacheResponse 将缓存响应包");
    return cachedResponse;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
     NSLog(@"connectionDidFinishLoading 请求完成");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
     NSLog(@"didFailWithError 请求失败");
}




@end
