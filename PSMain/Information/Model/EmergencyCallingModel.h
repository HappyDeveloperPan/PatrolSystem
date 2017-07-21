//
//  EmergencyCallingModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/7/14.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmergencyCallingModel : NSObject
@property (nonatomic, copy) NSString *origin;
@property (nonatomic, assign) NSInteger emergency_calling_id;
@property (nonatomic, assign) NSInteger emergency_calling_type_id;
@property (nonatomic, assign) NSInteger staff_id;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lng;
@end
