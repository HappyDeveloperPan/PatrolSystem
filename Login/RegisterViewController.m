//
//  RegisterViewController.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/6.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "RegisterViewController.h"
#import "KGPickerView.h"
#import <SMS_SDK/SMSSDK.h>

@interface RegisterViewController ()<KGPickerViewDelegate>
@property(nonatomic, strong) UITextField *nickNameField, *ageField, *phoneField, *verCodeField, *passField, *surePassField, *invitationCodeField;
@property (nonatomic, strong) UIButton *workTypeBtn, *sexBtn;
@property (nonatomic, strong) UILabel *workTypeLb, *sexLb;
@property(nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *registerView;

@end

@implementation RegisterViewController

#define kLeftArr @[@"姓名 ",@"年龄 ",@"工种 ",@"性别 ",@"手机号 ",@"验证码 ",@"密码 ",@"确认密码 ",@"工号 "]

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用户注册";
    self.view.backgroundColor = kColorBg;
    [self mouseregister];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击空白处收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - Method
//注册界面
- (void)mouseregister {
    //填写信息界面
    [self registerView];
    //注册按钮
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, self.registerView.bottom + 15, kMainScreenWidth - 50, 50)];
    registerBtn.backgroundColor = RGBColor(25, 182, 158);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.layer.cornerRadius = 6;
    [registerBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}

//工种选择
- (void)chooseWorkType {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    KGPickerView *pickerView = [[KGPickerView alloc] initWithStyle:KGPickerViewStyleWorkType Title:@"请选择工种" delegate:self];
    [pickerView showInView:self.view];
}
//性别选择
- (void)chooseSex {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    KGPickerView *pickerView = [[KGPickerView alloc] initWithStyle:6 Title:@"请选择性别" delegate:self];
    [pickerView showInView:self.view];
}
//注册账号
- (void)registerBtnClick {
    //    String staff_name   姓名
    //    String staff_age   年龄
    //    String type_of_work_id   工种(目前只有4种)
    //    String staff_sex   性别
    //    String staff_phone   电话号码
    //    String staff_password   密码(MD5加密,Ok)
    //    String registration_code   注册码
    //    String code   短信验证码
    if (self.nickNameField.text.length == 0 || self.ageField.text.length == 0 || [self.workTypeLb.text isEqualToString:@"请选择"] || [self.sexLb.text isEqualToString:@"请选择"] || self.phoneField.text.length == 0 || self.verCodeField.text.length == 0 || self.passField.text.length == 0 || self.surePassField.text.length == 0 || self.invitationCodeField.text.length == 0) {
        [self.view showWarning:@"信息不能为空"];
        return;
    }
    if (![self.passField.text isEqualToString:self.surePassField.text]) {
        [self.view showWarning:@"两次输入密码不一致"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"staff_name"] = self.nickNameField.text;
    parameters[@"staff_age"] = self.ageField.text;
    if ([self.workTypeLb.text isEqualToString:@"安保"]) {
        parameters[@"type_of_work_id"] = @1;
    }
    if ([self.workTypeLb.text isEqualToString:@"保洁"]) {
        parameters[@"type_of_work_id"] = @2;
    }
    if ([self.workTypeLb.text isEqualToString:@"摆渡车"]) {
        parameters[@"type_of_work_id"] = @3;
    }
    if ([self.workTypeLb.text isEqualToString:@"游船"]) {
        parameters[@"type_of_work_id"] = @4;
    }
    parameters[@"staff_sex"] = self.sexLb.text;
    parameters[@"staff_phone"] = self.phoneField.text;
    parameters[@"code"] = self.verCodeField.text;
    parameters[@"staff_password"] = [Common md5:self.passField.text];;
    parameters[@"registration_code"] = self.invitationCodeField.text;
    parameters[@"appKey"] = kMOBApp;
    if ([Common getAsynchronousWithKey:kJPushRegisterId]) {
        parameters[@"regid"] = [Common getAsynchronousWithKey:kJPushRegisterId];
    }else {
        parameters[@"regid"] = kJPushRegisterId;
    }
    
    
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_Register parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [kMainWindow showWarning:@"注册成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
    }];
}

//获取验证码
- (void)clickVercodeBtn {
    if ([Common judgeMobileNumber:self.phoneField.text]) {
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:[NSString stringWithFormat:@"%@", self.phoneField.text] zone:@"86" customIdentifier:nil result:^(NSError *error) {
            if (!error) {
                NSLog(@"获取验证码成功");
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"获取验证码成功" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //点击按钮的响应事件；
                }]];
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
                
            } else {
                NSLog(@"错误信息：%@",error);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"获取验证码失败" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //点击按钮的响应事件；
                }]];
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
                
            }
        }];
    } else {
        [self.view showWarning:@"请输入正确的手机号"];
    }
}

/******** 自定义控件 ********/
-(UIView *)addWhiteViewWithFrame:(CGRect)frame
{
    UIView *whiteView = [[UIView alloc] initWithFrame:frame];
    whiteView.backgroundColor = [UIColor blackColor];
    whiteView.alpha = 0.3;
    [whiteView setBorderColor:kColorLine width:.5 cornerRadius:8];
    [self.view addSubview:whiteView];
    return whiteView;
}
-(UITextField *)addTextFieldWithView:(UIView *)whiteView andText: (NSString *)text
{
    UITextField *passField = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, kMainScreenWidth-50, 40)];
    passField.textColor = kColorWhite;
    
    UIColor *color = [UIColor whiteColor];
    passField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: color}];
    passField.font = [UIFont systemFontOfSize:16];
    [whiteView addSubview:passField];
    return passField;
}

