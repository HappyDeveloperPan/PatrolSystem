//
//  RetroactiveView.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/27.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RetroactiveView : UIView
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, copy) void(^leaveBtnBlock)();
@property (nonatomic, copy) void(^evectionBtnBlock)();
@property (nonatomic, copy) void(^closeBtnBlock)();
@property (nonatomic, copy) void(^retroactiveBlock)();
@end
