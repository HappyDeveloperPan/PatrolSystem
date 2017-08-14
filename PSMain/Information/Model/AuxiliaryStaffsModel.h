//
//  AuxiliaryStaffsModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/8/1.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaffModel.h"
#import "CoordinateModel.h"

@interface AuxiliaryStaffsModel : NSObject
@property (nonatomic, strong) StaffModel *staff;
@property (nonatomic, strong) CoordinateModel *latLng;
@property (nonatomic, assign) int distance;
@property (nonatomic, assign) BOOL onLine;
@end
