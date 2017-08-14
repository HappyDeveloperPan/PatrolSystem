//
//  HandleResultViewController.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/15.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "HandleResultViewController.h"

@interface HandleResultViewController ()
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *phoneLb;
@property (nonatomic, strong) UILabel *handleTimeLb;
@property (nonatomic, strong) UILabel *helpStaffNameLb;
@property (nonatomic, strong) UILabel *resultLb;
@property (nonatomic, strong) UILabel *finishTimeLb;
@property (nonatomic, strong) UILabel *summarizeLb;
@end

#define kResult_Left 85
#define kResult_Width kMainScreenWidth - 100

@implementation HandleResultViewController

- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.title = @"处理结果";
//    self.view.backgroundColor = kColorWhite;
//    
//    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:kMainScreenFrame];
//    scrollView.contentSize = kMainScreenFrame.size;
//    [self.view addSubview:scrollView];
//    
//    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 60, 60)];
//    headImg.backgroundColor = [UIColor clearColor];
//    headImg.layer.cornerRadius = 30;
//    headImg.clipsToBounds = YES;
//    if ([self.helpModel.leaderAccount.leader_account_sex isEqualToString:@"男"]) {
//        [headImg setImage:[UIImage imageNamed:@"boy"]];
//    }else {
//        [headImg setImage:[UIImage imageNamed:@"girl"]];
//    }
//    [scrollView addSubview:headImg];
//    
//    //处理人
//    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(kResult_Left, 20, kResult_Width, 20)];
//    nameLb.text = [NSString stringWithFormat:@"处理人: %@",self.helpModel.leaderAccount.leader_account_name];
//    nameLb.font = [UIFont systemFontOfSize:18];
//    nameLb.textColor = kColorMajor;
//    [scrollView addSubview:nameLb];
//    //电话
//    UILabel *phoneLb = [[UILabel alloc] initWithFrame:CGRectMake(kResult_Left, nameLb.bottom + 10, kResult_Width, 20)];
//    phoneLb.text = [NSString stringWithFormat:@"电话: %@",self.helpModel.leaderAccount.leader_account_phone];
//    phoneLb.font = [UIFont systemFontOfSize:16];
//    phoneLb.textColor = kColorMajor;
//    [scrollView addSubview:phoneLb];
//    
//    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(kResult_Left, phoneLb.bottom + 10, kResult_Width, 1.5)];
//    lineView1.backgroundColor = kColorMain;
//    [scrollView addSubview:lineView1];
//    //处理时间
//    UILabel *handleTimeLb = [[UILabel alloc] initWithFrame:CGRectMake(kResult_Left, phoneLb.bottom + 20, kResult_Width, 20)];
//    handleTimeLb.text = [NSString stringWithFormat:@"处理时间: %@",self.helpModel.emergencyCallingDispose.dispose_time];
//    handleTimeLb.font = [UIFont systemFontOfSize:16];
//    handleTimeLb.textColor = kColorMajor;
//    [scrollView addSubview:handleTimeLb];
//    //派遣人员
//    UILabel *helpStaffNameLb = [[UILabel alloc] initWithFrame:CGRectMake(kResult_Left, handleTimeLb.bottom + 10, kResult_Width, 20)];
//    helpStaffNameLb.text = [self helpStaffName];
//    helpStaffNameLb.font = [UIFont systemFontOfSize:16];
//    helpStaffNameLb.textColor = kColorMajor;
//    [scrollView addSubview:helpStaffNameLb];
//    //处理结果
//    UILabel *resultLb = [[UILabel alloc] initWithFrame:CGRectMake(kResult_Left, helpStaffNameLb.bottom + 10, kResult_Width, 20)];
//    resultLb.text = [NSString stringWithFormat:@"处理结果: %@",self.helpModel.emergencyCallingDispose.result];
//    resultLb.font = [UIFont systemFontOfSize:16];
//    resultLb.textColor = kColorMajor;
//    resultLb.numberOfLines = 0;
//    [scrollView addSubview:resultLb];
//    
//    if (self.helpModel.emergencyCallingType.emergency_calling_type_id == 3) {
//        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(kResult_Left, resultLb.bottom + 10, kResult_Width, 1.5)];
//        lineView2.backgroundColor = kColorMain;
//        [scrollView addSubview:lineView2];
//        //完成时间
//        UILabel *finishTimeLb = [[UILabel alloc] initWithFrame:CGRectMake(kResult_Left, resultLb.bottom + 20, kResult_Width, 20)];
//        finishTimeLb.text = [NSString stringWithFormat:@"完成时间: %@",self.helpModel.emergencyCallingAccomplish.ccomplish_time];
//        finishTimeLb.font = [UIFont systemFontOfSize:16];
//        finishTimeLb.textColor = kColorMajor;
//        [scrollView addSubview:finishTimeLb];
//        //总结报告
//        UILabel *summarizeLb = [[UILabel alloc] initWithFrame:CGRectMake(kResult_Left, finishTimeLb.bottom + 10, kResult_Width, 20)];
//        summarizeLb.text = [NSString stringWithFormat:@"报告总结: %@",self.helpModel.emergencyCallingAccomplish.summarize];
//        summarizeLb.font = [UIFont systemFontOfSize:16];
//        summarizeLb.textColor = kColorMajor;
//        [scrollView addSubview:summarizeLb];
//    }
    [super viewDidLoad];
    self.title = @"处理结果";
    self.view.backgroundColor = kColorWhite;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:kMainScreenFrame];
    scrollView.contentSize = kMainScreenFrame.size;
    [self.view addSubview:scrollView];
    
    self.headImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 60, 60)];
    self.headImg.backgroundColor = [UIColor clearColor];
    self.headImg.layer.cornerRadius = 30;
    self.headImg.clipsToBounds = YES;
    [scrollView addSubview:self.headImg];
    
    //处理人
    self.nameLb = [[UILabel alloc] initWithFrame:CGRectMake(kResult_Left, 20, kResult_Width, 20)];
    self.nameLb.font = [UIFont systemFontOfSize:18];
    self.nameLb.textColor = kColorMajor;
    [scrollView addSubview:self.nameLb];
    //电话
    self.phoneLb = [[UILabel alloc] initWithFrame:CGRectMake(kResult_Left, self.nameLb.bottom + 10, kResult_Width, 20)];
    self.phoneLb.font = [UIFont systemFontOfSize:16];
    self.phoneLb.textColor = kColorMajor;
    [scrollView addSubview:self.phoneLb];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(kResult_Left, self.phoneLb.bottom + 10, kResult_Width, 1.5)];
    lineView1.backgroundColor = kColorMain;
    [scrollView addSubview:lineView1];
    //处理时间
    self.handleTimeLb = [[UILabel alloc] initWithFrame:CGRectMake(kResult_Left, self.phoneLb.bottom + 20, kResult_Width, 20)];
    self.handleTimeLb.font = [UIFont systemFontOfSize:16];
    self.handleTimeLb.textColor = kColorMajor;
    [scrollView addSubview:self.handleTimeLb];
    //派遣人员
    self.helpStaffNameLb = [[UILabel alloc] initWithFrame:CGRectMake(kResult_Left, self.handleTimeLb.bottom + 10, kResult_Width, 20)];
    self.helpStaffNameLb.font = [UIFont systemFontOfSize:16];
    self.helpStaffNameLb.textColor = kColorMajor;
    [scrollView addSubview:self.helpStaffNameLb];
    //处理结果
    self.resultLb = [[UILabel alloc] initWithFrame:CGRectMake(kResult_Left, self.helpStaffNameLb.bottom + 10, kResult_Width, 20)];
    self.resultLb.font = [UIFont systemFontOfSize:16];
    self.resultLb.textColor = kColorMajor;
    [scrollView addSubview:self.resultLb];
    
    if (self.helpModel.emergencyCallingType.emergency_calling_type_id == 3 || self.unusualModel.nowLocationdIdState.nowLocationdId_state_id == 5) {
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(kResult_Left, self.resultLb.bottom + 10, kResult_Width, 1.5)];
        lineView2.backgroundColor = kColorMain;
        [scrollView addSubview:lineView2];
        //完成时间
        self.finishTimeLb = [[UILabel alloc] initWithFrame:CGRectMake(kResult_Left, self.resultLb.bottom + 20, kResult_Width, 20)];
        self.finishTimeLb.font = [UIFont systemFontOfSize:16];
        self.finishTimeLb.textColor = kColorMajor;
        [scrollView addSubview:self.finishTimeLb];
        //总结报告
        self.summarizeLb = [[UILabel alloc] initWithFrame:CGRectMake(kResult_Left, self.finishTimeLb.bottom + 10, kResult_Width, 20)];
        self.summarizeLb.font = [UIFont systemFontOfSize:16];
        self.summarizeLb.textColor = kColorMajor;
        [scrollView addSubview:self.summarizeLb];
    }
    if (self.infoType == HelpInfo) {
        [self helpResultData];
    }
    if (self.infoType == UnusualInfo) {
        [self unusualResultData];
    }
}

