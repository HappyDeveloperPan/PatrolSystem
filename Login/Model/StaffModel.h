//
//  StaffModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/12.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffModel : NSObject
//"staff_sex" : "男",
//"staff_age" : 22,
//"type_of_work_id" : 2,
//"staff_name" : "潘柯宏",
//"staff_phone" : "18311187270"
@property (nonatomic, copy) NSString *staff_sex;
@property (nonatomic, copy) NSString *staff_age;
@property (nonatomic, assign) NSInteger type_of_work_id;
@property (nonatomic, copy) NSString *staff_name;
@property (nonatomic, copy) NSString *staff_phone;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) BOOL sign_in; //是否签到
@property (nonatomic, assign) BOOL task;    //是否选择任务
@property (nonatomic, assign) BOOL workTools;   //是否选择任务工具
@property (nonatomic, assign) BOOL seekHelp;    //是否开启一键求助
//一键求助
@property (nonatomic, assign) NSInteger emergency_calling_id; //求助id
@property (nonatomic, copy) NSString *start_time; //开始求助时间
@property (nonatomic, copy) NSString *origin;  //求助原因
@property (nonatomic, assign) NSInteger emergency_calling_type_id; //求助状态id
@property (nonatomic, copy) NSString *emergency_calling_type;  //求助状态名称
//安保异常

- (NSString *)workType;
@end
