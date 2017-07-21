//
//  RetroListTableViewCell.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/6.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RetroListModel.h"

@interface RetroListTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *retroLb;
@property (nonatomic, strong) UILabel *typeLb;
@property (nonatomic, strong) UILabel *reasonLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *progressLb;
@property (nonatomic, strong) UIView *lineView;

- (void)setDataWithModel:(RetroListModel *)model;

@end
