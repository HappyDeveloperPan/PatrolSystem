//
//  ChooseShuttleBusesModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/26.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChooseShuttleBusesModel : NSObject
@property (nonatomic, assign) int choose_shuttle_buses_id;
@property (nonatomic, assign) int staff_id;
@property (nonatomic, assign) int ferry_push_id;
@property (nonatomic, copy) NSString *start_time;

@end
