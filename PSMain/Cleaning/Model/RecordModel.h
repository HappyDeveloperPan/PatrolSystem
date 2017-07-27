//
//  RecordModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/21.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject
//保洁
@property (nonatomic, copy) NSString *cleaning_the_start_time;
@property (nonatomic, copy) NSString *cleaning_the_end_time;
@property (nonatomic, assign) int cleaning_records_id;
@property (nonatomic, assign) int cleaning_area_id;
@property (nonatomic, assign) int staff_id;
@property (nonatomic, assign) int cleaning_records_state_id;

//摆渡车
@property (nonatomic, assign) int choose_shuttle_buses_id;
@property (nonatomic, assign) int ferry_push_line_id;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, assign) int ferry_push_record_state_id;
@property (nonatomic, assign) int ferry_push_record_id;

@end
