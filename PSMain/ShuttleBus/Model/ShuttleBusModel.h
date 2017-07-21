//
//  ShuttleBusModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/15.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShuttleBusModel : NSObject
@property (nonatomic, copy) NSString *ferry_push_state;
@property (nonatomic, copy) NSString *ferry_push;
@property (nonatomic, assign) NSInteger ferry_push_state_id;
@property (nonatomic, copy) NSString *ferry_push_id;

@end
