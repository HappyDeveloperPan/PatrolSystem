//
//  RetroListModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/6.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExamineApproveModel.h"
#import "CriticizeModel.h"
#import "ExamineApproveFillTimesModel.h"

@interface RetroListModel : NSObject
@property (nonatomic, strong) ExamineApproveModel *examineApprove;
@property (nonatomic, strong) CriticizeModel *criticize;
@property (nonatomic, strong) NSArray <ExamineApproveFillTimesModel *> *examineApproveFillTimes;
@end
