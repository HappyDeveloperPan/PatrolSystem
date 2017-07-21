//
//  CriticizeModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/7.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CriticizeModel : NSObject
@property (nonatomic, copy) NSString *criticize_time;
@property (nonatomic, copy) NSString *leader_account_name;
@property (nonatomic, copy) NSString *criticize_type_name;
@property (nonatomic, assign) NSInteger criticize_type_id;
@property (nonatomic, assign) NSInteger leader_account_id;
@property (nonatomic, assign) NSInteger examine_approve_sign_id;
@end
