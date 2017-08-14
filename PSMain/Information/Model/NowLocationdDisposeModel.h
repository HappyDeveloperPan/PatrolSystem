//
//  NowLocationdDisposeModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/8/1.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NowLocationdDisposeModel : NSObject
@property (nonatomic, assign) int nowLocationdId;
@property (nonatomic, assign) int leader_account_id;
@property (nonatomic, copy) NSString *dispose_result;
@property (nonatomic, copy) NSString *dispose_time;

@end
