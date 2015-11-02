//
//  UITableView+Extension.m
//  MyFrame
//
//  Created by sihuan on 15/7/7.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)

#pragma mark - 清除多余的分割线
- (void)clearExtraCellLine {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableFooterView = footerView;
}

@end
