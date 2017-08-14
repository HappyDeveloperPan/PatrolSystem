//
//  NotifCenterViewController.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/12.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "NotifCenterViewController.h"
#import "NotifTableViewCell.h"
#import "NotifModel.h"
#import "InfoDetailViewController.h"

@interface NotifCenterViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *notiArr;
@end

@implementation NotifCenterViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBg;
    self.title = @"通知中心";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NotifTableViewCell" bundle:nil] forCellReuseIdentifier:@"NotifTableViewCell"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getNotiContent];
    }];
    
    [self startLoading];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Method
- (void)startLoading {
    [self.tableView.mj_header beginRefreshing];
}

/*  获取通知内容 */
- (void)getNotiContent {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_GetAllPush parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.notiArr removeAllObjects];
                for (id model in jsonData[@"result"]) {
                    NotifModel *notifModel = [NotifModel parse:model];
                    [self.notiArr addObject:notifModel];
                }
                [self.tableView reloadData];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.notiArr != nil) {
        return self.notiArr.count;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"NotifTableViewCell";
    NotifTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NotifModel *model = self.notiArr[indexPath.row];
//    [cell setTitle:model.title andSubtitle:model.alert andTime:model.push_time];
    [cell showCellData:model];
//    if (indexPath.row < self.notiNumber) {
//        cell.redPoint.hidden = NO;
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NotifModel *model = self.notiArr[indexPath.row];
    //被派遣去一键求助
    if ([model.push_attach_data.type isEqualToString:@"emergencyCallingDisposeStaffPush"]) {
        InfoDetailViewController *pushVc = [InfoDetailViewController new];
        pushVc.emergency_calling_id = model.push_attach_data.spid;
        pushVc.isHelpStaff = YES;
        [self.navigationController pushViewController:pushVc animated:YES];
    }
    //被派遣去安保异常
    if ([model.push_attach_data.type isEqualToString:@"nowLocationdAuxiliaryStaffPush"]) {
        InfoDetailViewController *pushVc = [InfoDetailViewController new];
        pushVc.nowLocationdId = (short)model.push_attach_data.spid;
        pushVc.isHelpStaff = YES;
        [self.navigationController pushViewController:pushVc animated:YES];
    }
}

#pragma mark - Lazy Load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64 - self.topHeight) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        //不显示系统自带分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)notiArr {
    if (!_notiArr) {
        _notiArr = [NSMutableArray new];
    }
    return _notiArr;
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
