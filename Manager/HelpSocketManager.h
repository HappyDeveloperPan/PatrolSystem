//
//  HelpSocketManager.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/23.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>

@interface HelpSocketManager : NSObject<GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic, strong) NSTimer *sendMessageTimer;    //心跳定时器
@property (nonatomic, strong) NSTimer *reconnectTimer;      //重连定时器
@property (nonatomic, assign) NSInteger reconnectionCount;  // 建连失败重连次数
@property (nonatomic, strong) NSString *host;           // Socket连接的host地址
@property (nonatomic, assign) uint16_t port;            // Sokcet连接的port

+ (HelpSocketManager *)sharedSocket;

//连接服务器
- (void)connectServerWithAdress:(NSString *)adress andPort:(uint16_t)port;
//发送信息
- (void)sendMessageWithData;
//断开连接
- (void)disconnectedSocket;
@end
