//
//  ChoosePleasureBoatModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/27.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChoosePleasureBoatModel : NSObject
@property (nonatomic, assign) int staff_id;
@property (nonatomic, assign) int choose_pleasure_boat_id;
@property (nonatomic, assign) int pleasure_boat_id;
@property (nonatomic, copy) NSString *start_time;

@end
