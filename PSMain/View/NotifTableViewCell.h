//
//  NotifTableViewCell.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/22.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotifModel.h"

@interface NotifTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *redPoint;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

- (void)setTitle:(NSString *)title andSubtitle:(NSString *)content andTime:(NSString *)time;
- (void)showCellData:(NotifModel *)notiModel;
@end
