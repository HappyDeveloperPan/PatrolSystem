//
//  LocationManager.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/3.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface LocationManager : NSObject<NSCopying, CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

+ (LocationManager *)sharedManager;

- (void)startUserLocation;
- (void)stopUserLocation;
@end
