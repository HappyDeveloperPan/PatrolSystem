//
//  InfoDetailViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/19.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "InfoDetailViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <GCDAsyncSocket.h>
#import "CustomAnnotation.h"
#import "RadialCircleAnnotationView.h"
#import "StaffAnnotationView.h"
#import "HelpModel.h"
#import "UnusualModel.h"
#import "FinishHelpView.h"
#import "HandleResultViewController.h"

@interface InfoDetailViewController ()<MAMapViewDelegate, GCDAsyncSocketDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAPointAnnotation *redAnnotation;
@property (nonatomic, strong) HelpModel *helpModel;
@property (nonatomic, strong) UnusualModel *unusualModel;
@property (nonatomic, strong) UIButton *resultBtn, *finishBtn;
@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic, strong) NSTimer *sendMessageTimer;    //心跳定时器
@property (nonatomic, strong) NSTimer *reconnectTimer;      //重连定时器
@property (nonatomic, assign) NSInteger reconnectionCount;  // 建连失败重连次数
@property (nonatomic, strong) FinishHelpView *finishHelpView;
@end

@implementation InfoDetailViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBg;
    [self mapView];
    
    [kNotificationCenter addObserver:self selector:@selector(helpSocketReturnData:) name:kHelpSocketData object:nil];
    
//    [self finishBtn];
    
    
//    [self detailInfomation];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self detailInfomation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[HelpSocketManager sharedSocket] disconnectedSocket];
}

#pragma mark - Method
//获取详细信息
- (void)detailInfomation {
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *url;
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    if (self.emergency_calling_id) {
        params[@"emergency_calling_id"] = [NSString stringWithFormat:@"%ld", (long)self.emergency_calling_id];
        url = kUrl_StaffHelpDetail;
    }
    if (self.nowLocationdId) {
        params[@"nowLocationdId"] = [NSString stringWithFormat:@"%d", self.nowLocationdId];
        url = kUrl_StaffUnusualDetail;
    }
    
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:url parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                //一键求助
                if (self.emergency_calling_id) {
                    self.helpModel = [HelpModel parse:jsonData[@"result"]];
                    [self.mapView removeAnnotations:self.mapView.annotations];
                    // 1.未处理 2.正在处理 3.处理完成 4.撤销 5.已过期
                    if (self.helpModel.emergencyCallingType.emergency_calling_type_id == 2 || self.helpModel.emergencyCallingType.emergency_calling_type_id == 3) {
                        //处理结果按钮
                        [self resultBtn];
                    }
                    if (self.helpModel.emergencyCallingType.emergency_calling_type_id == 2 && !self.isHelpStaff) {
                        //结束处理按钮
                        [self finishBtn];
                        //求助坐标点
                        
                        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.helpModel.emergencyCalling.lat, self.helpModel.emergencyCalling.lng);
                        self.redAnnotation = [MAPointAnnotation new];
                        self.redAnnotation.coordinate = coordinate;
                        //连接一键求助tcp
                        [[HelpSocketManager sharedSocket] connectServerWithAdress:socketAdress andPort:helpSocketPoet];
                    }else {
                        //显示求助坐标点
                        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.helpModel.emergencyCalling.lat, self.helpModel.emergencyCalling.lng);
                        [self showUserPoint:coordinate];
                    }
                }else {
                    //景点异常
                    self.unusualModel = [UnusualModel parse:jsonData[@"result"]];
                    //3.未处理 4.正在处理 5.已处理 6.已过期
                    if (self.unusualModel.nowLocationdIdState.nowLocationdId_state_id == 4 && !self.isHelpStaff) {
                        [self finishBtn];
                    }
                    if (self.unusualModel.nowLocationdIdState.nowLocationdId_state_id == 4 || self.unusualModel.nowLocationdIdState.nowLocationdId_state_id == 5) {
                        [self resultBtn];
                    }
                    /****************/
                    [self.mapView removeAnnotations:self.mapView.annotations];
                    NSMutableArray *annotationArr = [NSMutableArray new];
                    if (self.unusualModel.auxiliaryStaffs.count > 0 && self.unusualModel.nowLocationdIdState.nowLocationdId_state_id == 4) {
                        
                        for (StaffOnLineModel *staffModel in self.unusualModel.auxiliaryStaffs) {
                            if (staffModel.onLine) {
                                CustomAnnotation *annotation = [CustomAnnotation new];
                                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(staffModel.latLng.lat, staffModel.latLng.lng);
                                annotation.coordinate = coordinate;
                                annotation.staffModel = staffModel;
                                [annotationArr addObject:annotation];
                            }
                        }
                    }
                    MAPointAnnotation *annotation = [MAPointAnnotation new];
                    annotation.coordinate = CLLocationCoordinate2DMake(self.unusualModel.nowLocationds.lat, self.unusualModel.nowLocationds.lng);
                    [annotationArr addObject:annotation];
                    [self.mapView addAnnotations:annotationArr];
                    [self.mapView showAnnotations:annotationArr edgePadding:UIEdgeInsetsMake(200, 200, 200, 200) animated:YES];
                    /*******************/
                }
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }

    }];
}

