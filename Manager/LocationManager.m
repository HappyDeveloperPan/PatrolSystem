//
//  LocationManager.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/3.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

static  LocationManager *manager;
#pragma mark - Life Circle
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

+ (LocationManager *)sharedManager {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (id)copyWithZone:(NSZone *)zone {
    return manager;
}

#pragma mark - Method
//开始定位
- (void)startUserLocation {
    [self.locationManager startUpdatingLocation];
}

//停止定位
- (void)stopUserLocation {
    [self.locationManager stopUpdatingLocation];
}
#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //NSLog(@"location %@", locations);
    //地理反编码: 拿出经纬度 -> 转为地址
    CLLocation *location = locations.firstObject;
//    NSLog(@"转换前%f,%f",location.coordinate.latitude,location.coordinate.longitude);
    self.coordinate = AMapLocationCoordinateConvert(location.coordinate, AMapLocationCoordinateTypeGPS);
    NSLog(@"转换后%f,%f",self.coordinate.latitude,self.coordinate.longitude);
//    [kMainWindow showWarning:[NSString stringWithFormat: @"我的坐标%f,%f",self.coordinate.latitude,self.coordinate.longitude]];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败");
}

#pragma mark - Lazy Load
- (instancetype)init {
    if (self = [super init]) {
        _locationManager = [CLLocationManager new];
        //定位精度
        //设置期望定位精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        _locationManager.delegate = self;
        //设置多少米定位一次
        [_locationManager setDistanceFilter:20];
//        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//            [_locationManager requestAlwaysAuthorization];
//        }
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
        //开始更新位置
//        [_locationManager startUpdatingLocation];
    }
    return self;
}
@end
