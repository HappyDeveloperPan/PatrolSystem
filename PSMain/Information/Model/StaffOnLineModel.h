//
//  StaffOnLineModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/7/14.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaffModel.h"
#import "CoordinateModel.h"

@interface StaffOnLineModel : NSObject
@property (nonatomic, strong) StaffModel *staff;
@property (nonatomic, strong) CoordinateModel *latLng;
@property (nonatomic, assign) BOOL onLine;
@property (nonatomic, assign) float distance;
@end
