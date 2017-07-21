//
//  SubmitReportView.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/21.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "SubmitReportView.h"

@implementation SubmitReportView

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
        
        /***/
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
        /***/
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        titleLab.text = @"提交报告";
//        titleLab.backgroundColor = kColorMain;
        titleLab.textColor = kColorWhite;
        titleLab.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:titleLab];
        //利用BezierPath设置圆角
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titleLab.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = titleLab.bounds;
//        maskLayer.path = maskPath.CGPath;
//        titleLab.layer.mask = maskLayer;
        
        
        CGFloat top;
//        if ([UserManager sharedManager].user.staff.type_of_work_id == 1) {
//            UILabel *switchLab = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLab.bottom + 20, 150, 30)];
//            switchLab.text = @"巡逻区域是否正常 : ";
//            switchLab.textColor = kColorMajor;
//            [self addSubview:switchLab];
//            
//            _normalSW = [[UISwitch alloc] init];
//            [self addSubview:_normalSW];
//            [_normalSW mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(-15);
//                make.top.mas_equalTo(titleLab.mas_bottom).mas_equalTo(20);
//            }];
//            
//            top = switchLab.bottom + 20;
//        }else {
//            
//        }
        top = topView.bottom + 20;
        
        UILabel *warningLab = [[UILabel alloc] initWithFrame:CGRectMake(15, top, self.width - 30, 30)];
        warningLab.text = @"*请上传报告和图片";
        warningLab.font = [UIFont systemFontOfSize:15];
        warningLab.textColor = kColorMajor;
        [self addSubview:warningLab];
        
        //评价栏
        _myTextView = [[MyTextView alloc] initWithFrame:CGRectMake(15, warningLab.bottom + 10, self.width - 30, 140)];
        _myTextView.placeholder = @"工作报告....(选填)";
        _myTextView.font = [UIFont systemFontOfSize:14];
        _myTextView.backgroundColor = kColorBg;
//        _myTextView.clearsOnInsertion = YES; //是否直接弹出键盘
        [self addSubview:_myTextView];
        
        //添加图片
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, _myTextView.bottom + 10, self.width - 30, 100) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
//        [_collectionView registerClass:[ImgCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        [self addSubview:_collectionView];
        
        //提交按钮
        UIButton *submitBtn = [[UIButton alloc] init];
        [self addSubview:submitBtn];
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.width.mas_equalTo(self.width - 50);
            make.height.mas_equalTo(50);
            make.bottom.mas_equalTo(-15);
        }];
        submitBtn.backgroundColor = RGBColor(25, 182, 158);
        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        submitBtn.layer.cornerRadius = 6;
        [submitBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.minimumInteritemSpacing = 5;
        _flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _flowLayout.itemSize = CGSizeMake(80, 80);
    }
    return _flowLayout;
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
