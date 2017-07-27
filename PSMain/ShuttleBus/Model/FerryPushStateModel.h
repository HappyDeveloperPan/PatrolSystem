//
//  FerryPushStateModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/26.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FerryPushStateModel : NSObject
@property (nonatomic, copy) NSString *ferry_push_state;
@property (nonatomic, assign) int ferry_push_state_id;

@property (nonatomic, assign) int ferry_push_record_state_id;
@property (nonatomic, copy) NSString *ferry_push_record_state_name;

@end
