//
//  InfoDetailViewController.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/19.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoDetailViewController : UIViewController
@property (nonatomic, assign) NSInteger emergency_calling_id;
@property (nonatomic, assign) int nowLocationdId;
//@property (nonatomic, assign) NSInteger emergency_calling_type_id;
@property (nonatomic, assign) BOOL isHelpStaff; //是否是前去帮助的工作人员
@end
