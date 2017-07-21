//
//  CleaningAreaModel.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/19.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "CleaningAreaModel.h"

@implementation CleaningAreaModel
+ (NSDictionary *)objectClassInArray{
    return @{@"cleaning_area" : [CoordinateModel class], @"cleaningAreaLatlngs":[CoordinateModel class]};
}
@end
