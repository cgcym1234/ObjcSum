//
//  JMGoodsDetailGraphicViewController.m
//  JuMei
//
//  Created by yangyuan on 2016/9/14.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "JMGoodsDetailGraphicViewController.h"
#import "JMGoodsDetail.h"



@interface JMGoodsDetailGraphicViewController ()
<UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isLoading;


@end

@implementation JMGoodsDetailGraphicViewController

#pragma mark - instance

+ (instancetype)instanceFromStoryboard {
    JMGoodsDetailGraphicViewController *vc = [[UIStoryboard storyboardWithName:JMGoodsDetailStoryboardName bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    return vc;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContext];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Override

#pragma mark - Initialization

- (void)setupContext {
    [self setupUI];
    
}

- (void)setupUI {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}






@end


