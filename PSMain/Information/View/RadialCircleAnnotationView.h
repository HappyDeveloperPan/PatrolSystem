//
//  RadialCircleAnnotationView.h
//  AMapRadialCircleDemo
//
//  Created by liubo on 11/23/16.
//  Copyright © 2016 AutoNavi. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "HelpModel.h"

@interface RadialCircleAnnotationView : MAAnnotationView

@property (nonatomic, assign) NSInteger pulseCount;
@property (nonatomic, assign) double animationDuration;
@property (nonatomic, assign) double baseDiameter;
@property (nonatomic, assign) double scale;

@property (nonatomic, strong) CALayer *fixedLayer;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;

@property (nonatomic, strong) UIView *calloutView;
@property (nonatomic, strong) UILabel *nameLab, *phoneLab, *reportLab;
@property (nonatomic, strong) HelpModel *helpModel;

- (void)startPulseAnimation;
- (void)stopPulseAnimation;

- (void)showHelpStaffData:(HelpModel *)helpModel;

@end
