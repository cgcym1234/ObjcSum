//
//  ThirdLibraryDemo.m
//  ObjcSum
//
//  Created by sihuan on 16/3/22.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "ThirdLibraryDemo.h"

@interface ThirdLibraryDemo ()

@end

@implementation ThirdLibraryDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = @[
                     [[LibDemoInfo alloc] initWithTitle:@"JSPatchDemo" desc:@"JSPatch动态部署测试" controllerName:@"JSPatchDemo"],
                     
                     ];
}


@end
