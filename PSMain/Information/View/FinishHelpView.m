//
//  FinishHelpView.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/15.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "FinishHelpView.h"

@interface FinishHelpView()
@property (nonatomic, strong) UIView *mainView;
@end

@implementation FinishHelpView

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
        self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width - 40, self.height * 0.6)];
        self.mainView.backgroundColor = kColorWhite;
        self.mainView.center = self.center;
        [self addSubview:self.mainView];
        self.mainView.layer.cornerRadius = 5;
        self.mainView.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        self.mainView.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.mainView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        self.mainView.layer.shadowRadius = 2;//阴影半径，默认3
        self.mainView.layer.rasterizationScale = [[UIScreen mainScreen] scale];//光栅化处理
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainView.width, 50)];
        topView.backgroundColor = kColorMain;
        [self.mainView addSubview:topView];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = topView.bounds;
        maskLayer.path = maskPath.CGPath;
        topView.layer.mask = maskLayer;
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.mainView.width - 50, 0, 50, 50)];
        [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [topView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.mainView.width, 50)];
        titleLab.text = @"提交报告";
        titleLab.textColor = kColorWhite;
        titleLab.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:titleLab];
        
        //报告
        self.textView = [[MyTextView alloc] initWithFrame:CGRectMake(15, topView.bottom + 10, self.mainView.width - 30, self.mainView.height - 120)];
        self.textView.placeholder = @"工作报告......";
        self.textView.font = [UIFont systemFontOfSize:14];
        self.textView.backgroundColor = kColorBg;
        [self.mainView addSubview:self.textView];
        
        UIButton *submitBtn = [[UIButton alloc] init];
        [self.mainView addSubview:submitBtn];
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(self.mainView.width * 0.5, 40));
        }];
        [submitBtn setTitle:@"提交报告" forState:UIControlStateNormal];
        [submitBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        [submitBtn setBackgroundColor:kColorMain];
        submitBtn.layer.cornerRadius = 5;
        [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)submitBtnClick {
    if (self.submitBtnBlock) {
        self.submitBtnBlock(self.textView.text);
    }
}

- (void)closeBtnClick {
    [self close];
}

@end
