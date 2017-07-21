//
//  PSUser.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/10.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaffModel.h"

@interface PSUser : NSObject
@property (nonatomic, strong) StaffModel *staff;
@property (nonatomic, copy) NSString *account_token;

@end


//@interface StaffModel : NSObject
////"staff_sex" : "男",
////"staff_age" : 22,
////"type_of_work_id" : 2,
////"staff_name" : "潘柯宏",
////"staff_phone" : "18311187270"
//@property (nonatomic, copy) NSString *staff_sex;
//@property (nonatomic, copy) NSString *staff_age;
//@property (nonatomic, copy) NSString *type_of_work_id;
//@property (nonatomic, copy) NSString *staff_name;
//@property (nonatomic, copy) NSString *staff_phone;
//@property (nonatomic, copy) NSString *token;
//@end


