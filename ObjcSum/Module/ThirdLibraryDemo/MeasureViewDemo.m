//
//  MeasureViewDemo.m
//  ObjcSum
//
//  Created by yangyuan on 2017/6/13.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "MeasureViewDemo.h"
#import "TagViewUtils.h"

@interface MeasureViewDemo ()

@end

@implementation MeasureViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = @[
                     [[LibDemoInfo alloc] initWithTitle:@"MeasureViewDemo" desc:@"测量view距离" controllerName:@"MeasureViewDemo"],
                     [[LibDemoInfo alloc] initWithTitle:@"JSPatchDemo" desc:@"JSPatch动态部署测试" controllerName:@"JSPatchDemo"],
                     [[LibDemoInfo alloc] initWithTitle:@"RealReachabilityDemo" desc:@"真实网络检测" controllerName:@"RealReachabilityDemo"],
                     ];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"ShowBorder" style:UIBarButtonItemStylePlain target:self action:@selector(onShowBorder)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"ShowTagView" style:UIBarButtonItemStylePlain target:self action:@selector(onShowTag)];
}

- (void)onShowBorder {
    [TagViewUtils recursiveSetBorderWithView:self.view];
}

- (void)onShowTag {
    [TagViewUtils recursiveShowTagWithView:self.view];
}

@end
