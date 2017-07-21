//
//  NotifModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/22.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushBodyModel.h"

@interface NotifModel : NSObject
@property (nonatomic, assign) NSInteger push_data_id;
@property (nonatomic, assign) NSInteger system_push_id;
@property (nonatomic, copy) NSString *alert;
@property (nonatomic, assign) NSInteger sender;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *push_time;
@property (nonatomic, assign) NSInteger background_push_id;
@property (nonatomic, strong) PushBodyModel *push_attach_data;
@end