//显示求助坐标点
- (void)showUserPoint:(CLLocationCoordinate2D)coordinate {
    MAPointAnnotation *redAnnotation = [MAPointAnnotation new];
    redAnnotation.coordinate = coordinate;
    [self.mapView addAnnotation:redAnnotation];
    [self.mapView setCenterCoordinate:coordinate animated:YES];
}

//查看处理结果
- (void)showHandleResult {
    HandleResultViewController *pushVc = [HandleResultViewController new];
    if (self.emergency_calling_id) {
        pushVc.infoType = HelpInfo;
        pushVc.helpModel = self.helpModel;
    }
    if (self.nowLocationdId) {
        pushVc.infoType = UnusualInfo;
        pushVc.unusualModel = self.unusualModel;
    }
    [self.navigationController pushViewController:pushVc animated:YES];
}

- (void)showFinishHelpView {
    [self.finishHelpView show];
}

//完成求助
- (void)finishStaffHelp:(NSString *)textStr {
    if (textStr.length == 0) {
        [kMainWindow showWarning:@"请填写报告"];
        return;
    }
    [kMainWindow showBusyHUD];
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *url;
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    if (self.emergency_calling_id) {
        params[@"summarize"] = textStr;
        url = kUrl_StaffHelpFinish;
    }
    if (self.nowLocationdId) {
        params[@"nowLocationdId"] = @(self.nowLocationdId);
        params[@"conclusion"] = textStr;
        url = kUrl_FinishUnusual;
    }
    
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:url parameters:params completionHanlder:^(id jsonData, NSError *error) {
        [kMainWindow hideBusyHUD];
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [kMainWindow showWarning:@"结束成功"];
                [self.finishHelpView close];
                [self.navigationController popViewControllerAnimated:YES];
                if (self.emergency_calling_id) {
                    [UserManager sharedManager].user.staff.seekHelp = NO;
                }
//                [[HelpSocketManager sharedSocket] disconnectedSocket];
            }else {
                [kMainWindow showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
    }];
}

