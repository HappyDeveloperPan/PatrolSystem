//
//  Common.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2016/11/2.
//  Copyright © 2016年 panpan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Additions.h"
#import "SecurityViewController.h"
#import "ShuttleBusViewController.h"
#import "PleasureBoatViewController.h"
#import "CleaningViewController.h"
#import "SettingViewController.h"
@import CoreLocation;

@interface Common : NSObject

/* 数据持久化 */
+(id)getAsynchronousWithKey:(NSString *)key;
+(void)clearAsynchronousWithKey:(NSString *)key;
+(void)setAsynchronous:(id)object WithKey:(NSString *)key;

+(CGSize)sizeWithString:(NSString *)string width:(float)width font:(float)font;

/* 字符串遍历 */
+ (CGFloat)content: (NSString *)s;

/* lable共同说明*/
+(UILabel *)labelExplainedWithFrame:(CGRect)frame;

/* 线的图片*/
+(UIImageView *)lineViewWithFrame:(CGRect)frame;

/* 手机号判断*/
+ (BOOL)judgeMobileNumber:(NSString *)mobileNum;

/*偏移*/
+ (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect;

/* 右边栏返回 */
+(UIBarButtonItem *)noTitlebackBtnWithTarget:(id)target selector:(SEL)selector;

//控件的快捷生成
+ (UIButton *)addBtnWithImage:(NSString *)imageName;
+ (UIView *)addViewWithFrame :(CGRect)frame;
+ (UILabel *)badgeNumLabWithFrame:(CGRect)frame;
+ (void)layoutBadge:(UILabel *)badgeLab andCount:(NSInteger)count;

//获取当前时间
+(NSString *)formatWithDate;
//比较是否同一天
+(BOOL)isSameDayWithDate:(NSString *)dateStr;

//去掉导航栏阴影
+(void)setUpNavBar:(UINavigationBar *)navigationBar;

//MD5加密
+ (NSString *)md5:(NSString *)str;

//转GCJ-02 国际坐标转火星坐标
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

//字典转data
+ (NSData *)dictionnaryObjectToString: (NSDictionary *)dic;

//返回带颜色属性文字
+ (NSAttributedString *)colorTextWithString:(NSString *)string andRange:(NSString *)range andColor:(UIColor *)color;
#pragma mark -崩溃日志发送邮件给开发者
+(void)catchEexceptionMailToDeveloperWithNSException:(NSException *)exception;
@end
