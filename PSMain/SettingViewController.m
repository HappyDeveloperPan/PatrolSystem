//
//  SettingViewController.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/12.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "MineTableViewCell.h"
#import "LocationManager.h"
#import "SignInViewController.h"
#import "SocketManager.h"
#import "FillCheckViewController.h"
#import "ChangeTaskViewController.h"
#import "RetrieveViewController.h"
#import "AboutViewController.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *logoutBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *menuArr;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *userNameLb;
@property (nonatomic, strong) UILabel *phoneLb;
@property (nonatomic, strong) UILabel *workTypeLb;
@end

@implementation SettingViewController

#define kImageNameArr @[@"icon_signout"]

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBg;
    [Common setUpNavBar:self.navigationController.navigationBar];
    
    [kNotificationCenter addObserver:self selector:@selector(reloadUserInfo) name:kReloadInfo object:nil];
    
    [self.tableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"MineTableViewCell"];
    
    [self headView];
    [self tableView];
    [self logoutBtn];
    
//    self.title = @"设置";
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
//    NSLog(@"界面被销毁了");
}

#pragma mark - Method
- (void)reloadUserInfo {
    if ([[UserManager sharedManager].user.staff.staff_sex isEqualToString:@"男"]) {
        [self.headImage setImage:[UIImage imageNamed:@"boy"]];
    }else {
        [self.headImage setImage:[UIImage imageNamed:@"girl"]];
    }
    self.userNameLb.text = [NSString stringWithFormat:@"姓名: %@",[UserManager sharedManager].user.staff.staff_name];
    self.phoneLb.text = [NSString stringWithFormat:@"电话: %@", [UserManager sharedManager].user.staff.staff_phone];
    self.workTypeLb.text = [NSString stringWithFormat:@"工种: %@", [UserManager sharedManager].user.staff.workType];
}

- (void)logoutBtnClick {
    [[UserManager sharedManager] logout];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.navigationController presentViewController:navVC animated:YES completion:nil];
}

//下班打卡
- (void)clockOut {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    parameters[@"lat"] = [NSString stringWithFormat:@"%f",[LocationManager sharedManager].coordinate.latitude];
    parameters[@"lng"] = [NSString stringWithFormat:@"%f",[LocationManager sharedManager].coordinate.longitude];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:KUrl_SignOut parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [Common clearAsynchronousWithKey:kSignInRecord];
                [UserManager sharedManager].user.staff.sign_in = NO;
                [UserManager sharedManager].isGetAllTask = YES;
                [[SocketManager sharedSocket] disconnectedSocket];
                SignInViewController *signInVc = [[SignInViewController alloc] init];
                UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:signInVc];
                [self.navigationController presentViewController:navVC animated:YES completion:nil];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
        
    }];
}

////更换绑定车辆或者船只
//- (void)changeBoatOrBus {
//    
//}
#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.menuArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.menuArr objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MineTableViewCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[MineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    [cell setImageView:kImageNameArr[indexPath.row] andText:self.menuArr[indexPath.row]];
    [cell setImageView:self.imageArr[indexPath.section][indexPath.row] andText:self.menuArr[indexPath.section][indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //下班打卡
    if (indexPath.row == 0 && indexPath.section == 0) {
        [self clockOut];
    }
    //申请补签
    if (indexPath.row == 1 && indexPath.section == 0) {
        FillCheckViewController *fillCheckVc = [FillCheckViewController new];
        fillCheckVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fillCheckVc animated:YES];
    }
    //切换工具
    if (indexPath.row == 2 && indexPath.section == 0) {
        ChangeTaskViewController *changeTaskVc = [ChangeTaskViewController new];
        changeTaskVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:changeTaskVc animated:YES];
    }
    //修改密码
    if (indexPath.row == 0 && indexPath.section == 1) {
        RetrieveViewController *retrieveVc = [RetrieveViewController new];
        retrieveVc.headTitle = @"修改密码";
        retrieveVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:retrieveVc animated:YES];
    }
    //关于逸途
    if (indexPath.row == 1 && indexPath.section == 1) {
        AboutViewController *jumpVc = [[AboutViewController alloc] init];
        jumpVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jumpVc animated:YES];
    }
}