//一键求助返回数据解析
- (void)helpSocketReturnData:(NSNotification *)notif {
    if (notif.object != nil) {
        dispatch_async_on_main_queue(^{
            id  jsonData = [NSJSONSerialization JSONObjectWithData:notif.object options:NSJSONReadingAllowFragments error:nil];
            //业务逻辑, 解析数据, 接受字段断开Tcp, 地图标注还原
            
            if (jsonData) {
                if ([jsonData[@"resultnumber"] intValue] == 200) {
                    [self.mapView removeAnnotations:self.mapView.annotations];
                    HelpModel *helpModel = [HelpModel parse:jsonData[@"result"]];
                    NSMutableArray *annotationArr = [NSMutableArray new];
                    for (StaffOnLineModel *staffModel in helpModel.helpStaffs) {
                        if (staffModel.onLine) {
                            CustomAnnotation *annotation = [CustomAnnotation new];
                            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(staffModel.latLng.lat, staffModel.latLng.lng);
                            annotation.coordinate = coordinate;
                            annotation.staffModel = staffModel;
                            [annotationArr addObject:annotation];
                        }
                    }
                    if (self.redAnnotation) {
                        [annotationArr addObject:self.redAnnotation];
                    }
                
                    [self.mapView addAnnotations:annotationArr];
                    [self.mapView showAnnotations:annotationArr edgePadding:UIEdgeInsetsMake(200, 200, 200, 200) animated:YES];
//                    [self.mapView setCenterCoordinate:coordinate animated:YES];
                }else {
                    [self.view showWarning:jsonData[@"cause"]];
                }
            }
        });
        
    }
}
#pragma mark - tcp连接
////连接tcp
//- (void)connectServer {
//    NSError *error;
//    [self.asyncSocket connectToHost:socketAdress onPort:helpSocketPort withTimeout:10 error:&error];
//    if (error) {
//        NSLog(@"连接失败:%@", error);
//    } else {
//        NSLog(@"连接成功");
//    }
//}
//
////给服务端发送数据
//- (void)sendMessageWithData {
//    if (self.sendMessageTimer) {
//        [self.sendMessageTimer invalidate];
//        self.sendMessageTimer = nil;
//    }
//    self.sendMessageTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(sendMessageWithData) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:self.sendMessageTimer forMode:NSRunLoopCommonModes];
//    NSMutableDictionary *parameters = [NSMutableDictionary new];
//    parameters[@"accountToken"] = [UserManager sharedManager].user.account_token;
////    parameters[@"ioSessionId"] = [NSString stringWithFormat:@"%ld",(long)self.helpModel.ioSessionId];
//    NSData *data = [Common dictionnaryObjectToString:parameters];
//    [self.asyncSocket writeData:data withTimeout:-1 tag:200];
//}
//
////正常断开tcp连接
//- (void)disconnectedSocket {
//    self.reconnectionCount = -1;
//    [self.asyncSocket disconnect];
//}
//
////断线重连
//- (void)socketDidDisconect {
//    if (self.reconnectionCount >= 0 && self.reconnectionCount <= 3) {
//        NSTimeInterval time = pow(2, self.reconnectionCount);
//        if (!self.reconnectTimer) {
//            self.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:time
//                                                                   target:self
//                                                                 selector:@selector(connectServer)
//                                                                 userInfo:nil
//                                                                  repeats:NO];
//            [[NSRunLoop mainRunLoop] addTimer:self.reconnectTimer forMode:NSRunLoopCommonModes];
//        }
//        self.reconnectionCount++;
//    } else {
//        [self.reconnectTimer invalidate];
//        self.reconnectTimer = nil;
//        self.reconnectionCount = 0;
//    }
//}
//
////处理tcp返回数据
//- (void)analyticSocketReturnData:(NSData *)data {
//    dispatch_async_on_main_queue(^{
//        id  jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        //业务逻辑, 解析数据
//        CoordinateModel *coorModel = [CoordinateModel parse:jsonData[@"result"][@"latLng"]];
//        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(coorModel.lat, coorModel.lng);        
//        self.annotation.coordinate = coor;
//        [self.mapView addAnnotation:self.annotation];
//        [self.mapView setCenterCoordinate:coor animated:YES];
//    });
//}
#pragma mark - MapView Delegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomAnnotation *customAnnotation = (CustomAnnotation*)annotation;
        static NSString *staffReuseIdentifier = @"staffReuseIdentifier";
        StaffAnnotationView *annotationView = (StaffAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:staffReuseIdentifier];
        if (annotationView == nil) {
            annotationView = [[StaffAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:staffReuseIdentifier];
            annotationView.canShowCallout = NO;
            annotationView.calloutOffset = CGPointMake(0, -5);
            annotationView.staffModel = customAnnotation.staffModel;
            annotationView.image = [UIImage imageNamed:@"Personnel"];
        }
        return annotationView;
    }
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIdentifier = @"pointReuseIdentifier";
        RadialCircleAnnotationView *annotationView = (RadialCircleAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
        if (annotationView == nil)
        {
            annotationView = [[RadialCircleAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIdentifier];
            annotationView.canShowCallout = NO;
            annotationView.calloutOffset = CGPointMake(0, -5);
            //设置弹出框数据
            //一键求助
            if (self.emergency_calling_id) {
                annotationView.helpModel = self.helpModel;
            }
            if (self.nowLocationdId) {
                annotationView.unusualModel = self.unusualModel;
            }

            //脉冲圈个数
            annotationView.pulseCount = 4;
            //单个脉冲圈动画时长
            annotationView.animationDuration = 7.0;
            //单个脉冲圈起始直径
            annotationView.baseDiameter = 4.0;
            //单个脉冲圈缩放比例
            annotationView.scale = 30.0;
            //单个脉冲圈fillColor
            annotationView.fillColor = KcolorRed;
            //单个脉冲圈strokeColor
            annotationView.strokeColor = KcolorRed;
            //标注点内圈原点颜色
            annotationView.fixedLayer.backgroundColor = kColorMain.CGColor;
            
            //更改设置后重新开始动画
            [annotationView startPulseAnimation];
        }
        return annotationView;
    }
    
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[RadialCircleAnnotationView class]]) {
        RadialCircleAnnotationView *cusView = (RadialCircleAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(-8, -8, -8, -8));
        
        if (!CGRectContainsRect(self.mapView.frame, frame))
        {
            /* Calculate the offset to make the callout view show up. */
            CGSize offset = [Common offsetToContainRect:frame inRect:self.mapView.frame];
            
            CGPoint theCenter = self.mapView.center;
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
            
            [self.mapView setCenterCoordinate:coordinate animated:YES];
        }
        
    }
}

