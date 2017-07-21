//
//  NotifTableViewCell.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/22.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "NotifTableViewCell.h"

@implementation NotifTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    self.redPoint.layer.cornerRadius = 5;
    self.redPoint.clipsToBounds = YES;
    self.redPoint.backgroundColor = KcolorRed;
    self.redPoint.hidden = YES;
    
    self.headImage.layer.cornerRadius = 5;
    self.headImage.clipsToBounds = YES;
    
    self.titleLab.font = [UIFont systemFontOfSize:18];
    
    self.timeLab.font = [UIFont systemFontOfSize:15];
    self.timeLab.textColor = kColorMajor;
    
    self.contentLab.textColor = kColorMajor;
    self.contentLab.font = [UIFont systemFontOfSize:14];
    self.contentLab.textAlignment = NSTextAlignmentRight;
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title andSubtitle:(NSString *)content andTime:(NSString *)time {
    self.titleLab.text = title;
    self.contentLab.text = time;
    self.timeLab.text = content;
}

- (void)showCellData:(NotifModel *)notiModel {
//    [cell setTitle:model.title andSubtitle:model.alert andTime:model.push_time];
    self.titleLab.text = notiModel.title;;
    self.contentLab.text = notiModel.push_time;
    self.timeLab.text = notiModel.alert;
    if ([notiModel.push_attach_data.type isEqualToString:@"emergencyCallingDisposeStaffPush"]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

@end
