//
//  CheckStateView.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/5.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "CheckStateView.h"

@implementation CheckStateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorWhite;
        self.layer.cornerRadius = 5;
        
        UILabel *topLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
        topLab.text = @"我的考勤";
        topLab.backgroundColor = kColorMain;
        topLab.textColor = kColorWhite;
        topLab.textAlignment = NSTextAlignmentCenter;
        //利用BezierPath设置圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topLab.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = topLab.bounds;
        maskLayer.path = maskPath.CGPath;
        topLab.layer.mask = maskLayer;
        [self addSubview:topLab];
        
        //标题
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(5, topLab.bottom + 15, self.width-10, 30)];
        _titleLb.textColor = kColorWhite;
        _titleLb.textColor = kColorMajor;
        _titleLb.textAlignment = NSTextAlignmentCenter;
        //利用BezierPath设置圆角
        [self addSubview:_titleLb];
        
        //申请补签
         _checkBtn= [[UIButton alloc] init];
        [self addSubview:_checkBtn];
        [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(_titleLb.mas_bottom).mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(120, 30));
        }];
//        _checkBtn.layer.cornerRadius = 5;
//        _checkBtn.backgroundColor = kColorMain;
        [_checkBtn setTitle:@"申请补签" forState:UIControlStateNormal];
        [_checkBtn setTitleColor:KcolorRed forState:UIControlStateNormal];
        [_checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(8,  28, 100, 1)];
        lineView.backgroundColor = KcolorRed;
        [_checkBtn addSubview:lineView];
        //关闭
        _closeBtn = [[UIButton alloc] init];
        [self addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(120, 30));
        }];
        _closeBtn.layer.cornerRadius = 5;
        _closeBtn.backgroundColor = kColorMain;
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)checkBtnClick {
    if (self.checkBtnBlock) {
        self.checkBtnBlock();
    }
}

- (void)closeBtnClick {
    if (self.closeBtnBlock) {
        self.closeBtnBlock();
    }
}

@end
