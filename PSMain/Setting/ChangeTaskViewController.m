//
//  ChangeTaskViewController.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/16.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "ChangeTaskViewController.h"
#import "MineTableViewCell.h"
#import "KGPickerView.h"
#import "ShuttleBusModel.h"

@interface ChangeTaskViewController ()<UITableViewDelegate, UITableViewDataSource, KGPickerViewDelegate>
@property (nonatomic, strong) UIButton  *saveBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *task, *busBoatId;
@property (nonatomic, strong) ShuttleBusModel *shuttleBusModel;
@property (nonatomic, strong) PleasureBoatModel *pleasureBoatModel;
@property (nonatomic, strong) NSMutableArray *BusBoatArr;
@end

@implementation ChangeTaskViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBg;
    
    self.task = @"切换任务";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
    [self tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method
- (void)saveUserData {
    if ([self.task isEqualToString:@"切换任务"]) {
        [kMainWindow showWarning:@"请选择任务"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    NSString *url;
    if ([UserManager sharedManager].workType == 3) {
        url = KUrl_ChangeFerryBus;
        parameters[@"ferry_push_id"] = self.busBoatId;
    }
    if ([UserManager sharedManager].workType == 4) {
        url = kUrl_ChangeBoat;
        parameters[@"pleasure_boat_id"] = self.busBoatId;
    }
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:url parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [kMainWindow showWarning:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }

    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MineTableViewCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[MineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setImageView:nil andText:self.task];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    NSString *url;
    if ([UserManager sharedManager].workType == 3) {
        url = kUrl_GetAllFerryBus;
    }
    if ([UserManager sharedManager].workType == 4) {
        url = kUrl_GetAllBoat;
    }
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:url parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                NSMutableArray *pickArr = [NSMutableArray new];
                for (id model in jsonData[@"result"]) {
                    if ([UserManager sharedManager].workType == 3) {
                        ShuttleBusModel *busModle = [ShuttleBusModel parse:model];
                        [pickArr addObject:busModle.ferry_push];
                        [self.BusBoatArr addObject:busModle.ferry_push_id];
                    }
                    if ([UserManager sharedManager].workType == 4) {
                        PleasureBoatModel *pleasureBoatModel = [PleasureBoatModel parse:model];
                        [pickArr addObject:pleasureBoatModel.pleasure_boat];
                        [self.BusBoatArr addObject:pleasureBoatModel.pleasure_boat_id];
                    }
                }
                KGPickerView *pickView = [[KGPickerView alloc] initWithTitle:@"请选择任务" andContent:pickArr andDelegate:self andStyle:KGPickerViewStyleBus];
                [pickView showInView:self.view];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
        
    }];
}

#pragma mark - KGPickView Delegate
- (void)confirmChoose:(NSString *)string andIndex:(NSInteger)index andStyle:(KGPickerViewStyle)style{
    self.task = string;
    if (self.BusBoatArr.count != 0) {
        self.busBoatId = self.BusBoatArr[index];
    }
    [self.tableView reloadData];
}
#pragma mark - Lazy Load
- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] init];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _saveBtn.size = CGSizeMake(40, 40);
        [_saveBtn addTarget:self action:@selector(saveUserData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 112 - 100) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        //不显示系统自带分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)BusBoatArr {
    if (!_BusBoatArr) {
        _BusBoatArr = [NSMutableArray new];
    }
    return _BusBoatArr;
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
