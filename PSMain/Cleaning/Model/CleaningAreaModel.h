//
//  CleaningAreaModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/19.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinateModel.h"
#import "LineAreaModel.h"
#import "CleaningAreaLimitModel.h"

@interface CleaningAreaModel : NSObject
@property (nonatomic, assign) int cleaning_area_id;
@property (nonatomic, copy) NSString *cleaning_area_name;
@property (nonatomic, assign) int cleaning_area_limit_id;

@property (nonatomic, strong) NSArray< CoordinateModel *> *cleaning_area;

@property (nonatomic, strong) LineAreaModel *cleaningArea;
@property (nonatomic, strong) NSArray< CoordinateModel *> *cleaningAreaLatlngs;
@property (nonatomic, strong) CleaningAreaLimitModel *cleaningAreaLimit;
@end
