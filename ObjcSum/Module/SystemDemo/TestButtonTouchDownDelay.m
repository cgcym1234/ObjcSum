//
//  TestButtonTouchDownDelay.m
//  ObjcSum
//
//  Created by sihuan on 2016/7/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "TestButtonTouchDownDelay.h"

@interface TestButtonTouchDownDelay ()

@end

@implementation TestButtonTouchDownDelay

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setContext];
}

- (void)setContext {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"点我" forState:UIControlStateNormal];
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor orangeColor].CGColor;
    
    [btn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [btn addTarget:self action:@selector(touchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
    [btn addTarget:self action:@selector(touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
    
    btn.frame = CGRectMake(30, 60, 320, 38);
    [self.view addSubview:btn];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan=NO;
}


#pragma mark - Override


#pragma mark - Private

/**
 *  当录音按钮被按下所触发的事件，这时候是开始录音
 */
- (IBAction)touchDown:(UIButton *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/**
 *  当手指在录音按钮范围之内离开屏幕所触发的事件，这时候是完成录音
 */
- (IBAction)touchUpInside:(UIButton *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/**
 *  当手指在录音按钮范围之外离开屏幕所触发的事件，这时候是取消录音
 */
- (IBAction)touchUpOutside:(UIButton *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/**
 *  当手指滑动到录音按钮的范围之外所触发的事件
 */
- (IBAction)touchDragOutside:(UIButton *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/**
 *  当手指滑动到录音按钮的范围之内所触发的事件
 */
- (IBAction)touchDragInside:(UIButton *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


@end
