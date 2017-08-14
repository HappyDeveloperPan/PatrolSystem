//
//  ToolsMacro.h
//  CarHelper
//
//  Created by linyingbin on 15/4/23.
//  Copyright (c) 2015年 林 英彬. All rights reserved.
//

#ifndef CarHelper_ToolsMacro_h
#define CarHelper_ToolsMacro_h

// 10进制与16进制颜色值设置
#define UIColorFromRGB_10(r,g,b) \
[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorFromRGB_16(rgbValue) \
([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

#define kColorMajor     UIColorFromRGB_16(0x666666)
#define kColorMin       UIColorFromRGB_16(0x999999)
#define kColorMin2      UIColorFromRGB_16(0xaeaeae)
#define kColorMin3      UIColorFromRGB_16(0xc8c8c8)

#define kColorBg        UIColorFromRGB_16(0xefeff4)
#define kColorBg2       UIColorFromRGB_16(0xf6f6f6)
#define kColorBlue      UIColorFromRGB_16(0x1c95d1)
#define kColorYellow    UIColorFromRGB_16(0xfdd922)
#define kColorPink      UIColorFromRGB_16(0xfb528e)
#define kColorBgBlue    UIColorFromRGB_16(0xc4e0ee)
#define kColorGreen     UIColorFromRGB_16(0x00ba3e)
#define kColorLightBlue UIColorFromRGB_16(0x00b4ff)
#define kColorLightRed  UIColorFromRGB_16(0xff5b45)

#define KcolorHightGray UIColorFromRGB_16(0xbfbfbf)
#define KcoloGray       UIColorFromRGB_16(0xafafaf)
#define KcolorWite      UIColorFromRGB_16(0xffffff)
#define KcoloGreen      UIColorFromRGB_16(0x29b624)
#define KcolorRed       UIColorFromRGB_16(0xfe4747)
#define kColorTitle     UIColorFromRGB_16(0x0096ff)

#define kColorChartLow  UIColorFromRGB_16(0x04ccd3)
#define kColorChartNomal UIColorFromRGB_16(0x888888)
#define kColorLine      UIColorFromRGB_16(0xd9d9d9)
#define kColorOrange    UIColorFromRGB_10(237,103,49)
#define kColorBgNew     UIColorFromRGB_16(0x0b3860)




#define RGBColor(x,y,z)         [UIColor colorWithRed:x/255. green:y/255. blue:z/255. alpha:1]

#define KcolorAppTitle           RGBColor(248,178,13)
#define kColoeLineColor          RGBColor(152,152,152)
#define kColorDarkGray          RGBColor(218,218,218)
#define kColorLightGray         RGBColor(233,233,233)
#define kColorLightGray         RGBColor(233,233,233)
#define kColorMain               RGBColor(25, 182, 158)

#define kColorWhite             [UIColor whiteColor]

#define kLineHeight     .5

#define KTextAdd            @"Helvetica"

#define kBtnImage [[UIImage imageNamed:@"login_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)]
#define kBtnImage2 [[UIImage imageNamed:@"login_btnclick"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)]

#define kMainScreenFrame [[UIScreen mainScreen] bounds]
#define kMainScreenWidth kMainScreenFrame.size.width
#define kMainScreenHeight kMainScreenFrame.size.height

#define iPhone5   kMainScreenWidth  == 320
#define iPhone6   kMainScreenWidth  == 375
#define iPhone6p  kMainScreenWidth  == 414

#define login_btn_W    200
#define login_btn_H    40
#define login_Btn_X         (kMainScreenWidth - 200)/2

//#define telephoneStr    @"65857532"

#define iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

//主窗口
#define kMainWindow [[[UIApplication sharedApplication] delegate] window]
// NSUserDefaults 实例化
#define kNSUserDefault [NSUserDefaults standardUserDefaults]
#define kRunVersion           @"runVersion"
#define kSearchHistory       @"searchHistory"
#define kLanguageType        @"languageType"
#define kSavedUserPass       @"savedUserPass"
#define kTagsArray            @"tagsArray"
#define kBlackArray           @"blacklist"
#define kSignInRecord         @"signInrecord"
#define kLocationChanged     @"locationChange"
#define kSocketData           @"socketData"
#define kHelpSocketData      @"helpSocketData"

//第三方接口appkey
//高德地图
#define kAMPApikey @"b5cc669b5ff950a8d053a44a89e4c5a8"
//MOB
#define kMOBApp @"1cd4f91c22ea8"
#define kMOBSecret @"02bbaa053d909f0a494edef031a1a6fe"

//极光推送
#define kJPushAppkey @"d661ae6d834e5e21d3c6ae32"
#define kJPushSecret @"0900404b2b9264b9d7e911fe"
#define kJPushRegisterId @"JPushRegisterId"
//
#define kNotificationCenter         [NSNotificationCenter defaultCenter]
#define kNotifPresentLogin          @"presentLogin"
#define kNotifLogout                 @"logout"
#define kNotiSOS                      @"sosAnnotation"
#define kReloadHead                  @"reloadHead"
#define kSavedUser                   @"userDic"
#define kSaveToken                   @"userToken"
#define kReloadInfo                  @"reloadInfo"
#define KNotifShowTask              @"showTask"
#define kShowRedBadge               @"showRedBadge"

/****/
#define kNotifPopVC                 @"popVC"
/****/

/***********************************/
#ifdef DEBUG
#define CLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:\n%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define CLog(format, ...)
#define NSLog(FORMAT, ...) nil
#endif

//#ifdef DEBUG
//#define NSLog(format, ...) printf("\n[%s] %s  %s\n", __TIME__, __FUNCTION__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
//#else
//#define NSLog(format, ...)
//#endif
/**********************************/

//----------------------系统----------------------------
//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]
//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define isiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif
//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
//----------------------系统----------------------------

#endif
