//
//  CruiseModel.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/19.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "CruiseModel.h"

@implementation CruiseModel
+ (NSDictionary *)objClassInArray {
    return @{@"cruiseLineLatlngs":[CoordinateModel class]};
}
@end
