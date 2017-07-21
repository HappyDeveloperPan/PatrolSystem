//
//  UserManager.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/11.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSUser.h"
#import "SecurityModel.h"
#import "CleaningModel.h"
#import "ShuttleBusTaskModel.h"
#import "CruiseModel.h"

typedef void(^FailureHandler)(NSError *error);
#define kCompetionHandlerBlock (void(^)(id model, NSError *error))completionHandler;

@interface UserManager : NSObject<NSCopying>
@property (nonatomic, strong) PSUser *user;
@property (nonatomic, strong) SecurityModel *securityModel;
@property (nonatomic, strong) CleaningModel *cleaningModel;
@property (nonatomic, strong) ShuttleBusTaskModel *shuttleBusTaskModel;
@property (nonatomic, strong) CruiseModel *cruiseModel;
@property (nonatomic, assign) BOOL isAddImg, isGetAllTask;
@property (nonatomic, assign) BOOL isAllowSubmitTask;
@property (nonatomic, assign) NSInteger workType;

+ (UserManager *)sharedManager;
- (BOOL)isLogin;


/**
 用户登录

 @param phone 电话
 @param pass 密码
 @param successHandler 成功回调
 @param failureHandler 失败回调
 */
+ (void)loginWithPhone: (NSString *)phone andPass:(NSString *)pass andSuccess:(void(^)(PSUser *user, NSError *error))successHandler andFailure:(FailureHandler)failureHandler;

/**
 快速登录

 @param token token值
 @param successHandler 成功回调
 @param failureHandler 失败回调
 */
+ (void)QuickLoginWithToken:(NSString *)token andSuccess:(void(^)(id user, NSError *error))successHandler andFailure:(FailureHandler)failureHandler;

/**
 退出登录
 
 **/
- (void)logout;

- (void)loadStaffTask;
@end
