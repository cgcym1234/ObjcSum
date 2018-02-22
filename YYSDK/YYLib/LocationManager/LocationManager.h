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

@interface LocationManager : NSObject

///方向
@property (nonatomic, strong, readonly) CLHeading *heading;
///定位成功的地址
@property (nonatomic, strong, readonly) CLLocation *location;
///location对应地址信息
@property (nonatomic, strong, readonly) CLPlacemark *placemark;

+ (instancetype)sharedInstance;

+ (void)startWorking;

@end
