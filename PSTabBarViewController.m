//
//  PSTabBarViewController.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/14.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "PSTabBarViewController.h"
#import "SecurityViewController.h"
#import "ShuttleBusViewController.h"
#import "PleasureBoatViewController.h"
#import "CleaningViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "HomePageViewController.h"

@interface PSTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation PSTabBarViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [kNotificationCenter addObserver:self selector:@selector(notiPresentLogin:) name:kNotifPresentLogin object:nil];
    
    // Do any additional setup after loading the view.
    NSDictionary *userDic = [Common getAsynchronousWithKey:kSavedUser];
    [UserManager sharedManager].workType = [userDic[@"type_of_work_id"] integerValue];;
    //安保
//    if ([userDic[@"type_of_work_id"] intValue] == 1) {
//        SecurityViewController *securityVc = [SecurityViewController new];
//        securityVc.title = @"主页";
//        securityVc.tabBarItem.image = [[UIImage imageNamed:@"homepage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        securityVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"homepage-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        UINavigationController *securityNav = [[UINavigationController alloc] initWithRootViewController:securityVc];
//        [self addChildViewController:securityNav];
//    }
//    //宝洁
//    if ([userDic[@"type_of_work_id"] intValue] == 2) {
//        CleaningViewController *cleaningVc = [CleaningViewController new];
//        cleaningVc.title = @"主页";
//        cleaningVc.tabBarItem.image = [[UIImage imageNamed:@"homepage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        cleaningVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"homepage-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        UINavigationController *cleaningNav = [[UINavigationController alloc] initWithRootViewController:cleaningVc];
//        [self addChildViewController:cleaningNav];
//    }
//    //摆渡车
//    if ([userDic[@"type_of_work_id"] intValue] == 3) {
//        ShuttleBusViewController *shuttleBusVc = [ShuttleBusViewController new];
//        shuttleBusVc.title = @"主页";
//        shuttleBusVc.tabBarItem.image = [[UIImage imageNamed:@"homepage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        shuttleBusVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"homepage-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        UINavigationController *shuttleBusNav = [[UINavigationController alloc] initWithRootViewController:shuttleBusVc];
//        [self addChildViewController:shuttleBusNav];
//    }
//    //游船
//    if ([userDic[@"type_of_work_id"] intValue] == 4) {
//        PleasureBoatViewController *pleasureBoatVc = [PleasureBoatViewController new];
//        pleasureBoatVc.title = @"主页";
//        pleasureBoatVc.tabBarItem.image = [[UIImage imageNamed:@"homepage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        pleasureBoatVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"homepage-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        UINavigationController *pleasureBoatNav = [[UINavigationController alloc] initWithRootViewController:pleasureBoatVc];
//        [self addChildViewController:pleasureBoatNav];
//    }
    //设置
    HomePageViewController *homePageVc = [HomePageViewController new];
    homePageVc.workType = [userDic[@"type_of_work_id"] integerValue];
    homePageVc.title = @"主页";
    homePageVc.tabBarItem.image = [[UIImage imageNamed:@"homepage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homePageVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"homepage-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UINavigationController *homePageNav = [[UINavigationController alloc] initWithRootViewController:homePageVc];
    [self addChildViewController:homePageNav];
    
    SettingViewController *settingVc = [SettingViewController new];
    settingVc.workType = [userDic[@"type_of_work_id"] integerValue];
    settingVc.title = @"设置";
    settingVc.tabBarItem.image = [[UIImage imageNamed:@"personal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    settingVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"personal-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:settingVc];
    [self addChildViewController:settingNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITabBarController Delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0);
{
    if (![[UserManager sharedManager] isLogin] && [self.viewControllers indexOfObject:viewController] >= 1)
    {
        [self notiPresentLogin:nil];
        return NO;
    }
    
    return YES;
}

#pragma mark - Method
//跳转到登录界面
-(void)notiPresentLogin:(NSNotification *)notif
{
    UINavigationController *selectNavVC = (UINavigationController *)self.selectedViewController;
    if (selectNavVC.presentedViewController) {
        selectNavVC = (UINavigationController *)selectNavVC.presentedViewController;
    }
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [selectNavVC presentViewController:navVC animated:YES completion:nil];
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
