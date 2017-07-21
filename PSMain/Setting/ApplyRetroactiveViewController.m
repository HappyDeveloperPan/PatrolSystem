//
//  ApplyRetroactiveViewController.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/6.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "ApplyRetroactiveViewController.h"
#import "MyTextView.h"

@interface ApplyRetroactiveViewController ()
@property (nonatomic, strong) MyTextView *textView;
@property (nonatomic, strong) NSMutableArray *buttonArr;
@property (nonatomic, assign) NSInteger reasonType;
@end

#define ktop 20

@implementation ApplyRetroactiveViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请补签";
    self.view.backgroundColor = kColorWhite;
    
    self.reasonType = 1;
    
    UILabel *securityLab = [[UILabel alloc] init];
    CGSize size = [Common sizeWithString:@"请选择补签类型: " width:300 font:15];
    securityLab.frame = CGRectMake(15, ktop, size.width, 30);
    securityLab.text = @"请选择补签类型:";
    securityLab.font = [UIFont systemFontOfSize:15];
    securityLab.textColor = kColorMajor;
    [self.view addSubview:securityLab];
    
    
    self.buttonArr = [NSMutableArray new];
    UIImage *checkImg = [UIImage imageNamed:@"checkmark"];
    UIImage *uncheckImg = [UIImage imageNamed:@"checkmark-2"];
    
    UIButton *checkOne = [[UIButton alloc] initWithFrame:CGRectMake(securityLab.right + 5, ktop, 30, 30)];
    [checkOne setBackgroundImage:uncheckImg forState:UIControlStateNormal];//正常状态图片是非选中的
    [checkOne setBackgroundImage:checkImg forState:UIControlStateSelected];
    checkOne.tag = 1;
    checkOne.selected = YES; //初始化默认选择IP方式
    [checkOne addTarget:self action:@selector(checkBoxClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonArr addObject:checkOne];
    [self.view addSubview:checkOne];
    UILabel *checkLbOne = [[UILabel alloc] initWithFrame:CGRectMake(checkOne.right + 5, 15, 40, 40)];
    checkLbOne.text = @"请假";
    //        checkLbOne.font = [UIFont systemFontOfSize:14];
    checkLbOne.textColor = kColorMajor;
    [self.view addSubview:checkLbOne];
    
    UIButton *checkTwo = [[UIButton alloc] initWithFrame:CGRectMake(checkLbOne.right + 20, ktop, 30, 30)];
    [checkTwo setBackgroundImage:uncheckImg forState:UIControlStateNormal];//正常状态图片是非选中的
    [checkTwo setBackgroundImage:checkImg forState:UIControlStateSelected];
    checkTwo.tag = 2;
    [checkTwo addTarget:self action:@selector(checkBoxClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonArr addObject:checkTwo];
    [self.view addSubview:checkTwo];
    UILabel *checkLbTwo = [[UILabel alloc] initWithFrame:CGRectMake(checkTwo.right + 5, 15, 40, 40)];
    checkLbTwo.text = @"出差";
    //        checkLbTwo.font = [UIFont systemFontOfSize:14];
    checkLbTwo.textColor = kColorMajor;
    [self.view addSubview:checkLbTwo];
    
    UILabel *warningLab = [[UILabel alloc] initWithFrame:CGRectMake(15, checkTwo.bottom + 10, kMainScreenWidth - 30, 30)];
    warningLab.text = @"*请填写补签原因";
    warningLab.font = [UIFont systemFontOfSize:15];
    warningLab.textColor = kColorMajor;
    [self.view addSubview:warningLab];
    
    self.textView = [[MyTextView alloc] initWithFrame:CGRectMake(15, warningLab.bottom + 10, kMainScreenWidth - 30, kMainScreenHeight * 0.3)];
    self.textView.placeholder = @"补签原因....(选填)";
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.backgroundColor = kColorBg;
    //        _myTextView.clearsOnInsertion = YES; //是否直接弹出键盘
    [self.view addSubview:self.textView];
    
    UIButton *fillCheckBtn = [[UIButton alloc] init];
    [self.view addSubview:fillCheckBtn];
    [fillCheckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-30);
        make.size.mas_equalTo(CGSizeMake(160, 45));
    }];
    [fillCheckBtn setTitle:@"申请补签" forState:UIControlStateNormal];
    [fillCheckBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [fillCheckBtn setBackgroundColor:kColorMain];
    fillCheckBtn.layer.cornerRadius = 5;
    [fillCheckBtn addTarget:self action:@selector(applyRetroactive) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method
//申请补签
- (void)applyRetroactive {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy-MM-dd"];
    params[@"examine_approve_sign_times"] =[fomatter stringFromDate:self.date];
    params[@"clock_reason_type_id"] = [NSString stringWithFormat:@"%ld", (long)self.reasonType];
    params[@"examine_approve_sign_cause"] = self.textView.text;;
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_ApplyFillCheck parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [kMainWindow showWarning:@"申请成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }

    }];
}

- (void)checkBoxClick:(UIButton *)sender {
    for (UIButton *button in self.buttonArr) {
        if (button == sender) {
            [button setSelected:YES];
        }else {
            [button setSelected:NO];
        }
    }
    self.reasonType = sender.tag;
//    if (sender.tag == 10) {
//        [self.textView removeFromSuperview];
//    }
//    if (sender.tag == 20) {
//        [self addSubview:self.warningLab];
//        [self addSubview:self.textView];
//    }
}
#pragma mark - Lazy Load
- (MyTextView *)textView {
    if (!_textView) {
        _textView = [[MyTextView alloc] initWithFrame:CGRectMake(15, 80, kMainScreenWidth - 30, 140)];
        _textView.placeholder = @"补签原因....(选填)";
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.backgroundColor = kColorBg;
        //        _myTextView.clearsOnInsertion = YES; //是否直接弹出键盘
        [self.view addSubview:_textView];
    }
    return _textView;
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
