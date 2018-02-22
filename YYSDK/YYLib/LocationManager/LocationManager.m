//
//  LocationManager.m
//  YYSDK
//
//  Created by yangyuan on 2018/1/15.
//  Copyright © 2018年 sihuan. All rights reserved.
//

#import "LocationManager.h"
#import "JZLocationConverter.h"

NSString *const LocationManagerDidUpdateLactionNotification = @"LocationManagerDidUpdateLactionNotification";
NSString *const LocationManagerDidUpdateHeadingNotification = @"LocationManagerDidUpdateHeadingNotification";

@interface LocationManager ()
<CLLocationManagerDelegate>

@property (nonatomic, strong) CLHeading *heading;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) CLPlacemark *placemark;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocodeManager;

@end

@implementation LocationManager

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static id sharedInstance;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (instancetype)init {
	if (self = [super init]) {
		self.locationManager.delegate = self;
	}
	return self;
}

+ (void)startWorking {
	[LocationManager sharedInstance];
}

#pragma mark - Func

- (void)startUpdatingLocation {
	[self.locationManager startUpdatingLocation];
	if ([CLLocationManager headingAvailable]) {
		self.locationManager.headingFilter = 5;
		[self.locationManager startUpdatingHeading];
	}
}

- (void)stopUpdatingLocation {
	[self.locationManager stopUpdatingLocation];
	if ([CLLocationManager headingAvailable]) {
		[self.locationManager stopUpdatingHeading];
	}
}

#pragma mark - Getter

- (CLLocationManager *)locationManager {
	if (!_locationManager) {
		CLLocationManager *manager = [CLLocationManager new];
		manager.desiredAccuracy = kCLLocationAccuracyBest;
		manager.distanceFilter = 50;
		_locationManager = manager;
	}
	return _locationManager;
}

- (CLGeocoder *)geocodeManager {
	if (!_geocodeManager) {
		CLGeocoder *manager = [CLGeocoder new];
		_geocodeManager = manager;
	}
	return _geocodeManager;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	self.heading = newHeading;
	[[NSNotificationCenter defaultCenter] postNotificationName:LocationManagerDidUpdateHeadingNotification object:newHeading];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
	CLLocation *location = locations.firstObject;
	if (location) {
		CLLocationCoordinate2D gciCoordinate = [JZLocationConverter wgs84ToGcj02:location.coordinate];
		CLLocation *gciLocation = [[CLLocation alloc] initWithLatitude:gciCoordinate.latitude longitude:gciCoordinate.longitude];
		self.location = gciLocation;
		[[NSNotificationCenter defaultCenter] postNotificationName:LocationManagerDidUpdateLactionNotification object:gciLocation];
		
		[self.geocodeManager cancelGeocode];
		[self.geocodeManager reverseGeocodeLocation:gciLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
			if (placemarks.firstObject && gciLocation == self.location) {
				self.placemark = placemarks.firstObject;
			}
		}];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	switch (status) {
		case kCLAuthorizationStatusAuthorizedAlways:
		case kCLAuthorizationStatusAuthorizedWhenInUse:
			[self startUpdatingLocation];
			break;
			
		case kCLAuthorizationStatusDenied:
			[self stopUpdatingLocation];
			break;
		default:
			break;
	}
}

@end














