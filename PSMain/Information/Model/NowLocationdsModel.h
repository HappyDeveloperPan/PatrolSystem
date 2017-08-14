//
//  NowLocationdsModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/8/1.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NowLocationdsModel : NSObject
@property (nonatomic, copy) NSString *report;
@property (nonatomic, assign) int the_security_line_latlng_id;
@property (nonatomic, assign) int nowLocationdId_state_id;
@property (nonatomic, assign) int nowLocationdId;
@property (nonatomic, copy) NSString *completion_time;
@property (nonatomic, assign) int security_patrol_record_id;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lng;
@end
