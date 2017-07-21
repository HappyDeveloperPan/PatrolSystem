//
//  RetrieveViewController.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/31.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "RetrieveViewController.h"
#import <SMS_SDK/SMSSDK.h>

@interface RetrieveViewController ()
@property (nonatomic, strong) UIView *retrieveView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *phoneField, *verCodeField, *passField, *surePassField;
@end

@implementation RetrieveViewController

#define kMainArr @[@"手机号 ",@"验证码 ",@"密码 ",@"确认密码 "]

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.headTitle;
    self.view.backgroundColor = kColorBg;
    
    [self retrieveView];
    //修改密码按钮
    UIButton *retrieveBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, self.retrieveView.bottom + 15, kMainScreenWidth - 50, 50)];
    retrieveBtn.backgroundColor = RGBColor(25, 182, 158);
    [retrieveBtn setTitle:@"提交" forState:UIControlStateNormal];
    retrieveBtn.layer.cornerRadius = 6;
    [retrieveBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    retrieveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [retrieveBtn addTarget:self action:@selector(retrieveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retrieveBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Method
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

//提交按钮
- (void)retrieveBtnClick {
    if (self.phoneField.text.length == 0 || self.verCodeField.text.length == 0 || self.passField.text.length == 0 || self.surePassField.text.length == 0) {
        [self.view showWarning:@"信息不能为空"];
        return;
    }
    if (![self.passField.text isEqualToString:self.surePassField.text]) {
        [self.view showWarning:@"两次输入密码不一致"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"staff_phone"] = self.phoneField.text;
    parameters[@"code"] = self.verCodeField.text;
    parameters[@"appKey"] = kMOBApp;
    parameters[@"new_staff_password"] = [Common md5:self.passField.text];
    
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_Retrieve parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
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

#pragma mark - Lazy Load
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:kMainScreenFrame];
        _scrollView.contentSize = kMainScreenFrame.size;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)retrieveView {
    if (!_retrieveView) {
        _retrieveView = [[UIView alloc] initWithFrame:CGRectMake(25, 25, kMainScreenWidth - 50, 220)];
        _retrieveView.backgroundColor = kColorWhite;
        _retrieveView.layer.cornerRadius = 6;
        [self.scrollView addSubview:_retrieveView];
        
        for (int i = 1; i < 4; i ++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 55 * i, _retrieveView.width - 20, 1)];
            lineView.backgroundColor = RGBColor(241, 241, 241);
            [_retrieveView addSubview:lineView];
        }
        for (int i = 0; i < 4; i ++) {
            UILabel *leftLab = [self addLabelWithFrame:CGRectMake(10, 55 * i, 80, 55) andText:kMainArr[i]];
            [_retrieveView addSubview:leftLab];
        }
        //手机号
        _phoneField = [self addTextFieldWithFrame:CGRectMake(90, 0, _retrieveView.width - 100, 55) addText:@"请输入手机号"];
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        [_retrieveView addSubview:_phoneField];
        
        //验证码
        _verCodeField = [self addTextFieldWithFrame:CGRectMake(90, 55, _retrieveView.width - 80 - 100, 55) addText:@"请输入验证码"];
        _verCodeField.keyboardType = UIKeyboardTypeNumberPad;
        [_retrieveView addSubview:_verCodeField];
        
        UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_verCodeField.right, 65, 80, 35)];
        [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [codeBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [codeBtn addTarget:self action:@selector(clickVercodeBtn) forControlEvents:UIControlEventTouchUpInside];
        codeBtn.backgroundColor = RGBColor(25, 182, 158);
        codeBtn.layer.cornerRadius = 5;
        [_retrieveView addSubview:codeBtn];
        
        //密码
        _passField = [self addTextFieldWithFrame:CGRectMake(90, 110, _retrieveView.width - 100, 55) addText:@"请输入密码"];
        [_retrieveView addSubview:_passField];
        _surePassField = [self addTextFieldWithFrame:CGRectMake(90, 165, _retrieveView.width - 100, 55) addText:@"请确认密码"];
        [_retrieveView addSubview:_surePassField];
    }
    return _retrieveView;
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
