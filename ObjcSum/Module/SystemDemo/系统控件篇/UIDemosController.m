//
//  UIDemosController.m
//  MySimpleFrame
//
//  Created by sihuan on 15/4/25.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "UIDemosController.h"

@interface UIDemosController ()


@end

static NSString * const CellIdentifier = @"Cell";

@implementation UIDemosController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = @[
                    [[LibDemoInfo alloc] initWithTitle:@"PushPresentDemo" desc:@"Push或Present时监听" controllerName:@"PushPresentDemo"],
                     
                   [[LibDemoInfo alloc] initWithTitle:@"TableView相关" desc:@"TableView相关" controllerName:@"TableViewDemoController"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"CALayer相关" desc:@"CALayer相关" controllerName:@"CALayerDemoController"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"系统常用小控件相关" desc:@"系统常用小控件相关" controllerName:@"SmallViewsController"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"UIScrollView" desc:@"UIScrollView相关" controllerName:@"UIScrollViewController"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"UITextField相关" desc:@"UITextField相关" controllerName:@"UITextFieldController"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"UITextView相关" desc:@"UITextView相关" controllerName:@"TextViewController"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"NSURLCache相关" desc:@"NSURLCache相关" controllerName:@"NSURLCacheController"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"UICollectionView相关" desc:@"UICollectionView相关" controllerName:@"CollectionViewController"],
                   
                   [[LibDemoInfo alloc] initWithTitle:@"UIWebView相关" desc:@"UIWebView相关" controllerName:@"WebViewController"],
                    
                    [[LibDemoInfo alloc] initWithTitle:@"WKWebView相关" desc:@"WKWebViewDemo相关" controllerName:@"WKWebViewDemo"],
                   ];
    
}



@end
