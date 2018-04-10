//
//  ThirdLibraryDemo.m
//  ObjcSum
//
//  Created by sihuan on 16/3/22.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "ThirdLibraryDemo.h"

///// 基础地图（地图显示、操作和各种覆盖物图层；
//#import <BaiduMapAPI_Base/BMKBaseComponent.h>
//#import <BaiduMapAPI_Map/BMKMapComponent.h>
//
///// 检索功能（POI检索、地理编码、路径规划等；
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>
//
///// LBS云检索（基于LBS云的周边、城市内、区域、详情检索；
////#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
//
///// 定位功能（提供获取当前位置的能力；
//#import <BaiduMapAPI_Location/BMKLocationComponent.h>
//
///// 计算工具（调启百度地图客户端、坐标转换、空间关系判断等；
//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

/// 周边雷达（位置信息上传和检索周边相同应用的用户位置信息功能；
//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>

///可只引入所需的单个头文件
//#import < BaiduMapAPI_Map/BMKMapView.h>

@interface ThirdLibraryDemo ()

@end

@implementation ThirdLibraryDemo

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.dataArr = @[
					 [[LibDemoInfo alloc] initWithTitle:@"HotFixDemo" desc:@"HotFixDemo" controllerName:@"HotFixDemo"],
					 [[LibDemoInfo alloc] initWithTitle:@"FlexboxDemo" desc:@"FlexboxDemo" controllerName:@"FlexboxDemo"],
                     [[LibDemoInfo alloc] initWithTitle:@"MeasureViewDemo" desc:@"测量view距离" controllerName:@"MeasureViewDemo"],
                     [[LibDemoInfo alloc] initWithTitle:@"JSPatchDemo" desc:@"JSPatch动态部署测试" controllerName:@"JSPatchDemo"],
                     [[LibDemoInfo alloc] initWithTitle:@"RealReachabilityDemo" desc:@"真实网络检测" controllerName:@"RealReachabilityDemo"],
                     ];
}


@end
