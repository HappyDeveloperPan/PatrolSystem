//
//  PleasureBoatLineModel.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/18.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "PleasureBoatLineModel.h"

@implementation PleasureBoatLineModel
+ (NSDictionary *)objectClassInArray{
    return @{@"cruise_line" : [CoordinateModel class]};
}
@end
