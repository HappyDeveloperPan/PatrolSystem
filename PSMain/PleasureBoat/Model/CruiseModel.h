//
//  CruiseModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/19.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PleasureBoatModel.h"
#import "PleasureBoatLineModel.h"

@interface CruiseModel : NSObject
@property (nonatomic, strong) PleasureBoatLineModel *cruiseLine;
@property (nonatomic, assign) NSInteger cruise_line_id;
@property (nonatomic, copy) NSString *departure_time;
@property (nonatomic, assign) NSInteger staff_id;
@property (nonatomic, assign) NSInteger the_boat_circulation_records_id;
@property (nonatomic, assign) NSInteger choose_pleasure_boat_id;
@property (nonatomic, copy) NSString *hitting_time;
@property (nonatomic, assign) NSInteger boarding_number;
@property (nonatomic, strong) PleasureBoatModel *pleasureBoat;

@end
