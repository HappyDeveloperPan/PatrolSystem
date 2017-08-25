//
//  AppDelegate.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/1.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "AppDelegate.h"
#import <SMS_SDK/SMSSDK.h>
#import "LoginViewController.h"
#import "SignInViewController.h"
#import "PSTabBarViewController.h"
#import "JPUSHService.h"
#import "SocketManager.h"
#import "WelcomeViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AvoidCrash.h>
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>
@end

//注册函数, 崩溃日志
void uncaughtExceptionHandler(NSException* exception)
{
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
    [Common catchEexceptionMailToDeveloperWithNSException:exception];
}

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 注册异常监听
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    /******************高德地图**********************/
    [AMapServices sharedServices].apiKey = kAMPApikey;
    
    /***************mob短信验证,初始化***************/
    [SMSSDK registerApp:kMOBApp withSecret:kMOBSecret];
    /**********开启AvoidCrash************/
    [AvoidCrash becomeEffective];
    
    /*******************极光推送*********************/
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //      NSSet<UNNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
        //    else {
        //      NSSet<UIUserNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppkey channel:@"PatrolSystem channel" apsForProduction:YES advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [Common setAsynchronous:registrationID WithKey:kJPushRegisterId];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    /*******************键盘监听***********************/
    IQKeyboardManager *manager =  [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = NO;//这个是它自带键盘工具条开关
    
    self.window = [[UIWindow alloc] initWithFrame:kMainScreenFrame];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *versionNumber = infoDic[@"CFBundleShortVersionString"];
    NSLog(@"版本号: %@", versionNumber);
    NSString *runVersionNumber = [Common getAsynchronousWithKey:kRunVersion];
    NSLog(@"现有版本号 : %@", runVersionNumber);
    if (runVersionNumber == nil || ![runVersionNumber isEqualToString:versionNumber]) {
        WelcomeViewController *welcomeVc = [[WelcomeViewController alloc] init];
        self.window.rootViewController = welcomeVc;
    }else {
        /*************根据当天是否签到跳转页面********************/
        [self jumpVcFromSignIn];
//        self.window.rootViewController = [PSTabBarViewController new];
    }
    [self.window makeKeyAndVisible];
    
    //自动登录获取用户信息
    [self QuickLogin];
    
    /********************全局配置*********************/
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //顶部Nav栏设置
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].barTintColor = RGBColor(25, 182, 158);  //背景颜色
    [UINavigationBar appearance].tintColor = kColorWhite;                 //返回按钮颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}]; //标题颜色
    
    //底部Tabbar栏设置
    [UITabBar appearance].translucent = NO;
    [UITabBar appearance].tintColor = RGBColor(25, 182, 158);   //tab背景颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: RGBColor(25, 182, 158)} forState:UIControlStateSelected];  //顶部按钮字体颜色
    /*******************************************/
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSString *dateStr = [Common getAsynchronousWithKey:kSignInRecord];
    if (![Common isSameDayWithDate:dateStr]) {
        SignInViewController *loginVc = [SignInViewController new];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVc];
        self.window.rootViewController = loginNav;
        [[SocketManager sharedSocket] disconnectedSocket];
        [self QuickLogin];
    }
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 极光推送 Method
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [kNotificationCenter postNotificationName:kShowRedBadge object:nil];
        PSUser *model = [PSUser parse:userInfo];
        if ([model.type isEqualToString:@"emergencyCallingDisposeStaffPush"]) {
            [[WarningManager shareManager] startScreenFlicker];
        }
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [kNotificationCenter postNotificationName:kShowRedBadge object:nil];
        PSUser *model = [PSUser parse:userInfo];
        if ([model.type isEqualToString:@"emergencyCallingDisposeStaffPush"]) {
            [[WarningManager shareManager] startScreenFlicker];
        }
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)jumpVcFromSignIn {
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //    NSDictionary *userDic = [Common getAsynchronousWithKey:kSavedUser];
    //    PSUser *user = [PSUser parse:userDic];
    NSString *dateStr = [Common getAsynchronousWithKey:kSignInRecord];
    if ([Common isSameDayWithDate:dateStr]) {
        self.window.rootViewController = [PSTabBarViewController new];
    }else {
        SignInViewController *loginVc = [SignInViewController new];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVc];
        self.window.rootViewController = loginNav;
    }
//    [self.window makeKeyAndVisible];
}

- (void)QuickLogin {
    NSString *userToken = [Common getAsynchronousWithKey:kSaveToken];
    if (userToken) {
        [UserManager QuickLoginWithToken:userToken andSuccess:^(StaffModel *user, NSError *error) {
            [UserManager sharedManager].user.staff = user;
            [UserManager sharedManager].user.account_token = userToken;
            [[LocationManager sharedManager] startUserLocation];
            [kNotificationCenter postNotificationName:kReloadInfo object:nil];
            if ([UserManager sharedManager].user.staff.sign_in) {
                //将签到日期保存
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                [Common setAsynchronous:[formatter stringFromDate:date] WithKey:kSignInRecord];
                [[SocketManager sharedSocket] connectServerWithAdress:socketAdress andPort:socketPort];
            }
            //            if (![UserManager sharedManager].user.staff.task) {
            //                [kNotificationCenter postNotificationName:KNotifShowTask object:nil];
            //            }
        } andFailure:^(NSError *error) {
            
        }];
    }
}

@end