- (void)helpResultData {
    if ([self.helpModel.leaderAccount.leader_account_sex isEqualToString:@"男"]) {
        [self.headImg setImage:[UIImage imageNamed:@"boy"]];
    }else {
        [self.headImg setImage:[UIImage imageNamed:@"girl"]];
    }
    self.nameLb.text = [NSString stringWithFormat:@"处理人: %@",self.helpModel.leaderAccount.leader_account_name];
    self.phoneLb.text = [NSString stringWithFormat:@"电话: %@",self.helpModel.leaderAccount.leader_account_phone];
    self.handleTimeLb.text = [NSString stringWithFormat:@"处理时间: %@",self.helpModel.emergencyCallingDispose.dispose_time];
    self.helpStaffNameLb.text = [self helpStaffName];
    self.resultLb.text = [NSString stringWithFormat:@"处理结果: %@",self.helpModel.emergencyCallingDispose.result];
    self.resultLb.numberOfLines = 0;
    [self.resultLb sizeToFit];
    self.finishTimeLb.text = [NSString stringWithFormat:@"完成时间: %@",self.helpModel.emergencyCallingAccomplish.ccomplish_time];
    self.summarizeLb.text = [NSString stringWithFormat:@"报告总结: %@",self.helpModel.emergencyCallingAccomplish.summarize];
    self.summarizeLb.numberOfLines = 0;
    [self.summarizeLb sizeToFit];
}

