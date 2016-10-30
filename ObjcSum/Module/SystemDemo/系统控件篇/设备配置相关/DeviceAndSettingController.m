//
//  DeviceAndSettingController.m
//  MySimpleFrame
//
//  Created by sihuan on 15/5/13.
//  Copyright (c) 2015年 huan. All rights reserved.
//

#import "DeviceAndSettingController.h"

@interface DeviceAndSettingController ()

@end

@implementation DeviceAndSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 代码中使用plist值
- (void)plistDemo {
    //Info.plist文件就是字典 ，plistDict
    NSDictionary *plistDict = [[NSBundle mainBundle] infoDictionary];
    
    //取得了版本信息（CFBundleVersion），结果是1.0。
    NSString *bundleVersion = plistDict[@"CFBundleVersion"];
    NSLog(@"%@", bundleVersion);
}

#pragma mark - 用代码获得沙盒里面的文件路径
- (void)directoryDemo {
    //获取整个程序所在目录
    NSString *homePath = NSHomeDirectory();
    NSLog(@"%@",homePath);
    
    //获取.app文件目录
    NSString *appPath = [[NSBundle mainBundle] bundlePath];
    NSLog(@"%@",appPath);
    
    //Documents目录  
    NSArray *Documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",[Documents objectAtIndex:0]);
    
    //Library目录
    NSArray *Librarys = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",[Librarys objectAtIndex:0]);
    
    //Caches目录，在Library下面
    NSArray *Caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",[Caches objectAtIndex:0]);
    
    //tmp目录
    NSString *tmpPath = NSTemporaryDirectory();
    NSLog(@"%@",tmpPath);
    
    //用整个程序目录加上tmp就拼凑出tmp目录，其他目录都可这样完成
    NSString *tmpPath2 = [appPath stringByAppendingPathComponent:@"tmp"];
    NSLog(@"%@",tmpPath2);
}

#pragma mark - 导入图片的方式以及如何获取路径
- (void)picPathDemo {
    //我们看到如下获取图片路径都用到NSBundle，其实因为都是在.app文件夹中，而NSBundle就是获取.app里资源的
    
    //Create groups方式，图片直接在.app里，以下两种方式相同
    NSString *path1 = [[NSBundle mainBundle]  pathForResource:@"1" ofType:@"png"];
    NSString *path2 = [[NSBundle mainBundle]  pathForResource:@"1.png" ofType:nil];
    NSLog(@"%@,%@",path1,path2);
    
    //Create folder reference方式，图片在img里，以下三种方式相同
    NSString *path3=[[NSBundle mainBundle]pathForResource:@"1" ofType:@"png" inDirectory:@"img"];
    NSString *path4=[[NSBundle mainBundle]pathForResource:@"1.png" ofType:nil inDirectory:@"img"];
    NSString *path5 = [[NSBundle mainBundle] pathForResource:@"img/1.png" ofType:nil inDirectory:nil];
    NSLog(@"%@,%@,%@",path3,path4,path5);
}


















@end
