//
//  LoginViewController.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/6.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "PSTabBarViewController.h"
#import "SignInViewController.h"
#import "RetrieveViewController.h"
#import "SocketManager.h"

@interface LoginViewController ()
@property (nonatomic, retain) UITextField *loginTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@end

@implementation LoginViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    self.view.backgroundColor = kColorBg;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back)];
    
    [self creatLoginLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击空白处收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)dealloc {
    NSLog(@"界面被销毁了");
}
#pragma mark - Method
//界面控件
- (void)creatLoginLabel{
    //////////////
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(25, 50, kMainScreenWidth-50, 110)];
    mainView.backgroundColor = kColorWhite;
//        [mainView setBorderColor:kColorLine width:.5 cornerRadius:6];
    mainView.layer.cornerRadius = 6;
    [self.view addSubview:mainView];
    
    UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 55)];
    phoneLab.text = @"手机号 ";
    phoneLab.textColor = RGBColor(66, 66, 66);
    phoneLab.adjustsFontSizeToFitWidth = YES;
    phoneLab.font = [UIFont systemFontOfSize:16];
    [mainView addSubview:phoneLab];
    
    self.loginTextField = [self addTextFieldWithFrame:CGRectMake(phoneLab.right, 0, mainView.width - phoneLab.width - 10, 55) addText:@"请输入您的账号"];
    self.loginTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.loginTextField.text = [Common getAsynchronousWithKey:@"loginPhone"];
    self.loginTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [mainView addSubview:self.loginTextField];
    
    UILabel *passLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 80, 55)];
    passLab.text = @"密码 ";
    passLab.textColor =  RGBColor(66, 66, 66);
    passLab.adjustsFontSizeToFitWidth = YES;
    passLab.font = [UIFont systemFontOfSize:16];
    [mainView addSubview:passLab];
    
    self.passwordTextField = [self addTextFieldWithFrame:CGRectMake(passLab.right, 55, mainView.width - passLab.width - 10, 55) addText:@"请输入您的密码"];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.text = [Common getAsynchronousWithKey:@"loginPass"];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [mainView addSubview:self.passwordTextField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 54, mainView.width - 20, 1)];
    lineView.backgroundColor = RGBColor(241, 241, 241);
    [mainView addSubview:lineView];
    
    UIButton *retrieveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    retrieveBtn.frame = CGRectMake(kMainScreenWidth * 0.75, mainView.bottom + 10, kMainScreenWidth * 0.2, kMainScreenHeight * 0.03);
    [retrieveBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [retrieveBtn setTitleColor:kColorMajor forState:UIControlStateNormal];
    retrieveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [retrieveBtn addTarget:self action:@selector(clickRetrieveBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retrieveBtn];
    
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, retrieveBtn.bottom + 15, kMainScreenWidth - 50, 50)];
    loginBtn.backgroundColor = RGBColor(25, 182, 158);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 6;
    [loginBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(kMainScreenWidth * 0.35, loginBtn.bottom + 16, kMainScreenWidth * 0.3, kMainScreenHeight * 0.03);
    [registerBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:RGBColor(25, 182, 158) forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:registerBtn];
}

//登录
- (void)clickLoginBtn {
//    String staff_phone   用户名(手机号)
//    String staff_password   密码
    if (self.loginTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        [self.view showWarning:@"信息不能为空"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"staff_phone"] = self.loginTextField.text;
    parameters[@"staff_password"] = [Common md5:self.passwordTextField.text];
    parameters[@"regid"] = [Common getAsynchronousWithKey:kJPushRegisterId];
    
    [self.view showBusyHUD];
    
    [UserManager loginWithPhone:self.loginTextField.text andPass:[Common md5:self.passwordTextField.text] andSuccess:^(PSUser *user, NSError *error) {
        [UserManager sharedManager].user = user;
        [kNotificationCenter postNotificationName:kReloadInfo object:nil];
        [self.view hideBusyHUD];
        [[LocationManager sharedManager] startUserLocation];
        if ([UserManager sharedManager].user.staff.sign_in) {
            //将签到日期保存
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            [Common setAsynchronous:[formatter stringFromDate:date] WithKey:kSignInRecord];
            [[SocketManager sharedSocket] connectServerWithAdress:socketAdress andPort:socketPort];
            [self.navigationController presentViewController:[PSTabBarViewController new] animated:YES completion:nil];
        }else {
//            [self dismissViewControllerAnimated:YES completion:nil];
            SignInViewController *signInVc = [[SignInViewController alloc] init];
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:signInVc];
            [self.navigationController presentViewController:navVC animated:YES completion:nil];
//            [self.navigationController presentViewController:[SignInViewController new] animated:YES completion:nil];
        }
    } andFailure:^(NSError *error) {
        [self.view hideBusyHUD];
        [self.view showWarning:error.domain];
    }];
}
//注册
- (void)clickRegisterBtn {
    RegisterViewController *registerVc = [RegisterViewController new];
    [self.navigationController pushViewController:registerVc animated:YES];
}

//找回密码
- (void)clickRetrieveBtn {
    RetrieveViewController *retrieveVc = [RetrieveViewController new];
    retrieveVc.headTitle = @"找回密码";
    [self.navigationController pushViewController:retrieveVc animated:YES];
}

//自定义textfield
- (UITextField *)addTextFieldWithFrame:(CGRect)frame addText:(NSString *)text {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.textColor = kColorMajor;
    textField.placeholder = text;
    return textField;
}

//返回上一个视图
-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Lazy Load

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
