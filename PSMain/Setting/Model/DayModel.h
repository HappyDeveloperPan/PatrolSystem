//
//  DayModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/12.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaffStateModel.h"

@interface DayModel : NSObject
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, strong) StaffStateModel *staffStateSM;

@end
