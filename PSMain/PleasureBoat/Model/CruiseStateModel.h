//
//  CruiseStateModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/27.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CruiseStateModel : NSObject
@property (nonatomic, assign) int pleasure_boat_state_id;
@property (nonatomic, copy) NSString *pleasure_boat_state;
@property (nonatomic, assign) int the_boat_circulation_records_state_id;
@property (nonatomic, copy) NSString *the_boat_circulation_records_state_name;

@end
