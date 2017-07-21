//
//  HelpInfoViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/19.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "HelpInfoViewController.h"
#import "NotiInfoTableViewCell.h"
#import "HelpModel.h"
#import "InfoDetailViewController.h"

@interface HelpInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *notiArr;
@property (nonatomic, assign) NSInteger page;
@end
typedef NS_ENUM(NSUInteger, RefreshMode) {
    RefreshModeFirst,
    RefreshModeMore,
};

typedef NS_ENUM(NSUInteger, HandleMode) {
    HelpHandleMode = 1,
    EndHelpHandleMode = 2,
    UnusualHandleMode = 3,
    EndUnusualHandleMode = 4,
};

@implementation HelpInfoViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"求助详情";
    self.view.backgroundColor = kColorBg;
    [self.tableView registerNib:[UINib nibWithNibName:@"NotiInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"NotiInfoTableViewCell"];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getNotiContentWithRefreshMode:RefreshModeFirst];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getNotiContentWithRefreshMode:RefreshModeMore];
    }];
    
//    [self startLoading];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self startLoading];
}
#pragma mark - Method
- (void)startLoading {
    [self.tableView.mj_header beginRefreshing];
}

/*  获取通知内容 */
- (void)getNotiContentWithRefreshMode:(RefreshMode)refreshMode {
    if (refreshMode == RefreshModeFirst) {
        [self.notiArr removeAllObjects];
        self.page = 1;
    }else {
        self.page += 1;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    params[@"pageCount"] = @10;
    params[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.page];
    NSString *url;
    if (self.infoType == HelpInfo) {
        url = kUrl_StaffHelpList;
    }
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:url parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                if (self.infoType == HelpInfo) {
                    for (id model in jsonData[@"result"]) {
                        StaffModel *staffModel = [StaffModel parse:model];
                        [self.notiArr addObject:staffModel];
                    }
                }                
                [self.tableView reloadData];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
        if (refreshMode == RefreshModeFirst) {
            [self.tableView.mj_header endRefreshing];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
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
    return 100;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 160;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"NotiInfoTableViewCell";
    NotiInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (self.infoType == HelpInfo) {
        StaffModel *staffModel = self.notiArr[indexPath.row];
        [cell setHelpCellData:staffModel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoDetailViewController *pushVc = [InfoDetailViewController new];
    StaffModel *staffModel = self.notiArr[indexPath.row];
    pushVc.emergency_calling_id = staffModel.emergency_calling_id;
    [self.navigationController pushViewController:pushVc animated:YES];
}

#pragma mark - Lazy Load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64 - 40) style:UITableViewStylePlain];
        
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

@end
