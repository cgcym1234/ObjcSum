//
//  TestViewController.m
//  ObjcSum
//
//  Created by sihuan on 2016/7/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "TestViewController.h"
#import "TestButtonTouchDownDelay.h"
#import "UIViewController+Extension.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    [self addButtonWithTitle:@"屏幕底部button延迟响应touchDown事件" action:^(UIButton *btn) {
        UIViewController *vc = [TestButtonTouchDownDelay new];
        [weakSelf.navigationController pushViewController:vc animated:true];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
