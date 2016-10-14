//
//  CLLocation+YYExtension.h
//  ObjcSum
//
//  Created by sihuan on 15/12/1.
//  Copyright © 2015年 sihuan. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

/**
 *  解决百度地图，高德地图等定位偏差问题
 
 API                坐标系
 百度地图API         百度坐标
 腾讯搜搜地图API      火星坐标
 搜狐搜狗地图API      搜狗坐标
 阿里云地图API       火星坐标
 图吧MapBar地图API   图吧坐标
 高德MapABC地图API   火星坐标
 灵图51ditu地图API   火星坐标
 */
@interface CLLocation (YYExtension)

//从地图坐标转化到火星坐标
- (CLLocation*)yy_locationMarsFromEarth;

//从火星坐标转化到百度坐标
- (CLLocation*)yy_locationBaiduFromMars;

//从百度坐标到火星坐标
- (CLLocation*)yy_locationMarsFromBaidu;

//从火星坐标到地图坐标
- (CLLocation*)yy_locationEarthFromMars;

//从百度坐标到地图坐标
- (CLLocation*)yy_locationEarthFromBaidu;

#pragma mark - CLLocationCoordinate2D

//从百度坐标到高德坐标
+ (CLLocationCoordinate2D)yy_locationToGaodeFromBaidu:(CLLocationCoordinate2D)location;

//从高德坐标转换到百度地图坐标
+ (CLLocationCoordinate2D)yy_locationToBaiduFromGaode:(CLLocationCoordinate2D)location;

@end
