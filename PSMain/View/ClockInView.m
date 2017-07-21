//
//  ClockInView.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/20.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "ClockInView.h"

@implementation ClockInView

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
        self.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        self.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        self.layer.shadowRadius = 2;//阴影半径，默认3
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];//光栅化处理
        //        [self.view addSubview:_clockInView];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
        topView.backgroundColor = kColorMain;
        [self addSubview:topView];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = topView.bounds;
        maskLayer.path = maskPath.CGPath;
        topView.layer.mask = maskLayer;
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 50, 0, 50, 50)];
        [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [topView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
        titleLab.text = @"员工提交任务";
//        titleLab.backgroundColor = kColorMain;
        titleLab.textColor = kColorWhite;
        titleLab.textAlignment = NSTextAlignmentCenter;
        //利用BezierPath设置圆角
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titleLab.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = titleLab.bounds;
//        maskLayer.path = maskPath.CGPath;
//        titleLab.layer.mask = maskLayer;
        [topView addSubview:titleLab];
        
        //头像
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, titleLab.bottom + 30, 80, 80)];
        if ([[UserManager sharedManager].user.staff.staff_sex isEqualToString:@"女"]) {
            [imageView setImage:[UIImage imageNamed:@"girl"]];
        }else {
            [imageView setImage:[UIImage imageNamed:@"boy"]];
        }
        [self addSubview:imageView];
        
        //姓名
        UILabel *nameLab = self.nameLab =  [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 15, titleLab.bottom + 10, 200, 30)];
        nameLab.textColor = kColorMajor;
        nameLab.text = [NSString stringWithFormat:@"姓名: %@",[UserManager sharedManager].user.staff.staff_name];
        [self addSubview:nameLab];
        //工种
        UILabel *workTypeLab = self.workTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 15, nameLab.bottom + 10, 200, 30)];
        workTypeLab.textColor = kColorMajor;
        workTypeLab.text = [NSString stringWithFormat:@"工种: %@",[UserManager sharedManager].user.staff.workType];
        [self addSubview:workTypeLab];
        //电话
        UILabel *phoneLab = self.phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 15, workTypeLab.bottom + 10, 200, 30)];
        phoneLab.textColor = kColorMajor;
        phoneLab.text = [NSString stringWithFormat:@"电话: %@",[UserManager sharedManager].user.staff.staff_phone];
        [self addSubview:phoneLab];
        //选择摆渡车
        CGFloat top = self.phoneLab.bottom + 10;
        if ([UserManager sharedManager].user.staff.type_of_work_id == 3) {
            UILabel *pickLab1  = self.pickLab1 = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 15, phoneLab.bottom + 10, 200, 30)];
            pickLab1.textColor = kColorMajor;
            pickLab1.text = @"请选择车辆";
            [self addSubview:pickLab1];
            
            UIButton *pickBtn1 = [[UIButton alloc] init];
            [self addSubview:pickBtn1];
            [pickBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(phoneLab.mas_bottom).mas_equalTo(15);
                make.left.mas_equalTo(imageView.mas_right).mas_equalTo(40);
                make.width.mas_equalTo(160);
            }];
            [pickBtn1 setImage:[UIImage imageNamed:@"right_goto"] forState:UIControlStateNormal];
            [pickBtn1 addTarget:self action:@selector(pickBtnClick1) forControlEvents:UIControlEventTouchUpInside];
            pickBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            
            UILabel *cleanLab1 = self.taskLab1 = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 15, pickLab1.bottom + 10, 200, 30)];
            cleanLab1.textColor = kColorMajor;
            [self addSubview:cleanLab1];
            top = cleanLab1.bottom + 10;
        }
        //选择游船
        if ([UserManager sharedManager].user.staff.type_of_work_id == 4) {
        }
        //选择任务
        UILabel *pickLab  = self.pickLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 15, top, 200, 30)];
        pickLab.textColor = kColorMajor;
        pickLab.text = @"请选择任务";
        [self addSubview:pickLab];
        
        UIButton *pickBtn = [[UIButton alloc] init];
        [self addSubview:pickBtn];
        [pickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(phoneLab.mas_bottom).mas_equalTo(15);
            make.centerY.mas_equalTo(pickLab.mas_centerY);
            make.left.mas_equalTo(imageView.mas_right).mas_equalTo(40);
            make.width.mas_equalTo(160);
        }];
        [pickBtn setImage:[UIImage imageNamed:@"right_goto"] forState:UIControlStateNormal];
        [pickBtn addTarget:self action:@selector(pickBtnClick) forControlEvents:UIControlEventTouchUpInside];
        pickBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        UILabel *cleanLab = self.taskLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 15, pickLab.bottom + 10, 200, 30)];
        cleanLab.textColor = kColorMajor;
        [self addSubview:cleanLab];
        
        //提交按钮
        UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, cleanLab.bottom + 15, self.width - 50, 50)];
        submitBtn.backgroundColor = RGBColor(25, 182, 158);
        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        submitBtn.layer.cornerRadius = 6;
        [submitBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:submitBtn];
    }
    return self;
}

- (void)pickBtnClick {
    if (self.pickBtnBlock) {
        self.pickBtnBlock();
    }
}

- (void)pickBtnClick1 {
    if (self.pickBtnBlock1) {
        self.pickBtnBlock1();
    }
}

- (void)submitBtnClick {
    if (self.submitBtnBlock) {
        self.submitBtnBlock();
    }
}

- (void)closeBtnClick {
    [self removeFromSuperview];
    if (self.closeBtnBlock) {
        self.closeBtnBlock();
    }
}

@end
