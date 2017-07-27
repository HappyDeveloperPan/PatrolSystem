//
//  ShuttleBusLineModel.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/15.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "ShuttleBusLineModel.h"

@implementation ShuttleBusLineModel
+ (NSDictionary *)objectClassInArray{
    return @{@"ferry_push_line" : [CoordinateModel class], @"ferryPushLineLatlngs":[CoordinateModel class]};
}
@end
