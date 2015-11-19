//
//  YYAlertTableDemo.m
//  MySimpleFrame
//
//  Created by sihuan on 15/10/20.
//  Copyright © 2015年 huan. All rights reserved.
//

#import "YYAlertTableDemo.h"
#import "YYAlertTable.h"
#import "UIViewController+Extension.h"

@interface YYAlertTableDemo ()
@property (nonatomic, strong) YYAlertTable *alertTable;
@end

@implementation YYAlertTableDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    int btnNum = 2;
    [self addButtonWithTitle:@"show" action:^(UIButton *btn) {
        weakSelf.alertTable = [YYAlertTable showWithTitle:@"标题" textArry:@[@"中国人明裙子", @"fhasfasjlfslaffsadfdsa",@"1",@"2"]];
        weakSelf.alertTable.didClickedBlock = ^(YYAlertTable *alertTable, NSInteger index) {
            NSLog(@"didClickedBlock %ld",(long)index);
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
