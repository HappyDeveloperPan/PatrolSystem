//
//  RetroListTableViewCell.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/6.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "RetroListTableViewCell.h"

@implementation RetroListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.retroLb = [[UILabel alloc] init];
//    [self.contentView addSubview:self.retroLb];
//    [self.retroLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10);
//        make.top.mas_equalTo(10);
//        make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - 20, 20));
//    }];
//    
//    self.typeLb = [[UILabel alloc] init];
//    [self.contentView addSubview:self.typeLb];
//    [self.typeLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10);
//        make.top.mas_equalTo(self.retroLb.mas_bottom).mas_equalTo(5);
//        make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - 20, 20));
//    }];
//    
//    self.progressLb = [[UILabel alloc] init];
//    [self.contentView addSubview:self.progressLb];
//    [self.progressLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10);
//        make.bottom.mas_equalTo(-10);
//        make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - 20, 20));
//    }];
//    
//    self.timeLb = [[UILabel alloc] init];
//    [self.contentView addSubview:self.timeLb];
//    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10);
//        make.bottom.mas_equalTo(self.progressLb.mas_top).mas_equalTo(5);
//        make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - 20, 20));
//    }];
//    
//    self.reasonLb = [[UILabel alloc] init];
//    [self.contentView addSubview:self.reasonLb];
//    [self.reasonLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10);
//        make.top.mas_equalTo(self.typeLb.mas_bottom).mas_equalTo(5);
//        make.width.mas_equalTo(kMainScreenWidth - 20);
//        make.bottom.mas_equalTo(self.timeLb.mas_top).mas_equalTo(5);
//    }];
//    self.reasonLb.numberOfLines = 0;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //我的考勤
        self.retroLb = [[UILabel alloc] init];
        [self.contentView addSubview:self.retroLb];
        [self.retroLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - 20, 20));
        }];
        self.retroLb.font = [UIFont systemFontOfSize:16.5];
        
        //申请类型
        self.typeLb = [[UILabel alloc] init];
        [self.contentView addSubview:self.typeLb];
        [self.typeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.retroLb.mas_bottom).mas_equalTo(5);
            make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - 20, 20));
        }];
        self.typeLb.textColor = kColorMajor;
        self.typeLb.font = [UIFont systemFontOfSize:15];
        
        //申请进度
        self.progressLb = [[UILabel alloc] init];
        [self.contentView addSubview:self.progressLb];
        [self.progressLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - 20, 20));
        }];
        self.progressLb.textColor = kColorMajor;
        self.progressLb.font = [UIFont systemFontOfSize:15];
        
        //申请时间
        self.timeLb = [[UILabel alloc] init];
        [self.contentView addSubview:self.timeLb];
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(self.progressLb.mas_top).mas_equalTo(-5);
            make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - 20, 20));
        }];
        self.timeLb.textColor = kColorMajor;
        self.timeLb.font = [UIFont systemFontOfSize:15];
        
        //申请原因
        self.reasonLb = [[UILabel alloc] init];
        [self.contentView addSubview:self.reasonLb];
        [self.reasonLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.typeLb.mas_bottom).mas_equalTo(5);
            make.width.mas_equalTo(kMainScreenWidth - 20);
            make.bottom.mas_equalTo(self.timeLb.mas_top).mas_equalTo(-5);
        }];
        self.reasonLb.numberOfLines = 0;
        self.reasonLb.textColor = kColorMajor;
        self.reasonLb.font = [UIFont systemFontOfSize:15];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = RGBColor(241, 241, 241);
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setDataWithModel:(RetroListModel *)model {
    for (int i = 0; i < model.examineApproveFillTimes.count; i ++) {
        ExamineApproveFillTimesModel *timeModel = model.examineApproveFillTimes[i];
        if (i == 0) {
            self.retroLb.text = [NSString stringWithFormat:@"我的考勤: %@",timeModel.examine_approve_sign_state];
            self.timeLb.text = [NSString stringWithFormat:@"申请时间: %@",timeModel.examine_approve_fill_time];
        }else {
            self.retroLb.text = [NSString stringWithFormat:@"%@,%@",self.retroLb.text,timeModel.examine_approve_sign_state];
            self.timeLb.text = [NSString stringWithFormat:@"%@,%@",self.timeLb.text,timeModel.examine_approve_fill_time];
        }
    }
    
    NSString *typeStr = [NSString stringWithFormat:@"申请类型: %@",model.examineApprove.clock_reason_type_name];
    self.typeLb.attributedText = [Common colorTextWithString:typeStr andRange:model.examineApprove.clock_reason_type_name andColor:RGBColor(248, 117, 69)];
    self.reasonLb.text = [NSString stringWithFormat:@"申请原因: %@",model.examineApprove.examine_approve_sign_cause];
    if ([model.examineApprove.examine_approve_type_name isEqualToString:@"待审批"]) {
        NSString *str = [NSString stringWithFormat:@"审核进度: %@",model.examineApprove.examine_approve_type_name];
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attriStr addAttributes:@{NSForegroundColorAttributeName:RGBColor(248, 200, 37)} range:[str rangeOfString:model.examineApprove.examine_approve_type_name]];
        self.progressLb.attributedText = attriStr;
    }else {
        NSString *str = [NSString stringWithFormat:@"审核进度: %@",model.criticize.criticize_type_name];
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
        if ([model.criticize.criticize_type_name isEqualToString:@"通过"]) {
            [attriStr addAttributes:@{NSForegroundColorAttributeName:kColorGreen} range:[str rangeOfString:model.criticize.criticize_type_name]];
        }else {
            [attriStr addAttributes:@{NSForegroundColorAttributeName:KcolorRed} range:[str rangeOfString:model.criticize.criticize_type_name]];
        }
        self.progressLb.attributedText = attriStr;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