- (void)unusualResultData {
    if ([self.unusualModel.leaderAccount.leader_account_sex isEqualToString:@"男"]) {
        [self.headImg setImage:[UIImage imageNamed:@"boy"]];
    }else {
        [self.headImg setImage:[UIImage imageNamed:@"girl"]];
    }
    self.nameLb.text = [NSString stringWithFormat:@"处理人: %@",self.unusualModel.leaderAccount.leader_account_name];
    self.phoneLb.text = [NSString stringWithFormat:@"电话: %@",self.unusualModel.leaderAccount.leader_account_phone];
    self.handleTimeLb.text = [NSString stringWithFormat:@"处理时间: %@",self.unusualModel.nowLocationdDispose.dispose_time];
    self.helpStaffNameLb.text = [self helpStaffName];
    self.resultLb.text = [NSString stringWithFormat:@"处理结果: %@",self.unusualModel.nowLocationdDispose.dispose_result];
    self.resultLb.numberOfLines = 0;
    [self.resultLb sizeToFit];
    self.finishTimeLb.text = [NSString stringWithFormat:@"完成时间: %@",self.unusualModel.nowLocationdAccomplish.accomplish_time];
    self.summarizeLb.text = [NSString stringWithFormat:@"报告总结: %@",self.unusualModel.nowLocationdAccomplish.conclusion];
    self.summarizeLb.numberOfLines = 0;
    [self.summarizeLb sizeToFit];
}

- (NSString *)helpStaffName {
    NSString *nameStr;
    if (self.infoType == HelpInfo) {
        if (self.helpModel.emergencyCallingDisposeStaffOnLine.count == 0) {
            nameStr = @"派遣人员: 无";
        }else {
            NSMutableArray *nameArr = [NSMutableArray new];
            for (HelpDisposeStaffOnLineModel *staffModel in self.helpModel.emergencyCallingDisposeStaffOnLine) {
                [nameArr addObject:staffModel.staff.staff_name];
            }
            NSString *staffNames = [nameArr componentsJoinedByString:@","];
            nameStr  = [NSString stringWithFormat:@"派遣人员: %@", staffNames];
        }
    }
    if (self.infoType == UnusualInfo) {
        if (self.unusualModel.auxiliaryStaffs.count == 0) {
            nameStr = @"派遣人员: 无";
        }else {
            NSMutableArray *nameArr = [NSMutableArray new];
            for (AuxiliaryStaffsModel *staffModel in self.unusualModel.auxiliaryStaffs) {
                [nameArr addObject:staffModel.staff.staff_name];
            }
            NSString *staffNames = [nameArr componentsJoinedByString:@","];
            nameStr  = [NSString stringWithFormat:@"派遣人员: %@", staffNames];
        }
    }
    return nameStr;
}

//- (NSString *)helpStaffName {
//    NSString *nameStr;
//    if (self.helpModel.emergencyCallingDisposeStaffOnLine.count == 0) {
//        nameStr = @"派遣人员: 无";
//    }else {
//        NSMutableArray *nameArr = [NSMutableArray new];
//        for (HelpDisposeStaffOnLineModel *staffModel in self.helpModel.emergencyCallingDisposeStaffOnLine) {
//            [nameArr addObject:staffModel.staff.staff_name];
//        }
//        NSString *staffNames = [nameArr componentsJoinedByString:@","];
//        nameStr  = [NSString stringWithFormat:@"派遣人员: %@", staffNames];
//    }
//    return nameStr;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