#pragma mark - Lazy Load
- (UIButton *)logoutBtn {
    if (!_logoutBtn) {
        _logoutBtn = [[UIButton alloc] init];
        [self.view addSubview:_logoutBtn];
        [_logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.bottom.mas_equalTo(-25);
            make.width.mas_equalTo(kMainScreenWidth - 50);
            make.height.mas_equalTo(50);
        }];
        _logoutBtn.backgroundColor = RGBColor(25, 182, 158);
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        _logoutBtn.layer.cornerRadius = 6;
        [_logoutBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _logoutBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 112 - 100) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        //不显示系统自带分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight * 0.2)];
        _headView.backgroundColor = kColorMain;
        _headView.userInteractionEnabled = YES;
        
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, (kMainScreenHeight * 0.2 - 100 ) / 2, 80, 80)];
        _headImage.backgroundColor = [UIColor clearColor];
        _headImage.layer.cornerRadius = 40;
        _headImage.clipsToBounds = YES;
        if ([[UserManager sharedManager].user.staff.staff_sex isEqualToString:@"男"]) {
            [_headImage setImage:[UIImage imageNamed:@"boy"]];
        }else {
            [_headImage setImage:[UIImage imageNamed:@"girl"]];
        }
        [_headView addSubview:_headImage];
        //为图片添加手势控制
//        [headImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingBackgroudImage)]];
        _headImage.userInteractionEnabled = YES;
        
        _userNameLb = [[UILabel alloc] initWithFrame:CGRectMake(_headImage.right + 10, 4, kMainScreenWidth * 0.5, 40)];
        _userNameLb.text = [NSString stringWithFormat:@"姓名: %@",[UserManager sharedManager].user.staff.staff_name];
        _userNameLb.font = [UIFont systemFontOfSize:18];
        _userNameLb.textColor = [UIColor whiteColor];
        [_headView addSubview:_userNameLb];
        
        _phoneLb = [[UILabel alloc] initWithFrame:CGRectMake(_headImage.right + 10, _userNameLb.bottom, kMainScreenWidth * 0.75, 40)];
        _phoneLb.text = [NSString stringWithFormat:@"电话: %@", [UserManager sharedManager].user.staff.staff_phone];;
        _phoneLb.font = [UIFont systemFontOfSize:15];
        _phoneLb.textColor = [UIColor whiteColor];
        [_headView addSubview:_phoneLb];
        
        _workTypeLb = [[UILabel alloc] initWithFrame:CGRectMake(_headImage.right + 10, _phoneLb.bottom, 180, 40)];
        _workTypeLb.text = [NSString stringWithFormat:@"工种: %@", [UserManager sharedManager].user.staff.workType];
        _workTypeLb.font = [UIFont systemFontOfSize:15];
        _workTypeLb.textColor = [UIColor whiteColor];
        [_headView addSubview:_workTypeLb];
        
        _tableView.tableHeaderView = _headView;
    }
    return _headView;
}

- (NSArray *)menuArr {
    if (!_menuArr) {
        _menuArr = [NSArray new];
        if (self.workType == 1) {
            _menuArr = @[@[@"下班打卡",@"申请补签"],@[@"修改密码",@"关于逸途"]];
        }
        if (self.workType == 2) {
            _menuArr = @[@[@"下班打卡",@"申请补签"],@[@"修改密码",@"关于逸途"]];
        }
        if (self.workType == 3) {
            _menuArr = @[@[@"下班打卡",@"申请补签",@"切换车辆"],@[@"修改密码",@"关于逸途"]];
        }
        if (self.workType == 4) {
            _menuArr = @[@[@"下班打卡",@"申请补签",@"切换船只"],@[@"修改密码",@"关于逸途"]];
        }
    }
    return _menuArr;
}

- (NSArray *)imageArr {
    if (!_imageArr) {
        if (self.workType == 1 || self.workType == 2) {
            _imageArr = @[@[@"icon_signout",@"icon_retroactive"],@[@"icon_setting",@"icon_about"]];
        }else {
            _imageArr = @[@[@"icon_signout",@"icon_retroactive",@"icon_tools"],@[@"icon_setting",@"icon_about"]];
        }
    }
    return _imageArr;
}

//- (ClockInView *)clockView {
//    if (!_clockView) {
//        _clockView = [[ClockInView alloc] initWithFrame:CGRectMake(25, 50, kMainScreenWidth - 50, 350)];
//        __weak __typeof(self)weakSelf = self;
//        [_clockView setPickBtnBlock:^{
//            
//        }];
//        [_clockView setSubmitBtnBlock:^{
//            
//        }];
//    }
//    return _clockView;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
