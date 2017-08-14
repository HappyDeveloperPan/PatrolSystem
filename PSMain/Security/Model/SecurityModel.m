//
//  SecurityModel.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/5.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "SecurityModel.h"

@implementation SecurityModel
+ (NSDictionary *)objClassInArray {
    return @{@"theSecurityLineLatlngs":[CoordinateModel class]};
}
@end
