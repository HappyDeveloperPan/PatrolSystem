//
//  StaffAnnotationView.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/17.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "HelpModel.h"

@interface StaffAnnotationView : MAAnnotationView
@property (nonatomic, strong) StaffOnLineModel *staffModel;
@property (nonatomic, strong) UIView *calloutView;
@property (nonatomic, strong) UILabel *nameLab, *phoneLab, *reportLab;
@end
