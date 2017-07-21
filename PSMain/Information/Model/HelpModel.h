//
//  HelpModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/7/14.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HelpDisposeStaffsModel.h"
#import "EmergencyCallingTypeModel.h"
#import "EmergencyCallingAccomplishModel.h"
#import "StaffOnLineModel.h"
#import "HelpDisposeStaffOnLineModel.h"
#import "HelpDisposeModel.h"
#import "EmergencyCallingModel.h"
#import "PicturesModel.h"
#import "LeaderModel.h"

@interface HelpModel : NSObject

@property (nonatomic, assign) BOOL isOpenHelp; //是否开启一键求助
@property (nonatomic, assign) BOOL isHandle; //后台是否响应一键求助
@property (nonatomic, assign) BOOL isComplete; //后台是否完成一键求助,根据此字段断开tcp

@property (nonatomic, strong) NSArray <HelpDisposeStaffsModel *> *emergencyCallingDisposeStaffs;
@property (nonatomic, strong) EmergencyCallingTypeModel *emergencyCallingType;
@property (nonatomic, strong) EmergencyCallingAccomplishModel *emergencyCallingAccomplish;
@property (nonatomic, strong) StaffOnLineModel *staffOnLine;
@property (nonatomic, strong) NSArray <HelpDisposeStaffOnLineModel *> *emergencyCallingDisposeStaffOnLine;
@property (nonatomic, strong) HelpDisposeModel *emergencyCallingDispose;
@property (nonatomic, strong) EmergencyCallingModel *emergencyCalling;
@property (nonatomic, strong) NSArray <PicturesModel *> *emergencyCallingPictures;
@property (nonatomic, strong) LeaderModel *leaderAccount;

@property (nonatomic, strong) NSArray <StaffOnLineModel *> *helpStaffs;
@end
