//
//  EmergencyCallingAccomplishModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/7/14.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmergencyCallingAccomplishModel : NSObject
@property (nonatomic, copy) NSString *ccomplish_time; //完成时间
@property (nonatomic, copy) NSString *summarize; // 总结
@property (nonatomic, assign) NSInteger emergency_calling_id;

@end
