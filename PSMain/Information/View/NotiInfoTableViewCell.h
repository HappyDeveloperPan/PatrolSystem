//
//  NotiInfoTableViewCell.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/20.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffModel.h"
#import "UnusualModel.h"

@interface NotiInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *redPoint;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet UILabel *isCompleteLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;

//@property (nonatomic, strong) UIButton *handleBtn;
//@property (nonatomic, copy) void (^handleBtnBlock)();

- (void)setHelpCellData:(StaffModel *)model;
- (void)setUnusualCellData:(UnusualModel *)model;

//- (void)handleHelpStateWithModel:(DetailInfoModel *)model;
//- (void)handleUnusualStateWithModel: (DetailInfoModel *)model;

@end
