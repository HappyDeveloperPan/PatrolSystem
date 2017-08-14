//
//  UnusualModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/8/2.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NowLocationdsModel.h"
#import "NowLocationdIdStateModel.h"
#import "StaffModel.h"
#import "LeaderModel.h"
#import "NowLocationdDisposeModel.h"
#import "NowLocationdAccomplishModel.h"
#import "StaffOnLineModel.h"
#import "AuxiliaryStaffsModel.h"
#import "PicturesModel.h"


@interface UnusualModel : NSObject
@property (nonatomic, strong) NowLocationdIdStateModel *nowLocationdIdState;
@property (nonatomic, strong) NowLocationdsModel *nowLocationds;
@property (nonatomic, strong) StaffModel *staff;
@property (nonatomic, strong) NowLocationdDisposeModel *nowLocationdDispose;
@property (nonatomic, strong) NowLocationdAccomplishModel *nowLocationdAccomplish;
@property (nonatomic, strong) LeaderModel *leaderAccount;
@property (nonatomic, strong) StaffOnLineModel *staffOnline;
@property (nonatomic, strong) NSArray <AuxiliaryStaffsModel *> *auxiliaryStaffs;
@property (nonatomic, strong) NSArray <PicturesModel *> *nowLocationdPictures;
@end
