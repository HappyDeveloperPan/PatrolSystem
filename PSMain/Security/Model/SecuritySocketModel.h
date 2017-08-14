//
//  SecuritySocketModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/8.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinateModel.h"

@interface SecuritySocketModel : NSObject
@property (nonatomic, copy) NSString *entryTime;
@property (nonatomic, copy) NSString *outTime;
@property (nonatomic, strong) CoordinateModel *coordinateScope;
@property (nonatomic, assign) BOOL enter; //是否进入巡逻点
@property (nonatomic, assign) BOOL enough_time;  //是否停留足够长的时间
@property (nonatomic, assign) BOOL upload;    //是否上传任务
@property (nonatomic, assign) BOOL complete; //任务是否全部完成,断开TCP
@end
