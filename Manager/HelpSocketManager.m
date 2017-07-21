//
//  HelpSocketManager.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/23.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "HelpSocketManager.h"

@implementation HelpSocketManager
static  HelpSocketManager*manager;
#pragma mark - Life Circle
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

+ (HelpSocketManager *)sharedSocket {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (id)copyWithZone:(NSZone *)zone {
    return manager;
}
#pragma mark - Method
- (void)connectServerWithAdress:(NSString *)adress andPort:(uint16_t)port {
    self.host = adress;
    self.port = port;
    NSError *error;
    [self.asyncSocket connectToHost:adress onPort:port withTimeout:10 error:&error];
    if (error) {
        NSLog(@"连接失败:%@", error);
    } else {
        NSLog(@"连接成功");
    }
}

- (void)sendMessageWithData {
    if (self.sendMessageTimer) {
        [self.sendMessageTimer invalidate];
        self.sendMessageTimer = nil;
    }
    self.sendMessageTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(sendMessageWithData) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.sendMessageTimer forMode:NSRunLoopCommonModes];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"accountToken"] = [UserManager sharedManager].user.account_token;
    parameters[@"lat"] = [NSString stringWithFormat:@"%f",[LocationManager sharedManager].coordinate.latitude];
    parameters[@"lng"] = [NSString stringWithFormat:@"%f",[LocationManager sharedManager].coordinate.longitude];
    
    NSData *data = [Common dictionnaryObjectToString:parameters];
    [self.asyncSocket writeData:data withTimeout:-1 tag:300];
}

- (void)disconnectedSocket {
    self.reconnectionCount = -1;
    [self.asyncSocket disconnect];
}

- (void)socketDidDisconect {
    if (self.reconnectionCount >= 0 && self.reconnectionCount <= 3) {
        NSTimeInterval time = pow(2, self.reconnectionCount);
        if (!self.reconnectTimer) {
            self.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:time
                                                                   target:self
                                                                 selector:@selector(reconnection)
                                                                 userInfo:nil
                                                                  repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:self.reconnectTimer forMode:NSRunLoopCommonModes];
        }
        self.reconnectionCount++;
    } else {
        [self.reconnectTimer invalidate];
        self.reconnectTimer = nil;
        self.reconnectionCount = 0;
    }
}

- (void)reconnection {
    NSError *error;
    [self.asyncSocket connectToHost:self.host onPort:self.port withTimeout:10 error:&error];
    if (error) {
        NSLog(@"连接失败:%@", error);
    } else {
        NSLog(@"连接成功");
    }
}

//网络状态监听
- (void)startMonitoringNetwork {
    AFNetworkReachabilityManager *networkManager = [AFNetworkReachabilityManager sharedManager];
    [networkManager startMonitoring];
    __weak __typeof(&*self) weakSelf = self;
    [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                if (weakSelf.asyncSocket.isConnected) {
                    [self disconnectedSocket];
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                if (weakSelf.asyncSocket.isConnected) {
                    [self socketDidDisconect];
                }
                break;
            default:
                break;
        }
    }];
}
#pragma mark - GCDAsyncSocketDelegate Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"成功连接到服务器");
    self.reconnectionCount = 0;
    [self sendMessageWithData];
    [self.asyncSocket readDataWithTimeout:-1 tag:300];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    [self.sendMessageTimer invalidate];
    self.sendMessageTimer = nil;
    if (err) {
        NSLog(@"连接失败DidDisconnect %@", err);
        //停止发送数据
        //断线重连
        [self socketDidDisconect];
    } else {
        NSLog(@"正常断开连接");
    }
}

//读取消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    if (data != nil) {
        id  jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", [jsonData class]);
        NSLog(@"%@",result);
        [kNotificationCenter postNotificationName:kHelpSocketData object:data];
    }
    [self.asyncSocket readDataWithTimeout:-1 tag:300];
}
#pragma mark - Lazy Load
- (instancetype)init {
    if (self = [super init]) {
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}
@end
