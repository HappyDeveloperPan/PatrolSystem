//
//  SecurityModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/5.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LineModel.h"

@interface SecurityModel : NSObject
@property (nonatomic, copy) NSString *security_patrol_over_time;
@property (nonatomic, assign) NSInteger staff_id;
@property (nonatomic, strong) LineModel *theSecurityLine;
@property (nonatomic, assign) NSInteger the_security_line_id;
@property (nonatomic, assign) NSInteger security_patrol_record_id;
@property (nonatomic, copy) NSString *security_patrol_start_time;
@property (nonatomic, assign) BOOL isEnter;
@property (nonatomic, assign) int distance;


@end
