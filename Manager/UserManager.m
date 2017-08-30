//
//  UserManager.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/11.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "UserManager.h"
#import "SocketManager.h"
#import "HelpSocketManager.h"

@implementation UserManager

static UserManager *manager;


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

+ (UserManager *)sharedManager {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (id)copyWithZone:(NSZone *)zone {
    return manager;
}


- (BOOL)isLogin {
    return self.user.account_token?YES:NO;
}

+ (void)loginWithPhone:(NSString *)phone andPass:(NSString *)pass andSuccess:(void (^)(PSUser *, NSError *))successHandler andFailure:(FailureHandler)failureHandler {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"staff_phone"] = phone;
    parameters[@"staff_password"] = pass;
    if ([Common getAsynchronousWithKey:kJPushRegisterId]) {
        parameters[@"regid"] = [Common getAsynchronousWithKey:kJPushRegisterId];
    }else {
        parameters[@"regid"] = kJPushRegisterId;
    }
    
    
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_Login parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData && [jsonData[@"resultnumber"] intValue] == 200) {
            if (successHandler) {
                [Common setAsynchronous:jsonData[@"result"][@"staff"] WithKey:kSavedUser];
                [Common setAsynchronous:jsonData[@"result"][@"account_token"] WithKey:kSaveToken];
                successHandler([PSUser parse:jsonData[@"result"]], error);
            }
        }else{
            if (!error) {
                error = [NSError errorWithDomain:jsonData[@"cause"] code:[jsonData[@"resultnumber"] intValue] userInfo:nil];
            }
            if (failureHandler) {
                failureHandler(error);
            }
        }
    }];
}

+ (void)QuickLoginWithToken:(NSString *)token andSuccess:(void (^)(id , NSError *))successHandler andFailure:(FailureHandler)failureHandler {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = token;
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_QuickLogin parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData && [jsonData[@"resultnumber"] intValue] == 200) {
            if (successHandler) {
                [Common setAsynchronous:jsonData[@"result"] WithKey:kSavedUser];
                successHandler([StaffModel parse:jsonData[@"result"]], error);
//                [[UserManager sharedManager] loadStaffTask];
            }
        }else{
            if (!error) {
                error = [NSError errorWithDomain:jsonData[@"cause"] code:[jsonData[@"resultnumber"] intValue] userInfo:nil];
                if ([jsonData[@"resultnumber"] intValue] != 200) {
                    [kNotificationCenter postNotificationName:kNotifPresentLogin object:nil];
                    [[UserManager sharedManager] logout];
                    return ;
                }
            }
            if (failureHandler) {
                failureHandler(error);
            }
        }

    }];
}

//暂时没有完善
- (void)loadStaffTask {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_GetStaffTask parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                
            }else {
                [kMainWindow showWarning:jsonData[@"cause"]];
            }
        } else {
            [kMainWindow showWarning:error.domain];
        }

    }];
}

-(void)logout {
    [UserManager sharedManager].user = nil;
    [[SocketManager sharedSocket] disconnectedSocket];
    [[HelpSocketManager sharedSocket] disconnectedSocket];
    [Common clearAsynchronousWithKey:kSavedUser];
    [Common clearAsynchronousWithKey:kSaveToken];
    [Common clearAsynchronousWithKey:kSignInRecord];
}

#pragma mark - Lazy Load
- (instancetype)init {
    if (self = [super init]) {
        _user = [[PSUser alloc] init];
        _securityModel = [[SecurityModel alloc] init];
        _cleaningModel = [[CleaningModel alloc] init];
        _shuttleBusTaskModel = [[ShuttleBusTaskModel alloc] init];
        _cruiseModel = [[CruiseModel alloc] init];
        _isAddImg = YES;
    }
    return self;
}
@end
