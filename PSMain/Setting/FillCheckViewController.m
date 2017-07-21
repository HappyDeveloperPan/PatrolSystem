//
//  FillCheckViewController.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/5.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "FillCheckViewController.h"
#import "LZBCalendar.h"
#import "NSDate+Component.h"
#import "DayModel.h"
#import "CheckStateView.h"
#import "AddView.h"
#import "ApplyRetroactiveViewController.h"
#import "RetroactiveListViewController.h"

@interface FillCheckViewController ()<LZBCalendarDataDelegate, LZBCalendarDataSource>
@property (nonatomic, strong) LZBCalendar *calendar;
@property (nonatomic, strong) LZBCalendarAppearStyle *calendarStyle;
@property (nonatomic, strong) NSMutableArray *attendanceArr;
@property (nonatomic, strong) AddView *addView;
@end

@implementation FillCheckViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的考勤";
    self.view.backgroundColor = kColorWhite;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"补签列表" style:UIBarButtonItemStylePlain target:self action:@selector(gotoRetroactiveList)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self calendar];
    
    NSDate *date = [NSDate date];
    [self staffAttendanceInMonthWithDate:date];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - Method
//获取当月考勤
- (void)staffAttendanceInMonthWithDate: (NSDate *)date {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy-MM-dd"];
    params[@"time"] =[fomatter stringFromDate:date];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_StaffAttendance parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
//                [self.attendanceArr removeAllObjects];
                for (id model in jsonData[@"result"][@"arrivedDay"]) {
                    DayModel *detailModel = [DayModel parse:model];
                    [self.attendanceArr addObject:detailModel];
                }
                [self.calendar.collectionView reloadData];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }

    }];
}

//申请补签界面
- (void)gotoApplyRetroactiveWithDate:(NSDate *)date{
    ApplyRetroactiveViewController *pushVc = [ApplyRetroactiveViewController new];
    pushVc.date = date;
    [self.addView close];
    [self.navigationController pushViewController:pushVc animated:YES];
}

//补签列表界面
- (void)gotoRetroactiveList {
    RetroactiveListViewController *pushVc = [RetroactiveListViewController new];
    [self.navigationController pushViewController:pushVc animated:YES];
}
#pragma mark - LZBCanlendar Delegate
- (void)calendar:(LZBCalendar *)calendar didSelectDate:(NSDate *)date
{
    //    NSLog(@"当前调用的方法:%s------行号:line-%d ",__func__, __LINE__);
    if (self.attendanceArr.count > 0 && (self.attendanceArr.count >= [date getDateWithDay])) {
        DayModel *detailModel = [self.attendanceArr objectAtIndex:[date getDateWithDay] - 1];
        CheckStateView *checkStateView = [[CheckStateView alloc] initWithFrame:CGRectMake(40, 40, kMainScreenWidth - 50, 200)];
        checkStateView.titleLb.text = [NSString stringWithFormat:@"状态: %@", detailModel.staffStateSM.msg];
        if ([detailModel.staffStateSM.msg isEqualToString:@"正常"] || [detailModel.staffStateSM.msg isEqualToString:@"请假"] || [detailModel.staffStateSM.msg isEqualToString:@"出差"] || [detailModel.staffStateSM.msg isEqualToString:@"迟到"] || [detailModel.staffStateSM.msg isEqualToString:@"早退"] || [detailModel.staffStateSM.msg isEqualToString:@"迟到&早退"]) {
            checkStateView.checkBtn.hidden = YES;
        }
        [checkStateView setCheckBtnBlock:^{
            //申请补签界面
            [self gotoApplyRetroactiveWithDate:date];
        }];
        [checkStateView setCloseBtnBlock:^{
            [self.addView close];
        }];
        checkStateView.center = self.addView.center;
        [self.addView addSubview:checkStateView];
        [self.addView show];
    }
    
}

- (void)calendar:(LZBCalendar *)calendar didSelectHeaderView:(NSDate *)date {
    //    NSLog(@"%ld, %ld",[[NSDate date] getDateWithMonth], [date getDateWithMonth] );
    [self.attendanceArr removeAllObjects];
    if ([[NSDate date] getDateWithMonth] >= [date getDateWithMonth]) {
        [self staffAttendanceInMonthWithDate:date];
    }else {
        [self.calendar.collectionView reloadData];
    }
}

