//
//  LocationManager.h
//  YYSDK
//
//  Created by yangyuan on 2018/1/15.
//  Copyright © 2018年 sihuan. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

FOUNDATION_EXTERN NSString *const LocationManagerDidUpdateLactionNotification;
FOUNDATION_EXTERN NSString *const LocationManagerDidUpdateHeadingNotification;
FOUNDATION_EXTERN NSString *const LocationManagerDidChangeAuthorizationNotification;

@interface LocationManager : NSObject

///方向
@property (nonatomic, strong, readonly) CLHeading *heading;
///定位成功的地址
@property (nonatomic, strong, readonly) CLLocation *gcjLocation;
@property (nonatomic, strong, readonly) CLLocation *location;
///location对应地址信息
@property (nonatomic, strong, readonly) CLPlacemark *placemark;

///定位功能是否打开
@property (nonatomic, readonly) BOOL isLocationServiceEnable;

+ (instancetype)sharedInstance;

+ (void)startWorking;
+ (void)stopWorking;
+ (void)requestAlwaysAuthorization;

@end
