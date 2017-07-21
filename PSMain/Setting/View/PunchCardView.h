//
//  PunchCardView.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/12.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PunchCardView : UIView
@property (nonatomic, copy) void(^closeBtnBlock)();
@property (nonatomic, copy) void(^detailBtnBlock)();
@property (nonatomic, strong) UILabel *titleLab;


- (void)showPunchCardsWithArr:(NSArray *)array;
@end
