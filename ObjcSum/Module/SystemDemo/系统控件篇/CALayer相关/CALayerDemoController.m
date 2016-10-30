//
//  CALayerDemoController.m
//  MySimpleFrame
//
//  Created by sihuan on 15/9/8.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "CALayerDemoController.h"

@interface CALayerDemoController ()

@end

@implementation CALayerDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self contentDemo];
}

- (void)contentDemo {
    [_label1.layer setContents:(id)[UIImage imageNamed:@"decorate_title_bg.png"].CGImage];
    [_label2.layer setContents:(id)[UIImage imageNamed:@"decorate_wave.png"].CGImage];
    
    [_view1.layer setContents:(id)[UIImage imageNamed:@"decorate_wave.png"].CGImage];
    [_view2.layer setContents:(id)[UIImage imageNamed:@"decorate_wave.png"].CGImage];
}


@end
