//
//  YYBaseDemoController.m
//  MySimpleFrame
//
//  Created by sihuan on 15/9/4.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "YYBaseDemoController.h"

#define CellIdentifier @"reuseIdentifier"

@interface YYBaseDemoController ()

@end

@implementation YYBaseDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 60;
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    UILabel *b;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    LibDemoInfo *item = _dataArr[indexPath.row];
    
    cell.accessoryType = item.controllerName != nil ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.desc;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LibDemoInfo *item = _dataArr[indexPath.row];
    UIViewController *vc = [self getInstanceFromString:item.controllerName];
    if (vc) {
        vc.title = item.title;
        vc.edgesForExtendedLayout= UIRectEdgeNone;
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 根据类名来实例化对象,
- (id)getInstanceFromString:(NSString *)clsName {
    if (!clsName) {
        return nil;
    }
    
    Class cls = NSClassFromString(clsName);
    return [[cls alloc] init];
}

@end



#pragma mark - LibDemoInfo
@implementation LibDemoInfo

- (instancetype)initWithTitle:(NSString *)title desc:(NSString *)desc controllerName:(NSString *)controllerName {
    if (self = [super init]) {
        _title = title;
        _desc = desc;
        _controllerName = controllerName;
    }
    return self;
}

@end