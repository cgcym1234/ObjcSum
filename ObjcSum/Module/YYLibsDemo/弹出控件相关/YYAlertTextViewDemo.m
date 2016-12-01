//
//  YYAlertTextViewDemo.m
//  MySimpleFrame
//
//  Created by sihuan on 15/10/18.
//  Copyright © 2015年 huan. All rights reserved.
//

#import "YYAlertTextViewDemo.h"
#import "YYAlertTextView.h"
#import "YYMultiSelectTable.h"
#import "YYAlertTable.h"
#import "YYSimpleAlertTable.h"
#import "YYAlertGridView.h"
#import "UIViewController+Extension.h"
#import "UIViewController+NoDataView.h"
#import "UIView+YYChrysanthemum.h"

@interface YYAlertTextViewDemo ()

@property (nonatomic, strong) YYAlertTextView *alertView;
@property (nonatomic, strong) YYAlertTable *alertTable;

@end

@implementation YYAlertTextViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakSelf = self;
    int btnNum = 2;
    
    [self addButtonWithTitle:@"show AlertTextView" action:^(UIButton *btn) {
        [weakSelf.alertView show];
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
    
    [self addButtonWithTitle:@"show AlertGridView" action:^(UIButton *btn) {
        [YYAlertGridView showWithTextArry:@[@"中国人明裙子", @"fhasfasjlf",@"1",@"2"]].didClickedBlock = ^(YYAlertGridView *alertTable, NSInteger index) {
            NSLog(@"didClickedBlock %ld",(long)index);
            
        };
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
    
    [self addButtonWithTitle:@"show YYMultiSelectTable" action:^(UIButton *btn) {
        NSArray *dataArry = @[
                              [[YYMultiSelectModel alloc] initWithDictionary:@{@"name":@"制作中"}],
                              [[YYMultiSelectModel alloc] initWithDictionary:@{@"name":@"选中了", @"checked":@(1)}],
                              [[YYMultiSelectModel alloc] initWithDictionary:@{@"name":@"嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒点点滴滴的群"}],
                              [[YYMultiSelectModel alloc] initWithDictionary:@{@"name":@"出差错"}],
                              ];
        [YYMultiSelectTable showWithTitle:@"标题" dataArr:dataArry];
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
    
    
    [self addButtonWithTitle:@"show alertTable" action:^(UIButton *btn) {
        weakSelf.alertTable = [YYAlertTable showWithTitle:@"标题" textArry:@[@"中国人明裙子", @"fhasfasjlfslaffsadfdsa",@"1",@"2"]];
        weakSelf.alertTable.didClickedBlock = ^(YYAlertTable *alertTable, NSInteger index) {
            NSLog(@"didClickedBlock %ld",(long)index);
        };
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
    
    [self addButtonWithTitle:@"show alertTable" action:^(UIButton *btn) {
        [YYSimpleAlertTable showWithTextArry:@[@"中国人明裙子", @"fhasfasjlfslaffsadfdsa",@"1",@"2"]];
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
    
    [self addButtonWithTitle:@"NoDataViewShow" action:^(UIButton *btn) {
        [weakSelf noDataViewShow:@"测试测试" image:[UIImage imageNamed:@"no_data_default"]];
        
        //        [weakSelf noDataViewShow:@"测试测试" image:[UIImage imageNamed:@"no_data_default"] buttonTitle:@"dian 我" buttonBlock:^{
        //            NSLog(@"noDataViewShow didClickedBlock");
        //        } superView:weakSelf.view];
        
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
    
    [self addButtonWithTitle:@"noDataViewDismiss" action:^(UIButton *btn) {
        [weakSelf noDataViewDismiss];
        
    }].frame = CGRectMake(10, 40*btnNum++, 200, 40);
    
    [self.view yyChrysanthemumShow];
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

- (YYAlertTextView *)alertView {
    if (!_alertView) {
        __weak typeof(self) weakSelf = self;
        if (weakSelf) {
            
        }
        YYAlertTextView *alertView = [YYAlertTextView instanceFromNib];
        alertView.title = @"我是标题";
        alertView.placeHolder = @"我是placeHolder";
        alertView.didClickedBlock = ^(YYAlertTextView *view, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
            }
        };
        _alertView = alertView;
    }
    return _alertView;
}

@end
