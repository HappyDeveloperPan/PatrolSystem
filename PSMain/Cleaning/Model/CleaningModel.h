//
//  CleaningModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/11.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CleaningAreaModel.h"
#import "CoordinateModel.h"
#import "CleaningAreaLimitModel.h"
#import "RecordModel.h"

@interface CleaningModel : NSObject
@property (nonatomic, copy) NSString *cleaning_the_start_time;
@property (nonatomic, assign) NSInteger cleaning_records_id;
@property (nonatomic, assign) NSInteger cleaning_area_id;
@property (nonatomic, assign) NSInteger staff_id;
@property (nonatomic, copy) NSString *cleaning_the_end_time;

@property (nonatomic, strong) CleaningAreaModel *cleaningArea;
@property (nonatomic, strong) NSArray <CoordinateModel *> *cleaningAreaLatlngs;
@property (nonatomic, strong) CleaningAreaLimitModel *cleaningAreaLimit;
@property (nonatomic, strong) RecordModel *cleaningRecords;
@end
