//
//  PleasureBoatLineModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/18.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinateModel.h"

@interface PleasureBoatLineModel : NSObject
@property (nonatomic, copy) NSString *cruise_line_name;
@property (nonatomic, copy) NSString *cruise_line_id;
@property (nonatomic, strong) NSArray<CoordinateModel *> *cruise_line;
@end
