//
//  SecurityReportView.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/23.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "SecurityReportView.h"

@implementation SecurityReportView

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
        
        self.state = 10;
        
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
        titleLab.text = @"提交报告";
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
        
//        UILabel *securityLab = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLab.bottom + 15, 150, 30)];
        UILabel *securityLab = [[UILabel alloc] init];
        CGSize size = [Common sizeWithString:@"区域是否正常: " width:300 font:15];
        securityLab.frame = CGRectMake(15, titleLab.bottom + 15, size.width, 30);
        securityLab.text = @"区域是否正常:";
        securityLab.font = [UIFont systemFontOfSize:15];
        securityLab.textColor = kColorMajor;
        [self addSubview:securityLab];
        
        
        self.buttonArr = [NSMutableArray new];
        UIImage *checkImg = [UIImage imageNamed:@"checkmark"];
        UIImage *uncheckImg = [UIImage imageNamed:@"checkmark-2"];
        
        UIButton *checkOne = [[UIButton alloc] initWithFrame:CGRectMake(securityLab.right + 5, titleLab.bottom + 15, 30, 30)];
        [checkOne setBackgroundImage:uncheckImg forState:UIControlStateNormal];//正常状态图片是非选中的
        [checkOne setBackgroundImage:checkImg forState:UIControlStateSelected];
        checkOne.tag = 10;
        checkOne.selected = YES; //初始化默认选择IP方式
        [checkOne addTarget:self action:@selector(checkBoxClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArr addObject:checkOne];
        [self addSubview:checkOne];
        UILabel *checkLbOne = [[UILabel alloc] initWithFrame:CGRectMake(checkOne.right + 5, titleLab.bottom + 10, 40, 40)];
        checkLbOne.text = @"正常";
//        checkLbOne.font = [UIFont systemFontOfSize:14];
        checkLbOne.textColor = kColorMajor;
        [self addSubview:checkLbOne];
        
        UIButton *checkTwo = [[UIButton alloc] initWithFrame:CGRectMake(checkLbOne.right + 20, titleLab.bottom + 15, 30, 30)];
        [checkTwo setBackgroundImage:uncheckImg forState:UIControlStateNormal];//正常状态图片是非选中的
        [checkTwo setBackgroundImage:checkImg forState:UIControlStateSelected];
        checkTwo.tag = 20;
        [checkTwo addTarget:self action:@selector(checkBoxClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArr addObject:checkTwo];
        [self addSubview:checkTwo];
        UILabel *checkLbTwo = [[UILabel alloc] initWithFrame:CGRectMake(checkTwo.right + 5, titleLab.bottom + 10, 40, 40)];
        checkLbTwo.text = @"异常";
//        checkLbTwo.font = [UIFont systemFontOfSize:14];
        checkLbTwo.textColor = kColorMajor;
        [self addSubview:checkLbTwo];
        
        _warningLab = [[UILabel alloc] initWithFrame:CGRectMake(15, checkTwo.bottom + 10, self.width - 30, 30)];
        _warningLab.text = @"*请上传报告和图片";
        _warningLab.font = [UIFont systemFontOfSize:15];
        _warningLab.textColor = kColorMajor;
//        [self addSubview:warningLab];
        
        //评价栏
        _myTextView = [[MyTextView alloc] initWithFrame:CGRectMake(15, _warningLab.bottom + 10, self.width - 30, 140)];
        _myTextView.placeholder = @"工作报告....(选填)";
        _myTextView.font = [UIFont systemFontOfSize:14];
        _myTextView.backgroundColor = kColorBg;
//        [self addSubview:_myTextView];
        
        //添加图片
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, _myTextView.bottom + 10, self.width - 30, 100) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        //        [_collectionView registerClass:[ImgCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
//        [self addSubview:_collectionView];
        
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



- (void)checkBoxClick:(UIButton *)sender {
    for (UIButton *button in self.buttonArr) {
        if (button == sender) {
            [button setSelected:YES];
        }else {
            [button setSelected:NO];
        }
    }
    self.state = sender.tag;
    if (sender.tag == 10) {
        [self.warningLab removeFromSuperview];
        [self.myTextView removeFromSuperview];
        [self.collectionView removeFromSuperview];
        self.size = CGSizeMake(kMainScreenWidth - 50, 200);
    }
    if (sender.tag == 20) {
        [self addSubview:self.warningLab];
        [self addSubview:self.myTextView];
        [self addSubview:self.collectionView];
        self.size = CGSizeMake(kMainScreenWidth - 50, 480);
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
@end
