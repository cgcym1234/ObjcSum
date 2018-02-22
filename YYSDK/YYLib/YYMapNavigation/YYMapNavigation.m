//
//  YYMapNavigation.m
//  ObjcSum
//
//  Created by yangyuan on 2017/5/31.
//  Copyright © 2017年 sihuan. All rights reserved.
//

#import "YYMapNavigation.h"
#import "JZLocationConverter.h"
#import <MapKit/MapKit.h>

#pragma mark - YYMapNavigationItem

@implementation YYMapNavigationItem

+ (instancetype)instanceWithName:(NSString *)name latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    YYMapNavigationItem *item = [YYMapNavigationItem new];
    item.name = name;
    item.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    return item;
}

@end


#pragma mark - YYMapNavigation

#define AppName [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"]

//高德地图 http://lbs.amap.com/api/amap-mobile/guide/ios/ios-uri-information
//百度地图 http://lbsyun.baidu.com/index.php?title=uri/api/ios

@interface YYMapNavigation ()

//@property (nonatomic, weak) UIViewController *viewController;
//
//@property (nonatomic, strong) YYMapNavigationItem *from;
//@property (nonatomic, strong) YYMapNavigationItem *to;

@end

@implementation YYMapNavigation

+ (void)showNavigationFrom:(YYMapNavigationItem *)from to:(YYMapNavigationItem *)to inController:(UIViewController *)vc {
    if (!from || !to || !vc) {
        return;
    }
    
    if (!CLLocationCoordinate2DIsValid(from.coordinate) || !CLLocationCoordinate2DIsValid(to.coordinate)) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [self setupAppleMap:alert from:from to:to];
    [self setupGaodeMap:alert from:from to:to];
    [self setupBaiduMap:alert from:from to:to];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (void)setupAppleMap:(UIAlertController *)alert from:(YYMapNavigationItem *)from to:(YYMapNavigationItem *)to {
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"使用苹果自带地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        MKMapItem *fromLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:from.coordinate addressDictionary:@{@"Name": from.name}]];
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to.coordinate addressDictionary:@{@"Name": to.name}]];
        
        [MKMapItem openMapsWithItems:@[fromLocation, toLocation]
                       launchOptions:@{
                                       MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]
                                       }];
    }];
    
    [alert addAction:action];
}

+ (void)setupGaodeMap:(UIAlertController *)alert from:(YYMapNavigationItem *)from to:(YYMapNavigationItem *)to {
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"使用高德地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&sname=%@&slat=%f&slon=%f&did=BGVIS2&dname=%@&dlat=%f&dlon=%f&dev=0&m=3&t=0", AppName,from.name, from.coordinate.latitude, from.coordinate.longitude, to.name, to.coordinate.latitude, to.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        
        [alert addAction:action];
    }
}

+ (void)setupBaiduMap:(UIAlertController *)alert from:(YYMapNavigationItem *)from to:(YYMapNavigationItem *)to {
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"使用百度地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=name:%@|latlng:%f,%f&destination=name:%@|latlng:%f,%f&mode=driving&coord_type=gcj02&src=%@", from.name, from.coordinate.latitude, from.coordinate.longitude, to.name, to.coordinate.latitude, to.coordinate.longitude, AppName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        
        [alert addAction:action];
    }
}


@end
