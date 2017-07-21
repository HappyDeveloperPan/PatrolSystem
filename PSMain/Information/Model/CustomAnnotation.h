//
//  CustomAnnotation.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/17.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "HelpModel.h"

@interface CustomAnnotation : MAPointAnnotation
@property (nonatomic, strong) StaffOnLineModel *staffModel;
@end
