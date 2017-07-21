//
//  BoatReportView.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/17.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoatReportView : UIView
@property (nonatomic, strong) UILabel *nameLab, *workTypeLab, *phoneLab, *pickLab, *taskLab;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) void (^submitBtnBlock)();
@property (nonatomic, copy) void (^pickBtnBlock)();
@property (nonatomic, copy) void (^closeBtnBlock)();

- (instancetype)initWithFrame:(CGRect)frame andState:(NSInteger)state;
@end