#pragma mark - dataSoure
- (NSString *)calendar:(LZBCalendar *)calendar titleForDate:(NSDate *)date
{
    if([[NSDate date] getDateWithMonth] == [date getDateWithMonth] && [[NSDate date] getDateWithDay] -[date getDateWithDay] == 0)
    {
        //返回今天是几号
        //        NSLog(@"被减数: %ld",(long)[[NSDate date] getDateWithDay]);
        //        NSLog(@"减数: %ld",(long)[date getDateWithDay]);
        return @"今天";
        
    }
    return nil;
}

- (NSString *)calendar:(LZBCalendar *)calendar subtitleForDate:(NSDate *)date
{
    //    NSLog(@"%ld, 今天几号: %ld, %ld", self.attendanceArr.count, [[NSDate date] getDateWithDay], [date getDateWithDay]);
    
    if (self.attendanceArr.count > 0 && (self.attendanceArr.count >= [date getDateWithDay])) {
        DayModel *detailModel = [self.attendanceArr objectAtIndex:[date getDateWithDay] - 1];
        if ([detailModel.staffStateSM.msg isEqualToString:@"正常"] || [detailModel.staffStateSM.msg isEqualToString:@"请假"] || [detailModel.staffStateSM.msg isEqualToString:@"出差"]) {
            return @"√";
        }else if ([detailModel.staffStateSM.msg isEqualToString:@"缺勤一天"] || [detailModel.staffStateSM.msg isEqualToString:@"缺勤半天"] || [detailModel.staffStateSM.msg isEqualToString:@"缺勤半天&漏签"]) {
            return @"✘";
        }else {
            return @"O";
        }
    }
    return nil;
}

- (UIColor *)calendar:(LZBCalendar *)calendar subtitleColorForDate:(NSDate *)date {
    if (self.attendanceArr.count > 0 && (self.attendanceArr.count >= [date getDateWithDay])) {
        DayModel *detailModel = [self.attendanceArr objectAtIndex:[date getDateWithDay] - 1];
        if ([detailModel.staffStateSM.msg isEqualToString:@"正常"] || [detailModel.staffStateSM.msg isEqualToString:@"请假"] || [detailModel.staffStateSM.msg isEqualToString:@"出差"]) {
            return kColorGreen;
        }else if ([detailModel.staffStateSM.msg isEqualToString:@"缺勤一天"] || [detailModel.staffStateSM.msg isEqualToString:@"缺勤半天"] || [detailModel.staffStateSM.msg isEqualToString:@"缺勤半天&漏签"]) {
            return KcolorRed;
        }else {
            return kColorYellow;
        }
    }
    return kColorMajor;
}

- (void)calendar:(LZBCalendar *)calendar layoutCallBackHeight:(CGFloat)height
{
    self.calendar.frame = CGRectMake(0, 15, [UIScreen mainScreen].bounds.size.width, height);
}
#pragma mark - Lazy Load
- (LZBCalendarAppearStyle *)calendarStyle {
    if (!_calendarStyle) {
        _calendarStyle = [[LZBCalendarAppearStyle alloc] init];
        _calendarStyle.isNeedCustomHeihgt = YES;
    }
    return _calendarStyle;
}

- (LZBCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[LZBCalendar alloc] initWithStyle:self.calendarStyle];
        _calendar.frame = CGRectMake(0, 15, kMainScreenWidth, 300);
        _calendar.delegate = self;
        _calendar.dataSource = self;
        [self.view addSubview:_calendar];
    }
    return _calendar;
}

- (NSMutableArray *)attendanceArr {
    if (!_attendanceArr) {
        _attendanceArr = [NSMutableArray new];
    }
    return _attendanceArr;
}

- (AddView *)addView {
    if (!_addView) {
        _addView = [[AddView alloc] initWithFrame:kMainWindow.frame];
    }
    return _addView;
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