- (UILabel *)addLabelWithFrame:(CGRect)frame andText:(NSString *)text {
    UILabel *phoneLab = [[UILabel alloc] initWithFrame:frame];
    phoneLab.text = text;
    phoneLab.textColor = RGBColor(66, 66, 66);
    phoneLab.adjustsFontSizeToFitWidth = YES;
    phoneLab.font = [UIFont systemFontOfSize:16];
    return phoneLab;
}

- (UITextField *)addTextFieldWithFrame:(CGRect)frame addText:(NSString *)text {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.textColor = kColorMajor;
    textField.placeholder = text;
    return textField;
}
/**************************/

#pragma mark - KGPicker Delegate
//刷新工种信息
- (void)confirmWorkType:(NSString *)string {
    self.workTypeLb.text = string;
}
//刷新性别
- (void)confirmSex:(NSString *)string {
    self.sexLb.text = string;
}
#pragma mark - Lazy Load
- (UIView *)registerView {
    if (!_registerView) {
        _registerView = [[UIView alloc] initWithFrame:CGRectMake(25, 25, kMainScreenWidth - 50, 495)];
        _registerView.backgroundColor = kColorWhite;
        _registerView.layer.cornerRadius = 6;
        [self.scrollView addSubview:_registerView];
        
        for (int i = 1; i < 9; i ++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 55 * i, _registerView.width - 20, 1)];
            lineView.backgroundColor = RGBColor(241, 241, 241);
            [_registerView addSubview:lineView];
        }
        for (int i = 0; i < 9; i ++) {
            UILabel *leftLab = [self addLabelWithFrame:CGRectMake(10, 55 * i, 80, 55) andText:kLeftArr[i]];
            [_registerView addSubview:leftLab];
        }
        //姓名
        _nickNameField = [self addTextFieldWithFrame:CGRectMake(90, 0, _registerView.width - 100, 55) addText:@"请输入姓名"];
        [_registerView addSubview:_nickNameField];
        //年龄
        _ageField = [self addTextFieldWithFrame:CGRectMake(90, 55, _registerView.width - 100, 55) addText:@"请输入年龄"];
        [_registerView addSubview:_ageField];
        //工种
        _workTypeBtn = [[UIButton alloc] init];
        [_registerView addSubview:_workTypeBtn];
        [_workTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(55 * 2 + 15);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(80);
        }];
        [_workTypeBtn setImage:[UIImage imageNamed:@"right_goto"] forState:UIControlStateNormal];
        [_workTypeBtn addTarget:self action:@selector(chooseWorkType) forControlEvents:UIControlEventTouchUpInside];
//        _workTypeBtn.backgroundColor = KcolorRed;
        _workTypeBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        
        _workTypeLb = [[UILabel alloc] init];
        [_registerView addSubview:_workTypeLb];
        [_workTypeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_workTypeBtn.mas_centerY);
            make.right.mas_equalTo(_workTypeBtn).mas_equalTo(-10);
            make.width.mas_equalTo(60);
        }];
        _workTypeLb.text = @"请选择";
        _workTypeLb.textColor = kColorMajor;
        
        //性别
        _sexBtn = [[UIButton alloc] init];
        [_registerView addSubview:_sexBtn];
        [_sexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(55 * 3 + 15);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(80);
        }];
        [_sexBtn setImage:[UIImage imageNamed:@"right_goto"] forState:UIControlStateNormal];
        [_sexBtn addTarget:self action:@selector(chooseSex) forControlEvents:UIControlEventTouchUpInside];
        _sexBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        _sexLb = [[UILabel alloc] init];
        [_registerView addSubview:_sexLb];
        [_sexLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_sexBtn.mas_centerY);
            make.right.mas_equalTo(_sexBtn).mas_equalTo(-10);
            make.width.mas_equalTo(60);
        }];
        _sexLb.text = @"请选择";
        _sexLb.textColor = kColorMajor;
        //手机号
        _phoneField = [self addTextFieldWithFrame:CGRectMake(90, 220, _registerView.width - 100, 55) addText:@"请输入手机号"];
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        [_registerView addSubview:_phoneField];
        
        //验证码
        _verCodeField = [self addTextFieldWithFrame:CGRectMake(90, 275, _registerView.width - 80 - 100, 55) addText:@"请输入验证码"];
        _verCodeField.keyboardType = UIKeyboardTypeNumberPad;
        [_registerView addSubview:_verCodeField];
        
        UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_verCodeField.right, 285, 80, 35)];
        [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [codeBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [codeBtn addTarget:self action:@selector(clickVercodeBtn) forControlEvents:UIControlEventTouchUpInside];
        codeBtn.backgroundColor = RGBColor(25, 182, 158);
        codeBtn.layer.cornerRadius = 5;
        [_registerView addSubview:codeBtn];
        
        //密码
        _passField = [self addTextFieldWithFrame:CGRectMake(90, 330, _registerView.width - 100, 55) addText:@"请输入密码"];
        [_registerView addSubview:_passField];
        _surePassField = [self addTextFieldWithFrame:CGRectMake(90, 385, _registerView.width - 100, 55) addText:@"请确认密码"];
        [_registerView addSubview:_surePassField];
        //工号
        _invitationCodeField = [self addTextFieldWithFrame:CGRectMake(90, 55 *8, _registerView.width - 100, 55) addText:@"请输入工号"];
        _invitationCodeField.keyboardType = UIKeyboardTypeNumberPad;
        [_registerView addSubview:_invitationCodeField];
    }
    return _registerView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:kMainScreenFrame];
        _scrollView.contentSize = kMainScreenFrame.size;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

@end
