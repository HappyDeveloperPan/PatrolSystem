//
//  NotiInfoTableViewCell.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/20.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "NotiInfoTableViewCell.h"

@implementation NotiInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.redPoint.layer.cornerRadius = 5;
    self.redPoint.clipsToBounds = YES;
    self.redPoint.backgroundColor = KcolorRed;
    self.redPoint.hidden = YES;
    
    self.headImg.layer.cornerRadius = 5;
    self.headImg.clipsToBounds = YES;
    
    self.phoneLb.textColor = kColorMajor;
    
    self.isCompleteLb.textColor = kColorMajor;
    
    self.timeLb.textColor = kColorMajor;
    self.timeLb.textAlignment = NSTextAlignmentRight;
    
//    self.handleBtn = [[UIButton alloc] init];
//    [self addSubview:self.handleBtn];
//    [self.handleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(0);
//        make.right.mas_equalTo(-40);
//        make.size.mas_equalTo(CGSizeMake(80, 30));
//    }];
//    [self.handleBtn setTitle:@"处理" forState:UIControlStateNormal];
//    [self.handleBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
//    [self.handleBtn setBackgroundColor:KcolorRed];
//    self.handleBtn.layer.cornerRadius = 4;
//    self.handleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    self.handleBtn.hidden = NO;
//    [self.handleBtn addTarget:self action:@selector(handleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBColor(241, 241, 241);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setHelpCellData:(StaffModel *)model {
    self.nameLb.text = [NSString stringWithFormat:@"求助者: %@", model.staff_name];
    self.phoneLb.text = [NSString stringWithFormat:@"电话: %@", model.staff_phone];
    self.timeLb.text = model.start_time;
    
    NSString *str = [NSString stringWithFormat:@"状态: %@", model.emergency_calling_type];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
    UIColor *color;
    switch (model.emergency_calling_type_id) {
        case 1: //未处理
            color = [UIColor redColor];
            break;
        case 2: //正在处理
            color = RGBColor(248, 200, 3);
            break;
        case 3: //处理完成
            color = kColorGreen;
            break;
        case 4: //撤销
            color = RGBColor(248, 200, 3);
            break;
        case 5: //已过期
            color = [UIColor redColor];
            break;
        default:
            break;
    }
    [attriStr addAttributes:@{NSForegroundColorAttributeName:color} range:[str rangeOfString:model.emergency_calling_type]];
    self.isCompleteLb.attributedText = attriStr;
}

- (void)setUnusualCellData:(UnusualModel *)model {
    self.nameLb.text = [NSString stringWithFormat:@"求助者: %@", model.staff.staff_name];
    self.phoneLb.text = [NSString stringWithFormat:@"电话: %@", model.staff.staff_phone];
    self.timeLb.text = model.nowLocationds.completion_time;
    NSString *str = [NSString stringWithFormat:@"状态: %@", model.nowLocationdIdState.nowLocationdId_state_name];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
    UIColor *color;
    switch (model.nowLocationdIdState.nowLocationdId_state_id) {
        case 3: //未处理
            color = [UIColor redColor];
            break;
        case 4: //正在处理
            color = RGBColor(248, 200, 3);
            break;
        case 5: //处理完成
            color = kColorGreen;
            break;
        case 6: //已过期
            color = [UIColor redColor];
            break;
        default:
            break;
    }
    [attriStr addAttributes:@{NSForegroundColorAttributeName:color} range:[str rangeOfString:model.nowLocationdIdState.nowLocationdId_state_name]];
    self.isCompleteLb.attributedText = attriStr;
    
}

//- (void)handleHelpStateWithModel:(DetailInfoModel *)model {
//    if (model.isHandle && model.isComplete) {
//        self.handleBtn.hidden = YES;
//    }
//    if (model.isHandle && !model.isComplete) {
//        self.handleBtn.hidden = NO;
//        [self.handleBtn setTitle:@"完成处理" forState:UIControlStateNormal];
//        self.handleBtn.backgroundColor = kColorMain;
//    }
//    if (!model.isHandle) {
//        self.handleBtn.hidden = NO;
//        [self.handleBtn setTitle:@"处理" forState:UIControlStateNormal];
//        self.handleBtn.backgroundColor = KcolorRed;
//    }
//}

//- (void)handleUnusualStateWithModel:(DetailInfoModel *)model {
//    if (model.isDispose && model.isComplete) {
//        self.handleBtn.hidden = YES;
//    }
//    if (model.isDispose && !model.isComplete) {
//        self.handleBtn.hidden = NO;
//        [self.handleBtn setTitle:@"完成处理" forState:UIControlStateNormal];
//        self.handleBtn.backgroundColor = kColorMain;
//    }
//    if (!model.isDispose) {
//        self.handleBtn.hidden = NO;
//        [self.handleBtn setTitle:@"处理" forState:UIControlStateNormal];
//        self.handleBtn.backgroundColor = KcolorRed;
//    }
//}
//
//- (void)handleBtnClick:(UIButton *)sender {
//    if (self.handleBtnBlock) {
//        self.handleBtnBlock();
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