#pragma mark - GCDAsyncSocket Delegate
//- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
//    NSLog(@"成功连接到服务器");
//    self.reconnectionCount = 0;
//    [self sendMessageWithData];
//    [self.asyncSocket readDataWithTimeout:-1 tag:200];
//}
//
//- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
//    [self.sendMessageTimer invalidate];
//    self.sendMessageTimer = nil;
//    if (err) {
//        NSLog(@"连接失败DidDisconnect %@", err);
//        //断线重连
//        [self socketDidDisconect];
//    } else {
//        NSLog(@"正常断开连接");
//    }
//}

//读取消息
//- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
//    if (data != nil) {
//        id  jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", [jsonData class]);
//        NSLog(@"%@",result);
//        NSLog(@"%@", [NSDate date]);
//        [self analyticSocketReturnData:data];
//    }
//    [self.asyncSocket readDataWithTimeout:-1 tag:200];
//}

#pragma mark - Lazy Load
- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        [_mapView setZoomLevel:16.1 animated:YES];
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

- (UIButton *)resultBtn {
    if (!_resultBtn) {
        _resultBtn = [[UIButton alloc] init];
        [self.view addSubview:_resultBtn];
        [_resultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        _resultBtn.backgroundColor = kColorMain;
        _resultBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _resultBtn.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
        [_resultBtn setTitle: @"处理\n结果" forState: UIControlStateNormal];
        [_resultBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _resultBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _resultBtn.layer.cornerRadius = 40;
        _resultBtn.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        _resultBtn.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _resultBtn.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _resultBtn.layer.shadowRadius = 2;//阴影半径，默认3
        [_resultBtn addTarget:self action:@selector(showHandleResult) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resultBtn;
}

- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [[UIButton alloc] init];
        [self.view addSubview:_finishBtn];
        [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-20);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kMainScreenWidth * 0.3, 40));
        }];
        [_finishBtn setTitle:@"完成求助" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        [_finishBtn setBackgroundColor:kColorMain];
        _finishBtn.layer.cornerRadius = 5;
        _finishBtn.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        _finishBtn.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _finishBtn.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _finishBtn.layer.shadowRadius = 2;//阴影半径，默认3
        [_finishBtn addTarget:self action:@selector(showFinishHelpView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}


- (HelpModel *)helpModel {
    if (!_helpModel) {
        _helpModel = [HelpModel new];
    }
    return _helpModel;
}

- (UnusualModel *)unusualModel {
    if (!_unusualModel) {
        _unusualModel = [UnusualModel new];
    }
    return _unusualModel;
}

- (GCDAsyncSocket *)asyncSocket {
    if (!_asyncSocket) {
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _asyncSocket;
}


- (FinishHelpView *)finishHelpView {
    if (!_finishHelpView) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        _finishHelpView = [[FinishHelpView alloc] initWithFrame:window.frame];
        __weak __typeof(self)weakSelf = self;
        [_finishHelpView setSubmitBtnBlock:^(NSString *textStr){
            [weakSelf finishStaffHelp:textStr];
        }];
    }
    return _finishHelpView;
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
