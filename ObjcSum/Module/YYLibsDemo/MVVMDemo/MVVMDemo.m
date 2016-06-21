//
//  MVVMDemo.m
//  ObjcSum
//
//  Created by sihuan on 15/12/24.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import "MVVMDemo.h"
#import "FastRecordController.h"
#import "UIViewController+Extension.h"

@interface MVVMDemo ()

@end



@implementation MVVMDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    if (weakSelf) {
        
    }
    int btnNum = 2;
    [self addButtonWithTitle:@"随手记" action:^(UIButton *btn) {
        [FastRecordController pushFromViewController:weakSelf];
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
