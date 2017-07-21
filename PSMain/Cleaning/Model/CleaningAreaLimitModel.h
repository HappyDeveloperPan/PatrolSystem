//
//  CleaningAreaLimitModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/21.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CleaningAreaLimitModel : NSObject
@property (nonatomic, assign) NSInteger least_clean_time;
@property (nonatomic, assign) NSInteger biggest_clean_time;
@property (nonatomic, assign) NSInteger cleaning_area_limit_id;
@end
