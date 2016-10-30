//
//  UILabelController.m
//  UI控件
//
//  Created by michael chen on 14-9-23.
//  Copyright (c) 2014年 huan. All rights reserved.
//

#import "UIActivityIndicatorViewController.h"

@interface UIActivityIndicatorViewController ()

@end

@implementation UIActivityIndicatorViewController

- (void)activityViewInit
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(160, 200);
    [activityView startAnimating];
    //    activityView.hidesWhenStopped = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(test:) userInfo:activityView repeats:NO];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)test:(NSTimer *)timer
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    UIActivityIndicatorView *activityView = [timer userInfo];
    [activityView stopAnimating];
}

@end
