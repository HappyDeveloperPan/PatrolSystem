//
//  SignInViewController.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/10.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "SignInViewController.h"
#import "LoginViewController.h"
#import "SecurityViewController.h"
#import "ShuttleBusViewController.h"
#import "PleasureBoatViewController.h"
#import "CleaningViewController.h"
#import "SettingViewController.h"
#import "PSTabBarViewController.h"
#import "LocationManager.h"
#import "SocketManager.h"

@interface SignInViewController ()
@property (nonatomic, strong) UIButton *signInBtn;
@end

@implementation SignInViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"打卡";
    self.view.backgroundColor = kColorWhite;

    [self signInBtn];
//    [self locationManager];
    [kNotificationCenter addObserver:self selector:@selector(notifPresentLogin:) name:kNotifPresentLogin object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [kNotificationCenter removeObserver:self];
}

#pragma mark - Method
//签到按钮
- (void)signInBtnClick {
    //    UINavigationController *selectNavVC = (UINavigationController *)self.presentingViewController;
    //    if (selectNavVC.presentedViewController) {
    //        selectNavVC = (UINavigationController *)selectNavVC.presentedViewController;
    //    }
    if (![[UserManager sharedManager] isLogin]) {
        [kNotificationCenter postNotificationName:kNotifPresentLogin object:nil];
    }else if ([UserManager sharedManager].user.staff.sign_in) {
        [self.navigationController presentViewController:[PSTabBarViewController new] animated:YES completion:nil];
    } else {
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
        parameters[@"lat"] = [NSString stringWithFormat:@"%f",[LocationManager sharedManager].coordinate.latitude];
        parameters[@"lng"] = [NSString stringWithFormat:@"%f",[LocationManager sharedManager].coordinate.longitude];
        [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_SignIn parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
            if (jsonData) {
                if ([jsonData[@"resultnumber"] intValue] == 200) {
                    //将签到日期保存
                    NSDate *date = [NSDate date];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    [Common setAsynchronous:[formatter stringFromDate:date] WithKey:kSignInRecord];
                    [[SocketManager sharedSocket] connectServerWithAdress:socketAdress andPort:socketPort];
                    [self.navigationController presentViewController:[PSTabBarViewController new] animated:YES completion:nil];
                }else {
                    [self.view showWarning:jsonData[@"cause"]];
                }
            } else {
                [self.view showWarning:error.domain];
            }
        }];
    }
}

//跳转到登录界面
-(void)notifPresentLogin:(NSNotification *)notif
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.navigationController presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - Lazy Load
- (UIButton *)signInBtn {
    if (!_signInBtn) {
        _signInBtn = [UIButton new];
        [self.view addSubview:_signInBtn];
        [_signInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        _signInBtn.backgroundColor = RGBColor(25, 182, 158);
        [_signInBtn setTitle:@"打卡" forState:UIControlStateNormal];
        [_signInBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        [_signInBtn addTarget:self action:@selector(signInBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _signInBtn.layer.cornerRadius = 50;
    }
    return _signInBtn;
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
