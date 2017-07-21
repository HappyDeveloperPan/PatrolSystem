//
//  RetroactiveListViewController.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/6.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "RetroactiveListViewController.h"
#import "RetroListTableViewCell.h"
#import "RetroListModel.h"

@interface RetroactiveListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *retroListArr;
@end

typedef NS_ENUM(NSUInteger, RefreshMode) {
    RefreshModeFirst,
    RefreshModeMore,
};

@implementation RetroactiveListViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"补签列表";
    self.view.backgroundColor = kColorBg;

    [self.tableView registerClass:[RetroListTableViewCell class] forCellReuseIdentifier:@"RetroListTableViewCell"];
    
    [self tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getRetroactiveListWithRefreshMode:RefreshModeFirst];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getRetroactiveListWithRefreshMode:RefreshModeMore];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method
- (void)getRetroactiveListWithRefreshMode:(RefreshMode)refreshMode {
    if (refreshMode == RefreshModeFirst) {
        [self.retroListArr removeAllObjects];
        self.page = 1;
    }else {
        self.page += 1;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    params[@"pageCount"] = @10;
    params[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.page];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_LookFillCheck parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                for (id model in jsonData[@"result"]) {
                    RetroListModel *listModel = [RetroListModel parse:model];
                    [self.retroListArr addObject:listModel];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.retroListArr != nil) {
        return self.retroListArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"RetroListTableViewCell";
    RetroListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//    cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    RetroListModel *model = self.retroListArr[indexPath.row];
    [cell setDataWithModel:model];
    return cell;
}
#pragma mark - Lazy Load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        //不显示系统自带分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)retroListArr {
    if (!_retroListArr) {
        _retroListArr = [NSMutableArray new];
    }
    return _retroListArr;
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
