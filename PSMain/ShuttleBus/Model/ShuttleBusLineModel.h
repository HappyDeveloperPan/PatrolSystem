//
//  ShuttleBusLineModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/15.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinateModel.h"
#import "LineAreaModel.h"

@interface ShuttleBusLineModel : NSObject
@property (nonatomic, copy) NSString *ferry_push_line_id;
@property (nonatomic, copy) NSString *ferry_push_line_name;
@property (nonatomic, strong) NSArray<CoordinateModel *> *ferry_push_line;

@property (nonatomic, strong) LineAreaModel *feeryPushLine;
@property (nonatomic, strong) NSArray <CoordinateModel *> *ferryPushLineLatlngs;
@end
