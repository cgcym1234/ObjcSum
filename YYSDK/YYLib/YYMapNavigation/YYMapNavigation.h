//
//  YYMapNavigation.h
//  ObjcSum
//
//  Created by yangyuan on 2017/5/31.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface YYMapNavigationItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

+ (instancetype)instanceWithName:(NSString *)name latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

@end


@interface YYMapNavigation : NSObject

+ (void)showNavigationFrom:(YYMapNavigationItem *)from to:(YYMapNavigationItem *)to inController:(UIViewController *)vc;

@end
