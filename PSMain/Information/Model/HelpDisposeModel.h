//
//  HelpDisposeModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/7/14.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpDisposeModel : NSObject
@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *dispose_time;
@property (nonatomic, assign) NSInteger leader_account_id;
@property (nonatomic, assign) NSInteger emergency_calling_id;
@end
