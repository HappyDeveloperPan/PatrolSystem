//
//  LineAreaModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/21.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineAreaModel : NSObject
//保洁
@property (nonatomic, copy) NSString *cleaning_area_name;
@property (nonatomic, assign) NSInteger cleaning_area_id;   //范围id
@property (nonatomic, assign) NSInteger cleaning_area_limit_id; //规则id
@end
