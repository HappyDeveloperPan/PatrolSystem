//
//  LineModel.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/4.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "LineModel.h"

@implementation LineModel
+ (NSDictionary *)objectClassInArray{
    return @{@"the_security_line" : [CoordinateModel class]};
}
@end
