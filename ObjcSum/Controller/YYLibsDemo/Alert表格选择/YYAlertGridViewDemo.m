//
//  YYAlertGridViewDemo.m
//  MySimpleFrame
//
//  Created by sihuan on 15/10/24.
//  Copyright © 2015年 huan. All rights reserved.
//

#import "YYAlertGridViewDemo.h"
#import "YYAlertGridView.h"
#import "UIViewController+Extension.h"

@interface YYAlertGridViewDemo ()

@end

@implementation YYAlertGridViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    if (weakSelf) {
        
    }
    int btnNum = 2;
    [self addButtonWithTitle:@"show" action:^(UIButton *btn) {
        [YYAlertGridView showWithTextArry:@[@"中国人明裙子", @"fhasfasjlf",@"1",@"2"]].didClickedBlock = ^(YYAlertGridView *alertTable, NSInteger index) {
            NSLog(@"didClickedBlock %ld",index);
            
        };
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
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
