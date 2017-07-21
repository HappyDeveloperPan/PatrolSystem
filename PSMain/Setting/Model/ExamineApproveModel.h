//
//  ExamineApproveModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/7.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamineApproveModel : NSObject
@property (nonatomic, copy) NSString *examine_approve_sign_cause;
@property (nonatomic, copy) NSString *examine_approve_type_name;
@property (nonatomic, copy) NSString *staff_name;
@property (nonatomic, assign) NSInteger examine_approve_sign_id;
@property (nonatomic, assign) NSInteger examine_approve_type_id;
@property (nonatomic, assign) NSInteger clock_reason_type_id;
@property (nonatomic, copy) NSString *staff_phone;
@property (nonatomic, assign) NSInteger staff_id;
@property (nonatomic, copy) NSString *examine_approve_sign_time;
@property (nonatomic, copy) NSString *clock_reason_type_name;
@end
