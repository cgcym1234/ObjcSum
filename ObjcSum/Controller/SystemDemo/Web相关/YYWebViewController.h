//
//  YYWebViewController.h
//  MLLLight
//
//  Created by sihuan on 15/6/30.
//

#import <UIKit/UIKit.h>

@interface YYWebViewController : UIViewController

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong, readonly) NSString *currentRequestUrl;

- (void)loadUrlStr:(NSString *)url;

+ (void)pushNewInstanceFromViewController:(UIViewController *)fromVc withUrlString:(NSString *)urlString title:(NSString *)title;

@end
