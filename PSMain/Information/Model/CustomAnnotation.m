//
//  CustomAnnotation.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/17.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
- (instancetype)init {
    if (self = [super init]) {
        _staffModel = [[StaffOnLineModel alloc] init];
    }
    return self;
}
@end
