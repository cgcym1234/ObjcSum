//
//  ViewController.m
//  Test
//
//  Created by yangyuan on 2018/9/6.
//  Copyright © 2018 huan. All rights reserved.
//

#import "SSLTestController.h"
#import "AFNetworking.h"

@interface SSLTestController ()

@property (nonatomic) AFHTTPSessionManager *sessoinManager;

@end

@implementation SSLTestController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setup];
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
	btn.frame = CGRectMake(50, 100, 100, 40);
	[btn setTitle:@"发送网络请求" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];
}

- (IBAction)test:(id)sender {
	[self postApi];
}

- (void)setup {
	AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
	policy.validatesDomainName = YES;
	policy.allowInvalidCertificates = NO;

	AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.ankerjiedian.com"]];
	manager.securityPolicy = policy;
	manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
	
	_sessoinManager = manager;
	AFJSONRequestSerializer *request = [AFJSONRequestSerializer new];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[_sessoinManager setRequestSerializer:request];


	AFJSONResponseSerializer *response = [AFJSONResponseSerializer new];
	NSMutableSet *customContentTypes = [response.acceptableContentTypes mutableCopy];
	[customContentTypes addObject:@"text/html"];
	[customContentTypes addObject:@"text/plain"];
	[customContentTypes addObject:@"text/json"];
	[customContentTypes addObject:@"application/json"];
	response.acceptableContentTypes = [customContentTypes copy];
	[_sessoinManager setResponseSerializer:response];
}

- (void)postApi {
	NSMutableDictionary *headers = [NSMutableDictionary new];
	headers[@"type"] = @"";
	
	headers[@"service"] = @"sharedCharging";
	
	headers[@"api"] = @"YActivity.appIndexNotice";
	
	headers[@"msg_id"] = [[NSUUID UUID] UUIDString];
	
	headers[@"access_token"] = @"";
	
	headers[@"applet"] = @"ios";  /// 平台
	headers[@"client_v"] = @"2.0.6"; /// 客户端版本
	headers[@"dpi"] = @"640x960";    ///设备像素
	headers[@"session_id"] = @"";
	
	NSDictionary *dict = @{
						   @"header": headers,
						   @"body": @{@"app_installed_firstly": @"0"}
						   };
	
	[self requestWithMethod:@"POST" urlString:@"index.php" parameters:dict headers:@{@"Content-Type": @"application/json"}];

}


- (NSURLRequest *)requestWithMethod:(NSString *)method
							urlString:(NSString *)urlString
						   parameters:(NSDictionary *)parameters
							  headers:(NSDictionary *)headers {
	NSError *serializationError = nil;
	NSMutableURLRequest *request = [_sessoinManager.requestSerializer requestWithMethod:method URLString:[NSURL URLWithString:urlString relativeToURL:_sessoinManager.baseURL].absoluteString parameters:parameters error:&serializationError];
	
	if (headers) {
		[headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
			[request setValue:obj forHTTPHeaderField:key];
		}];
	}
	
	__block NSURLSessionDataTask *dataTask = nil;
	dataTask = [_sessoinManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
		if (responseObject) {
			NSLog(@"%@", responseObject);
		}
		
		if (error) {
			NSInteger code = [(NSHTTPURLResponse *)response statusCode];
			NSString *errorMsg = error.localizedDescription;
			
			NSLog(@"requestFailed error=%@, responseCode=%ld, errorMsg=%@", error, (long)code, errorMsg);
		}
	}];
	
	[dataTask resume];
	return request;
}

@end
