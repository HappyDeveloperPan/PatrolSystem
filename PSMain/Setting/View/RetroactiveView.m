//
//  RetroactiveView.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/27.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "RetroactiveView.h"

@implementation RetroactiveView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorWhite;
        self.layer.cornerRadius = 6;
        
        //标题
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
        _titleLab.text = @"修改状态";
        _titleLab.backgroundColor = kColorMain;
        _titleLab.textColor = kColorWhite;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        //利用BezierPath设置圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_titleLab.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6,6)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _titleLab.bounds;
        maskLayer.path = maskPath.CGPath;
        _titleLab.layer.mask = maskLayer;
        [self addSubview:_titleLab];
        
        //请假
        UIButton *leaveBtn = [[UIButton alloc] init];
        [self addSubview:leaveBtn];
        [leaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(_titleLab.mas_bottom).mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(120, 40));
        }];
        leaveBtn.layer.cornerRadius = 5;
        leaveBtn.backgroundColor = kColorMain;
        [leaveBtn setTitle:@"请假" forState:UIControlStateNormal];
        [leaveBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        [leaveBtn addTarget:self action:@selector(leaveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //出差
        UIButton *evectionBtn = [[UIButton alloc] init];
        [self addSubview:evectionBtn];
        [evectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(leaveBtn.mas_bottom).mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(120, 40));
        }];
        evectionBtn.layer.cornerRadius = 5;
        evectionBtn.backgroundColor = kColorMain;
        [evectionBtn setTitle:@"出差" forState:UIControlStateNormal];
        [evectionBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        [evectionBtn addTarget:self action:@selector(evectionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //补签
//        UIButton *retroactiveBtn = [[UIButton alloc] init];
//        [self addSubview:retroactiveBtn];
//        [retroactiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(0);
//            make.top.mas_equalTo(evectionBtn.mas_bottom).mas_equalTo(20);
//            make.size.mas_equalTo(CGSizeMake(120, 40));
//        }];
//        retroactiveBtn.layer.cornerRadius = 5;
//        retroactiveBtn.backgroundColor = kColorMain;
//        [retroactiveBtn setTitle:@"补签" forState:UIControlStateNormal];
//        [retroactiveBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
//        [retroactiveBtn addTarget:self action:@selector(retroactiveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //提交按钮
        UIButton *closeBtn = [[UIButton alloc] init];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(self.width, 50));
        }];
        closeBtn.backgroundColor = RGBColor(25, 182, 158);
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        //利用BezierPath设置圆角
//        UIBezierPath *bottomMaskPath = [UIBezierPath bezierPathWithRoundedRect:closeBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(6,6)];
//        CAShapeLayer *bottomMaskLayer = [[CAShapeLayer alloc] init];
//        bottomMaskLayer.frame = closeBtn.bounds;
//        bottomMaskLayer.path = bottomMaskPath.CGPath;
//        closeBtn.layer.mask = bottomMaskLayer;
        
        [closeBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)closeBtnClick {
    if (self.closeBtnBlock) {
        self.closeBtnBlock();
    }
}

- (void)evectionBtnClick {
    if (self.evectionBtnBlock) {
        self.evectionBtnBlock();
    }
}

- (void)leaveBtnClick {
    if (self.leaveBtnBlock) {
        self.leaveBtnBlock();
    }
}

- (void)retroactiveBtnClick {
    if (self.retroactiveBlock) {
        self.retroactiveBlock();
    }
}

@end
