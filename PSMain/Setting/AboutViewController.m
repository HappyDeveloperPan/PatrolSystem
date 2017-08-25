//
//  AboutViewController.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/12/31.
//  Copyright © 2016年 吴迪. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *versionNumberLab;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *introduceLab;
@end

#define kDataSourceArr @[@"去评分",@"欢迎页",@"版本更新"]

@implementation AboutViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于逸途";
    self.view.backgroundColor = kColorBg;

    [self imageView];
    [self versionNumberLab];
//    [self tableView];
    [self introduceLab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = kDataSourceArr[indexPath.row];
    cell.textLabel.textColor = kColorMajor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - Lazy Load
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self.view addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(100);
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(40);
        }];
        _imageView.layer.cornerRadius = 5;
        //    imageView.backgroundColor = KcolorRed;
        //    NSString *path = [[NSBundle mainBundle] pathForResource:@"aboutYiTu" ofType:@"png"];
        //    [imageView setImage:[UIImage imageWithContentsOfFile:path]];
        [_imageView setImage:[UIImage imageNamed:@"aboutYiTu"]];
    }
    return _imageView;
}

- (UILabel *)versionNumberLab {
    if (!_versionNumberLab) {
        _versionNumberLab = [[UILabel alloc] init];
        [self.view addSubview:_versionNumberLab];
        [_versionNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(kMainScreenWidth);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(self.imageView.mas_bottom).mas_equalTo(10);
        }];
        _versionNumberLab.text = @"版本号 1.0.0";
        _versionNumberLab.textAlignment = NSTextAlignmentCenter;
        _versionNumberLab.textColor = kColorMajor;
    }
    return _versionNumberLab;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(kMainScreenWidth);
            make.top.mas_equalTo(self.versionNumberLab.mas_bottom).mas_equalTo(10);
            make.height.mas_equalTo(149);
        }];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (UILabel *)introduceLab {
    if (!_introduceLab) {
        _introduceLab = [[UILabel alloc] init];
        [self.view addSubview:_introduceLab];
        [_introduceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kMainScreenWidth);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(90);
        }];
        _introduceLab.numberOfLines = 3;
        _introduceLab.textAlignment = NSTextAlignmentCenter;
        _introduceLab.textColor = kColorMajor;
        _introduceLab.font = [UIFont systemFontOfSize:13];
        _introduceLab.text = @"逸途科技信息公司服务与协议\n智慧旅游  逸途在线\ncopyright@2016-2017 Yitu.All Rights Reserved";
    }
    return _introduceLab;
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
