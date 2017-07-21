//
//  HelpModel.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/7/14.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "HelpModel.h"

@implementation HelpModel
+ (NSDictionary *)objClassInArray {
    return @{@"emergencyCallingDisposeStaffs":[HelpDisposeStaffsModel class], @"emergencyCallingDisposeStaffOnLine":[HelpDisposeStaffOnLineModel class], @"emergencyCallingPictures":[PicturesModel class], @"helpStaffs":[StaffOnLineModel class]};
}
@end
