//
//  ShuttleBusTaskModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/15.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShuttleBusLineModel.h"

@interface ShuttleBusTaskModel : NSObject
@property (nonatomic, assign) NSInteger choose_shuttle_buses_id;
@property (nonatomic, copy) NSString *receipt_time;
@property (nonatomic, assign) NSInteger ferry_push_line_id;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, assign) NSInteger staff_id;
@property (nonatomic, strong) ShuttleBusLineModel *feeryPushLine;


@end
