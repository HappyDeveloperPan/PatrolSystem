//
//  PunchCardView.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/12.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "PunchCardView.h"

@implementation PunchCardView

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
        
        //标题
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
        _titleLab.text = @"考勤";
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
        
        //查看详情
        UIButton *detailBtn = [[UIButton alloc] init];
        [self addSubview:detailBtn];
        [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(-75);
            make.bottom.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake((self.width/2) - 22.5, 40));
        }];
        detailBtn.backgroundColor = RGBColor(25, 182, 158);
        [detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        detailBtn.layer.cornerRadius = 5;
        [detailBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        detailBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [detailBtn addTarget:self action:@selector(detailBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //提交按钮
        UIButton *closeBtn = [[UIButton alloc] init];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(75);
            make.bottom.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake((self.width/2) - 22.5, 40));
        }];
        closeBtn.backgroundColor = RGBColor(25, 182, 158);
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        closeBtn.layer.cornerRadius = 5;
        [closeBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)detailBtnClick {
    if (self.detailBtnBlock) {
        self.detailBtnBlock();
    }
}

- (void)closeBtnClick {
    if (self.closeBtnBlock) {
        self.closeBtnBlock();
    }
}

- (void)showPunchCardsWithArr:(NSArray *)array {
    for (int i = 0; i < array.count; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, i * 25 + 70, self.width - 30, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = array[i];
        label.textColor = kColorMajor;
        [self addSubview:label];
    }
}

@end
