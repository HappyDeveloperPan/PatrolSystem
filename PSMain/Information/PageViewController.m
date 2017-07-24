//
//  PageViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/19.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "PageViewController.h"
#import "HelpInfoViewController.h"
#import "NotifCenterViewController.h"
#import "JPUSHService.h"

@interface PageViewController ()

@end

#define kMenuHeight 40

@implementation PageViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
//    [super viewDidLoad];
    self.title = @"通知中心";
    self.view.backgroundColor = kColorBg;
    self.menuBGColor = kColorWhite;
    self.titleColorNormal = kColorMajor;
    self.titleColorSelected = kColorMain;
    //设置高度
    self.menuHeight = kMenuHeight;
    //设置横线风格
    self.menuViewStyle = WMMenuViewStyleLine;
    self.titleSizeSelected = 15;
    self.titleSizeNormal = 15;
    
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
}

//重写父类的titiles属性的getter方法, 设置题目
- (NSArray<NSString *> *)titles{
    return @[@"工作信息", @"一键求助"];
}


#pragma mark - WMPage Delegate
//内部有多少个子视图
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}
//每个子控制器什么样
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        NotifCenterViewController *jumpVc = [[NotifCenterViewController alloc] init];
        jumpVc.topHeight = kMenuHeight;
        return jumpVc;
    }
    if (index == 1) {
        HelpInfoViewController *jumpVc = [[HelpInfoViewController alloc] init];
        jumpVc.topHeight = kMenuHeight;
        jumpVc.infoType = HelpInfo;
        return jumpVc;
    }
//    ScenicShowDetailViewController *jumpVC = [[ScenicShowDetailViewController alloc] init];
//    jumpVC.model = self.model;
//    return jumpVC;
    return nil;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    return self.titles[index];
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
