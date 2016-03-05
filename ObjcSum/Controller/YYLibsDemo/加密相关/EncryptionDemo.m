//
//  EncryptionDemo.m
//  MySimpleFrame
//
//  Created by sihuan on 15/10/19.
//  Copyright © 2015年 huan. All rights reserved.
//

#import "EncryptionDemo.h"
#import "AESenAndDe.h"
#import "YYBaseHttp.h"

#define UrlRoot       @"http://kuaikou.jios.org:7777/justice"
#define UrlTasksTodo             UrlRoot@"/mobile/task/todo"

@interface EncryptionDemo ()

@end

@implementation EncryptionDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *str = @"zhangjianlong";
    NSString *encryptStr = [self stringFromAESEncrypt:str];
    NSLog(@"加密前: %@， 加密后: %@", str, encryptStr);
    
    NSDictionary *parameters = @{@"audit":@"N", @"start": @"0"};
    [[YYBaseHttp new] getUrlString:UrlTasksTodo parameters:parameters completion:^(id responseData, NSError *error, NSURLSessionDataTask *dataTask) {
        if (error) {
            NSLog(@"%@", error);
        }
        NSLog(@"%@", responseData);
    }];
}

//伪造响应
- (void)cacheDemo {
    NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://172.16.25.44/test1.php"] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:3];
    NSURLCache *cache = [NSURLCache sharedURLCache];
    
    NSData *contentData = [@"123" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://172.16.25.44/test1.php"] MIMEType:@"text/html" expectedContentLength:1000 textEncodingName:@"UTF-8"];
    NSCachedURLResponse *cacheResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:contentData];
    
    [cache storeCachedResponse:cacheResponse forRequest:request];
    
    //如上代码，创建了一个针对@"http://172.16.25.44/test1.php"请求的响应，并且让 cache 对该响应进行了存储。
}

//修改响应内容
//修改响应内容需要我们实现NSURLConnectionDataDelegate 协议并实现
-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    //应为 NSCachedURLResponse 的属性都是readonly的，所以我们想要添加内容就要创建一个可变副本增减内容。
    NSMutableData *mutableData = [[cachedResponse data] mutableCopy];
    
    //添加数据
    
    NSCachedURLResponse *response = [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:mutableData];
    return response;
}

//可以看到输出的是我们自定义的123，而不是服务器返回的1。

#define PrivateKey @"3b188cf6d320b798"

#pragma mark - AES/ECB/PKCS5Padding加密以后再 base64 转成字符串
- (NSString*)stringFromAESEncrypt:(NSString *)str{
    return [AESenAndDe En_AESandBase64EnToString:str privateKey:PrivateKey];
}

@end
