//
//  UnusualModel.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/8/2.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "UnusualModel.h"

@implementation UnusualModel
+ (NSDictionary *)objClassInArray {
    return @{@"auxiliaryStaffs":[AuxiliaryStaffsModel class], @"nowLocationdPictures":[PicturesModel class]};
}
@end
