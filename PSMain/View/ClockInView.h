//
//  ClockInView.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/20.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClockInView : UIView
@property (nonatomic, strong) UILabel *nameLab, *workTypeLab, *phoneLab, *pickLab, *taskLab, *pickLab1, *taskLab1;
@property (nonatomic,copy) void (^pickBtnBlock)();
@property (nonatomic,copy) void (^submitBtnBlock)();
@property (nonatomic,copy) void (^pickBtnBlock1)();
@property (nonatomic, copy) void (^closeBtnBlock)();
@end
