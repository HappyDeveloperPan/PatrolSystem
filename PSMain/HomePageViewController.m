//
//  HomePageViewController.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/10.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "HomePageViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "JPUSHService.h"
#import "AddView.h"
#import "ClockInView.h"
#import "BoatReportView.h"
#import "SecurityReportView.h"
#import "KGPickerView.h"
#import "ShuttleBusModel.h"
#import "PleasureBoatModel.h"
#import "PleasureBoatLineModel.h"
#import "SecuritySocketModel.h"
#import "HelpModel.h"
#import "SocketManager.h"
#import "SubmitReportView.h"
#import "AJPhotoBrowserViewController.h"
#import "AJPhotoPickerViewController.h"
#import "NotifCenterViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PageViewController.h"

@interface HomePageViewController ()<AMapLocationManagerDelegate, MAMapViewDelegate, KGPickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, AJPhotoPickerProtocol,AJPhotoBrowserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *startTaskBtn, *gpsBtn, *lineBtn, *taskBtn, *submitBtn, *helpBtn;
@property (nonatomic, strong) UIBarButtonItem *notifItem;
@property (nonatomic, strong) UILabel *badgeLab;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) NSMutableArray *menuArr, *pickArr, *lineIdArr, *BusBoatArr, *imgArr;
@property (nonatomic, retain) MAMapView *mapView;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (nonatomic, strong) AddView *addView;
@property (nonatomic, strong) ClockInView *clockInView;
@property (nonatomic, strong) SubmitReportView *submitReportView, *helpReportView;
@property (nonatomic, strong) BoatReportView *boatReportView, *bringBoatReportView;
@property (nonatomic, strong) SecurityReportView *securityReportView;
@property (nonatomic, strong) LineModel *lineModel;
@property (nonatomic, strong) MAUserLocationRepresentation *userLocationAnn;
@property (nonatomic, strong) SecuritySocketModel *socketModel;
@property (nonatomic, strong) MAMultiPolyline *polyLine;
@property (nonatomic, strong) MAPolygon *polygon;
@property (nonatomic, assign) CLLocationCoordinate2D *runningCoords;
@property (nonatomic, copy) NSString *lineId, *busBoatId;
@property (nonatomic, assign) BOOL isHandle;//一键求助是否开启
@end

@implementation HomePageViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorWhite;
    self.navigationItem.rightBarButtonItem = self.notifItem;
    
    [AMapServices sharedServices].enableHTTPS = YES;
    [self mapView];
    [self showStaffInformationView];
    
    [self getSelectedTask];
    
    [kNotificationCenter addObserver:self selector:@selector(getSelectedTask) name:kReloadInfo object:nil];
    [kNotificationCenter addObserver:self selector:@selector(socketReturnData:) name:kSocketData object:nil];
//    [kNotificationCenter addObserver:self selector:@selector(helpSocketReturnData:) name:kHelpSocketData object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //设置通知角标
    [Common layoutBadge:self.badgeLab andCount:[UIApplication sharedApplication].applicationIconBadgeNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method
//根据工种加载视图
- (void)showStaffInformationView {
    [self startTaskBtn];
    [self gpsBtn];
    [self menuView];
    [self helpBtn];
    if (self.workType != 3) {
        [self submitBtn];
    }
    if (self.workType == 4) {
        [self startTaskBtn];
    }
}

//系统通知
- (void)notiCenter {
//    NotifCenterViewController *notiVc = [[NotifCenterViewController alloc] init];
//    notiVc.hidesBottomBarWhenPushed = YES;
//    notiVc.notiNumber = [[UIApplication sharedApplication]applicationIconBadgeNumber];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    [JPUSHService resetBadge];
//    [self.navigationController pushViewController:notiVc animated:YES];
    
    if (![[UserManager sharedManager] isLogin]) {
        [kNotificationCenter postNotificationName:kNotifPresentLogin object:nil];
    }
    PageViewController *pushVc = [[PageViewController alloc] init];
    pushVc.hidesBottomBarWhenPushed = YES;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
    [self.navigationController pushViewController:pushVc animated:YES];
}



//获取当天已选任务(备忘录有数据格式)
- (void)getSelectedTask {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_GetStaffTask parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                if (self.workType == 1) {
                    [UserManager sharedManager].securityModel = [SecurityModel parse:jsonData[@"result"]];
                }
                if (self.workType == 2) {
                    [UserManager sharedManager].cleaningModel = [CleaningModel parse:jsonData[@"result"]];
                }
                if (self.workType == 3) {
                    [UserManager sharedManager].shuttleBusTaskModel = [ShuttleBusTaskModel parse:jsonData[@"result"]];
                }
                if (self.workType == 4) {
                    [UserManager sharedManager].cruiseModel = [CruiseModel parse:jsonData[@"result"]];
                }
            }else {
//                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
        
    }];
}

//定位自己
- (void)gpsAction {
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [self.gpsBtn setSelected:YES];
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    }
}

//跟新任务状态
- (void)reloadStaffState {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_StaffState parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                StaffModel *staffModel = [StaffModel parse:jsonData[@"result"]];
                [UserManager sharedManager].user.staff.sign_in = staffModel.sign_in;
                [UserManager sharedManager].user.staff.task = staffModel.task;
                [UserManager sharedManager].user.staff.workTools = staffModel.workTools;
//                [UserManager sharedManager].user.staff.seekHelp = staffModel.seekHelp;
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }

    }];
}
#pragma mark -一键求助
//一键求助按钮功能
- (void)oneKeyForHelp {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"一键求助" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *selectOne = [UIAlertAction actionWithTitle:@"紧急求助" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UserManager sharedManager].user.staff.seekHelp) {
            [kMainWindow showWarning:@"已经开启求助,请勿重复点击"];
            return;
        }
        //开启一键求助
        self.helpReportView.myTextView.text = @"";
        self.helpReportView.center = self.addView.center;
        [self.addView addSubview:self.helpReportView];
        [self.addView show];
    }];
    UIAlertAction *selectTwo = [UIAlertAction actionWithTitle:@"拨打后台管理电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:selectOne];
    [alertController addAction:selectTwo];
    [alertController addAction:cancel];
    alertController.view.layer.cornerRadius = 6;
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark -开始任务
//开始任务
- (void)startTask {
    if (self.workType == 4) {
        if (![UserManager sharedManager].user.staff.workTools) {
            [kMainWindow showWarning:@"请先绑定游船"];
            return;
        }
        if ([UserManager sharedManager].user.staff.task) {
            [kMainWindow showWarning:@"任务已经开始,请先完成任务"];
            return;
        }
        self.boatReportView.center = self.addView.center;
        [self.addView addSubview:self.boatReportView];
        [self.addView show];
    }
    else {
        if (![UserManager sharedManager].user.staff.task) {
            [kMainWindow showWarning:@"请先选择任务"];
            return;
        }
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
        parameters[@"lat"] = [NSString stringWithFormat:@"%f", [LocationManager sharedManager].coordinate.latitude];
        parameters[@"lng"] = [NSString stringWithFormat:@"%f", [LocationManager sharedManager].coordinate.longitude];
        [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_StartTask parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
            if (jsonData) {
                if ([jsonData[@"resultnumber"] intValue] == 200) {
                    [kMainWindow showWarning:@"任务开始"];
                }else {
                    [self.view showWarning:jsonData[@"cause"]];
                }
            } else {
                [self.view showWarning:error.domain];
            }
            
        }];
    }
}

#pragma mark -显示任务路线与范围
//显示任务路线
- (void)showLine {
    if (![UserManager sharedManager].user.staff.task) {
        [kMainWindow showWarning:@"请先选择任务"];
        return;
    }
    if (self.lineBtn.selected) {
        [self.lineBtn setSelected:NO];
        if (self.workType == 2) {
            [self.mapView removeOverlay:self.polygon];
        }else {
            [self.mapView removeOverlay:self.polyLine];
        }
        
    }else {
        [self.lineBtn setSelected:YES];
        //显示路线
        if (self.workType == 1) {
            //    _speedColors = [NSMutableArray array];
            NSMutableArray * indexes = [NSMutableArray array];
            NSInteger count = 0;
            if ([UserManager sharedManager].securityModel.theSecurityLine.the_security_line.count > 0)
            {
                count = [UserManager sharedManager].securityModel.theSecurityLine.the_security_line.count;
                self.runningCoords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
                
                for (int i = 0; i < count; i++)
                {
                    @autoreleasepool
                    {
                        CoordinateModel *coor = [UserManager sharedManager].securityModel.theSecurityLine.the_security_line[i];
                        self.runningCoords[i].latitude = coor.lat;
                        self.runningCoords[i].longitude = coor.lng;
                        
                        //                    UIColor * speedColor = [self getColorForSpeed:[data[@"speed"] floatValue]];
                        //                    [_speedColors addObject:speedColor];
                        
                        [indexes addObject:@(i)];
                    }
                }
            }
            
            self.polyLine = [MAMultiPolyline polylineWithCoordinates:self.runningCoords count:count drawStyleIndexes:indexes];
            [self.mapView addOverlay:self.polyLine];
            
        }
        //显示范围
        if (self.workType == 2) {
            NSInteger count = 0;
            if ([UserManager sharedManager].cleaningModel.cleaningAreaLatlngs.count > 0)
            {
                count = [UserManager sharedManager].cleaningModel.cleaningAreaLatlngs.count;
                self.runningCoords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
                
                for (int i = 0; i < count; i++)
                {
                    @autoreleasepool
                    {
                        CoordinateModel *coor = [UserManager sharedManager].cleaningModel.cleaningAreaLatlngs[i];
                        self.runningCoords[i].latitude = coor.lat;
                        self.runningCoords[i].longitude = coor.lng;
                        
                    }
                }
            }
            self.polygon = [MAPolygon polygonWithCoordinates:self.runningCoords count:count];
            [self.mapView addOverlay:self.polygon];
        }
        if (self.workType == 3) {
            NSMutableArray * indexes = [NSMutableArray array];
            NSInteger count = 0;
            if ([UserManager sharedManager].shuttleBusTaskModel.ferryPushLineLatlngs.count > 0)
            {
                count = [UserManager sharedManager].shuttleBusTaskModel.ferryPushLineLatlngs.count;
                self.runningCoords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
                
                for (int i = 0; i < count; i++)
                {
                    @autoreleasepool
                    {
                        CoordinateModel *coor = [UserManager sharedManager].shuttleBusTaskModel.ferryPushLineLatlngs[i];
                        self.runningCoords[i].latitude = coor.lat;
                        self.runningCoords[i].longitude = coor.lng;
                        
                        [indexes addObject:@(i)];
                    }
                }
            }
            
            self.polyLine = [MAMultiPolyline polylineWithCoordinates:self.runningCoords count:count drawStyleIndexes:indexes];
            [self.mapView addOverlay:self.polyLine];
            
        }
        if (self.workType == 4) {
            NSMutableArray * indexes = [NSMutableArray array];
            NSInteger count = 0;
            if ([UserManager sharedManager].cruiseModel.cruiseLine.cruise_line.count > 0)
            {
                count = [UserManager sharedManager].cruiseModel.cruiseLine.cruise_line.count;
                self.runningCoords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
                
                for (int i = 0; i < count; i++)
                {
                    @autoreleasepool
                    {
                        CoordinateModel *coor = [UserManager sharedManager].cruiseModel.cruiseLine.cruise_line[i];
                        self.runningCoords[i].latitude = coor.lat;
                        self.runningCoords[i].longitude = coor.lng;
                        
                        [indexes addObject:@(i)];
                    }
                }
            }
            
            self.polyLine = [MAMultiPolyline polylineWithCoordinates:self.runningCoords count:count drawStyleIndexes:indexes];
            [self.mapView addOverlay:self.polyLine];
        }
    }
}

#pragma mark -Socket通信
//解析socket通讯返回数据
- (void)socketReturnData:(NSNotification *)notif {
    if (notif.object != nil) {
        dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_sync(concurrentQueue, ^(){
            if (self.workType == 1) {
                id  jsonData = [NSJSONSerialization JSONObjectWithData:notif.object options:NSJSONReadingAllowFragments error:nil];
                SecuritySocketModel *socketModel = [SecuritySocketModel parse:jsonData[@"result"]];
                if ((!self.securityReportView.isShow) && socketModel.isAccomplish) {
                    //显示提交任务界面
                    self.securityReportView.isShow = YES;
                    self.securityReportView.top = 100;
                    [self.addView addSubview:self.securityReportView];
                    [self.addView show];
                }
                if (!socketModel.isAccomplish) {
                    self.securityReportView.isShow = NO;
                }
                if (socketModel.isComplete) {
                    //任务完成, 断开TCP
                    //                    [[SocketManager sharedSocket] disconnectedSocket];
                    NSMutableDictionary *params = [NSMutableDictionary new];
                    params[@"account_token"] = [UserManager sharedManager].user.account_token;
                    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_SureComplete parameters:params completionHanlder:^(id jsonData, NSError *error) {
                        if (jsonData) {
                            if ([jsonData[@"resultnumber"] intValue] == 200) {
                                [self reloadStaffState];
                                //                                [UserManager sharedManager].user.staff.task = NO;
                            }else {
                                [self.view showWarning:jsonData[@"cause"]];
                            }
                        } else {
                            [self.view showWarning:error.domain];
                        }
                        
                    }];
                }
                //                [kMainWindow showWarning:[NSString stringWithFormat:@"是否上传任务%d",self.socketModel.isUpload]];
                //                NSLog(@"是否上传任务: %d",self.socketModel.isUpload);
            }
        });
//        dispatch_async_on_main_queue(^{
//            if (self.workType == 1) {
//                id  jsonData = [NSJSONSerialization JSONObjectWithData:notif.object options:NSJSONReadingAllowFragments error:nil];
//                SecuritySocketModel *socketModel = [SecuritySocketModel parse:jsonData[@"result"]];
//                if ((!self.securityReportView.isShow) && socketModel.isAccomplish) {
//                    //显示提交任务界面
//                    self.securityReportView.isShow = YES;
//                    self.securityReportView.top = 100;
//                    [self.addView addSubview:self.securityReportView];
//                    [self.addView show];
//                }
//                if (!socketModel.isAccomplish) {
//                    self.securityReportView.isShow = NO;
//                }
//                if (socketModel.isComplete) {
//                    //任务完成, 断开TCP
////                    [[SocketManager sharedSocket] disconnectedSocket];
//                    NSMutableDictionary *params = [NSMutableDictionary new];
//                    params[@"account_token"] = [UserManager sharedManager].user.account_token;
//                    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_SureComplete parameters:params completionHanlder:^(id jsonData, NSError *error) {
//                        if (jsonData) {
//                            if ([jsonData[@"resultnumber"] intValue] == 200) {
//                                [self reloadStaffState];
////                                [UserManager sharedManager].user.staff.task = NO;
//                            }else {
//                                [self.view showWarning:jsonData[@"cause"]];
//                            }
//                        } else {
//                            [self.view showWarning:error.domain];
//                        }
//
//                    }];
//                }
////                [kMainWindow showWarning:[NSString stringWithFormat:@"是否上传任务%d",self.socketModel.isUpload]];
////                NSLog(@"是否上传任务: %d",self.socketModel.isUpload);
//            }
//        });
    }
}

//- (void)helpSocketReturnData:(NSNotification *)notif {
//    if (notif.object != nil) {
//        dispatch_async_on_main_queue(^{
//            id  jsonData = [NSJSONSerialization JSONObjectWithData:notif.object options:NSJSONReadingAllowFragments error:nil];
//            //业务逻辑, 解析数据, 接受字段断开Tcp, 地图标注还原
//            HelpModel *helpModel = [HelpModel parse:jsonData[@"result"]];
//            if (helpModel.isHandle && !self.isHandle) {
//                //根据后台响应做出相应的操作
//                self.isHandle = YES;
//                [kMainWindow showWarning:@"一键求助开启成功"];
//                self.userLocationAnn.image = [UIImage animatedImageNamed:@"animatedCar_" duration:0.5];
//                [self.mapView updateUserLocationRepresentation:self.userLocationAnn];
//            }
//            if (helpModel.isComplete) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"一键求助处理完成" message:@"处理完成" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//                [alertView show];
//                self.isHandle = NO;
//                [[HelpSocketManager sharedSocket] disconnectedSocket];
//                self.userLocationAnn.image = [UIImage imageNamed:@"userPoint"];
//                [self.mapView updateUserLocationRepresentation:self.userLocationAnn];
//            }
//        });
//    }
//}

#pragma mark -选择任务部分
//显示选择任务界面
- (void)showTaskView {
    if (![UserManager sharedManager].isLogin) {
        [kMainWindow showWarning:@"未登录成功"];
        return;
    }
    if ([UserManager sharedManager].user.staff.workTools) {
        if (self.workType == 3) {
            [kMainWindow showWarning:@"已经绑定摆渡车"];
        }
        if (self.workType == 4) {
            [kMainWindow showWarning:@"已经绑定游船"];
        }
        return;
    }
    if (![UserManager sharedManager].user.staff.task) {
        self.clockInView.center = self.addView.center;
        [self.addView addSubview:self.clockInView];
        [self.addView show];
    } else {
        [kMainWindow showWarning:@"已经选择过任务,请先完成"];
        return;
    }
}
//摆渡车人员获取车辆信息
- (void)getAllShuttleBus {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if ([UserManager sharedManager].isLogin) {
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
        NSString *url;
        if (self.workType == 3) {
            url = kUrl_GetAllFerryBus;
        }
        if (self.workType == 4) {
            url = kUrl_getBoatLine;
        }
        [RXApiServiceEngine requestWithType:RequestMethodTypePost url:url parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
            if (jsonData) {
                if ([jsonData[@"resultnumber"] intValue] == 200) {
                    NSMutableArray *pickArr = [NSMutableArray new];
                    for (id model in jsonData[@"result"]) {
                        if (self.workType == 3) {
                            ShuttleBusModel *busModle = [ShuttleBusModel parse:model];
                            [pickArr addObject:busModle.ferry_push];
                            [self.BusBoatArr addObject:busModle.ferry_push_id];
                        }
                        if (self.workType == 4) {
                            PleasureBoatLineModel *boatModel = [PleasureBoatLineModel parse:model];
                            [pickArr addObject:boatModel.cruise_line_name];
                            [self.BusBoatArr addObject:boatModel.cruise_line_id];
                        }
                        
                    }
                    KGPickerViewStyle style;
                    if (self.workType == 3) {
                        style = KGPickerViewStyleBus;
                    }else {
                        style = KGPickerViewStyleBoat;
                    }
                    KGPickerView *pickView = [[KGPickerView alloc] initWithTitle:@"请选择任务" andContent:pickArr andDelegate:self andStyle:style];
                    [pickView showInView:self.view];
                }else {
                    [self.view showWarning:jsonData[@"cause"]];
                }
            } else {
                [self.view showWarning:error.domain];
            }

        }];
    }
}

//获取所有任务
- (void)getAllTask {
    if ([UserManager sharedManager].isLogin) {
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
        NSString *url;
        if (self.workType == 1) {
            url = kUrl_QuerySecurityLine;
        }
        if (self.workType == 2) {
            url = kUrl_QueryCleaningArea;
        }
        if (self.workType == 3) {
            url = kUrl_GetAllFerryLine;
        }
        if (self.workType == 4) {
            url = kUrl_GetAllBoat;
        }
        [RXApiServiceEngine requestWithType:RequestMethodTypePost url:url parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
            if (jsonData) {
                if ([jsonData[@"resultnumber"] intValue] == 200) {
                    [self.pickArr removeAllObjects];
                    [self.lineIdArr removeAllObjects];
                    for (id  model in jsonData[@"result"]) {
                        //安保
                        if (self.workType == 1) {
                            self.lineModel = [LineModel parse:model];
                            [self.pickArr addObject:self.lineModel.the_security_line_name];
                            [self.lineIdArr addObject:self.lineModel.the_security_line_id];
                        }
                        //保洁
                        if (self.workType == 2) {
                            CleaningAreaModel *clea = [CleaningAreaModel parse:model];
                            [self.pickArr addObject:clea.cleaningArea.cleaning_area_name];
////                            [self.lineIdArr addObject:clea.cleaningArea.cleaning_area_id];
                            [self.lineIdArr addObject:[NSNumber numberWithInteger:clea.cleaningArea.cleaning_area_id]];
//                            [self.pickArr addObject:clea.cleaning_area_name];
//                            [self.lineIdArr addObject:[NSNumber numberWithInteger:clea.cleaning_area_id]];
                        }
                        //摆渡车
                        if (self.workType == 3) {
                            ShuttleBusLineModel *lineModel = [ShuttleBusLineModel parse:model];
                            [self.pickArr addObject:lineModel.feeryPushLine.ferry_push_line_name];
                            [self.lineIdArr addObject:[NSNumber numberWithInt:lineModel.feeryPushLine.ferry_push_line_id]];
                        }
                        //游船
                        if (self.workType == 4) {
                            PleasureBoatModel *boatModel = [PleasureBoatModel parse:model];
                            [self.pickArr addObject:boatModel.pleasure_boat];
                            [self.lineIdArr addObject:boatModel.pleasure_boat_id];
                        }
                    }
                    KGPickerView *pickView = [[KGPickerView alloc] initWithTitle:@"请选择任务" andContent:self.pickArr andDelegate:self];
                    [pickView showInView:self.view];
                }else {
                    [self.view showWarning:jsonData[@"cause"]];
                }
            } else {
                [self.view showWarning:error.domain];
            }
            
        }];
//        if (self.pickArr.count == 0) {
//
//        }else {
//            KGPickerView *pickView = [[KGPickerView alloc] initWithTitle:@"请选择任务" andContent:self.pickArr andDelegate:self];
//            [pickView showInView:self.view];
//        }
    }
}

//提交选择任务
- (void)submitTask {
    if (self.clockInView.taskLab.text.length == 0) {
        [kMainWindow showWarning:@"请选择任务"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    NSString *url;
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    if (self.workType == 1) {
        parameters[@"the_security_line_id"] = self.lineId;
        url = kUrl_PatrolRecord;
    }
    if (self.workType == 2) {
        url = kUrl_SaveCleaningArea;
        parameters[@"cleaning_area_id"] = self.lineId;
    }
    if (self.workType == 3) {
        url = kUrl_SubFerryPushRecord;
        parameters[@"ferry_push_id"] = self.busBoatId;
        parameters[@"ferry_push_line_id"] = self.lineId;
    }
    if (self.workType == 4) {
        url = kUrl_SaveBoat;
        parameters[@"pleasure_boat_id"] = self.lineId;
    }
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:url parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.clockInView removeFromSuperview];
                [self.addView close];
                [self.view showWarning:@"提交任务成功"];
                [self getSelectedTask];
                if (self.workType == 4) {
                    [UserManager sharedManager].user.staff.workTools = YES;
                }else {
                    [UserManager sharedManager].user.staff.task = YES;
                }
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
        [self.clockInView removeFromSuperview];
        [self.addView close];
    }];
}

#pragma mark -提交任务部分
//提交工作报告
- (void)showSubmitReportView {
    if (self.workType == 4) {
        if (![UserManager sharedManager].user.staff.task) {
            [kMainWindow showWarning:@"请先开始航行"];
            return;
        }
        self.bringBoatReportView.center = self.addView.center;
        [self.addView addSubview:self.bringBoatReportView];
        [self.addView show];
    }else if(self.workType == 1) {
        if (![UserManager sharedManager].user.staff.task) {
            [kMainWindow showWarning:@"请先选择任务"];
            return;
        }
//        if (![SocketManager sharedSocket].asyncSocket.isConnected) {
//            [kMainWindow showWarning:@"请先开始任务"];
//            return;
//        }
        self.securityReportView.myTextView.text = @"";
//        self.securityReportView.center = self.addView.center;
        self.securityReportView.top = 100;
        [self.addView addSubview:self.securityReportView];
        [self.addView show];
    }else {
        if (![UserManager sharedManager].user.staff.task) {
            [kMainWindow showWarning:@"请先选择任务"];
            return;
        }
//        if (![SocketManager sharedSocket].asyncSocket.isConnected) {
//            [kMainWindow showWarning:@"请先开始任务"];
//            return;
//        }
        self.submitReportView.myTextView.text = @"";
        self.submitReportView.center = self.addView.center;
        [self.addView addSubview:self.submitReportView];
        [self.addView show];
    }
}

- (void)deletePic: (UIButton *)sender {
    if (![UserManager sharedManager].isAddImg) {
        [UserManager sharedManager].isAddImg = YES;
        UIImage *image = [UIImage imageNamed:@"add_pic"];
        [self.imgArr addObject:image];
    }
    [self.imgArr removeObjectAtIndex:sender.tag];
    [self.submitReportView.collectionView reloadData];
    [self.helpReportView.collectionView reloadData];
    [self.securityReportView.collectionView reloadData];
    //    NSLog(@"删除图片");
}

//提交报告
- (void)submitReport {
    if (self.imgArr.count == 1) {
        [kMainWindow showWarning:@"请选择图片"];
        return;
    }
    if ([UserManager sharedManager].isAddImg) {
        [self.imgArr removeLastObject];
    }
    [kMainWindow showBusyHUD];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    NSString *url;
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    parameters[@"lat"] = [NSString stringWithFormat:@"%f", [LocationManager sharedManager].coordinate.latitude];
    parameters[@"lng"] = [NSString stringWithFormat:@"%f", [LocationManager sharedManager].coordinate.longitude];
    if (self.workType == 1) {
        if (self.submitReportView.normalSW.isOn) {
            parameters[@"state"] = @"true";
        }else {
            parameters[@"state"] = @"false";
        }
        //    parameters[@"state"] = [NSNumber numberWithBool:self.submitReportView.normalSW.isOn];
        parameters[@"report"] = self.submitReportView.myTextView.text;
        url = kUrl_SubmitPatrolRecord;
    }
    if (self.workType == 2) {
        parameters[@"report"] = self.submitReportView.myTextView.text;
        url = kUrl_SubmitCleaningRecords;
    }
    
    [RXApiServiceEngine uploadImagesWithUrl:url andImages:self.imgArr andParameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        [kMainWindow hideBusyHUD];
        [self.imgArr removeAllObjects];
        UIImage *image = [UIImage imageNamed:@"add_pic"];
        [self.imgArr addObject:image];
        [UserManager sharedManager].isAddImg = YES;
        [self.submitReportView.collectionView reloadData];
        
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                if (self.workType != 1) {
//                    [[SocketManager sharedSocket] disconnectedSocket];
                }
                if (self.workType == 2) {
                    [UserManager sharedManager].user.staff.task = NO;
                }
                [self.view showWarning:@"上传成功"];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
        self.submitReportView.isShow = NO;
        [self.submitReportView removeFromSuperview];
        [self.addView close];
    }];
}

//安保人员提交工作报告
- (void)securitySubmitReport {
    
    if (self.securityReportView.state == 20) {
        if (self.securityReportView.myTextView.text.length == 0) {
            [kMainWindow showWarning:@"请填写异常报告"];
            return;
        }
        if (self.imgArr.count == 1) {
            [kMainWindow showWarning:@"请选择图片"];
            return;
        }
    }
    if ([UserManager sharedManager].isAddImg) {
        [self.imgArr removeLastObject];
    }
    [kMainWindow showBusyHUD];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    parameters[@"lat"] = [NSString stringWithFormat:@"%f", [LocationManager sharedManager].coordinate.latitude];
    parameters[@"lng"] = [NSString stringWithFormat:@"%f", [LocationManager sharedManager].coordinate.longitude];
    parameters[@"report"] = self.securityReportView.myTextView.text;
    if (self.securityReportView.state == 10) {
        parameters[@"state"] = @"true";
    }else {
        parameters[@"state"] = @"false";
    }
    
    [RXApiServiceEngine uploadImagesWithUrl:kUrl_SubmitPatrolRecord andImages:self.imgArr andParameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        [kMainWindow hideBusyHUD];
        [self.imgArr removeAllObjects];
        UIImage *image = [UIImage imageNamed:@"add_pic"];
        [self.imgArr addObject:image];
        [UserManager sharedManager].isAddImg = YES;
        [self.securityReportView.collectionView reloadData];
        
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.view showWarning:@"上传成功"];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
        
        [self.securityReportView removeFromSuperview];
        [self.addView close];
    }];
}

//提交游船报告
-(void)submitBoatReportWithState:(NSInteger)state {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    NSString *url;
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    parameters[@"lat"] = [NSString stringWithFormat:@"%f", [LocationManager sharedManager].coordinate.latitude];
    parameters[@"lng"] = [NSString stringWithFormat:@"%f", [LocationManager sharedManager].coordinate.longitude];
    if (state == 1) {
        //开船
        url = kUrl_StartBoatRecord;
        parameters[@"boarding_number"] = self.boatReportView.textField.text;
        parameters[@"cruise_line_id"] = self.busBoatId;
    }else {
        //停船
        url = kUrl_EndBoatRecord;
        parameters[@"disembarkation_number"] = self.bringBoatReportView.textField.text;
    }
    
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:url parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                if (state == 1) {
                    //开船成功要连接TCP;
                    [kMainWindow showWarning:@"开始航行"];
                    [self getSelectedTask];
//                    [[SocketManager sharedSocket] connectServerWithAdress:socketAdress andPort:socketPort];
                    [UserManager sharedManager].user.staff.task = YES;
                }else {
                    //安全到岸断开TCP
//                    [[SocketManager sharedSocket] disconnectedSocket];
                    [UserManager sharedManager].user.staff.task = NO;
                }
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
        if (state == 1) {
            [self.boatReportView removeFromSuperview];
            [self.addView close];
        }else {
            [self.bringBoatReportView removeFromSuperview];
            [self.addView close];
        }

    }];
}

//提交一键求助报告
- (void)submitHelpReport {
    if ([UserManager sharedManager].isAddImg) {
        [self.imgArr removeLastObject];
    }
    [kMainWindow showBusyHUD];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    parameters[@"origin"] = self.helpReportView.myTextView.text;
    parameters[@"lat"] = [NSString stringWithFormat:@"%f",[LocationManager sharedManager].coordinate.latitude];
    parameters[@"lng"] = [NSString stringWithFormat:@"%f",[LocationManager sharedManager].coordinate.longitude];
    
    [RXApiServiceEngine uploadImagesWithUrl:kUrl_OneKeyHelp andImages:self.imgArr andParameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        [kMainWindow hideBusyHUD];
        [self.imgArr removeAllObjects];
        UIImage *image = [UIImage imageNamed:@"add_pic"];
        [self.imgArr addObject:image];
        [UserManager sharedManager].isAddImg = YES;
        [self.helpReportView.collectionView reloadData];
        
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [kMainWindow showWarning:@"成功开启一键求助"];
                [UserManager sharedManager].user.staff.seekHelp = YES;
                //开启一键求助
//                [[HelpSocketManager sharedSocket] connectServerWithAdress:socketAdress andPort:helpSocketPoet];
                
//                pre.image = [UIImage imageNamed:@"userPosition"];
//                self.userLocationAnn.image = [UIImage animatedImageNamed:@"animatedCar_" duration:0.5];
//                [self.mapView updateUserLocationRepresentation:self.userLocationAnn];
                
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
        
        [self.helpReportView removeFromSuperview];
        [self.addView close];
    }];
    
}
#pragma mark - KGPicker Delegate

- (void)confirmChoose:(NSString *)string andIndex:(NSInteger)index andStyle:(KGPickerViewStyle)style{
    
//    if (self.workType == 1) {
//        self.lineId = self.lineIdArr[index];
//    }
    
    if (style == KGPickerViewStyleBus) {
        self.clockInView.taskLab1.text = string;
        self.busBoatId = self.BusBoatArr[index];
    }else if (style == KGPickerViewStyleBoat) {
        self.boatReportView.taskLab.text = string;
        self.busBoatId = self.BusBoatArr[index];
    }else {
        self.clockInView.taskLab.text = string;
        self.lineId = self.lineIdArr[index];
    }
}

#pragma mark - mapview delegate
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
//        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
//        pre.image = [UIImage imageNamed:@"userPoint"];
//        pre.lineWidth = 3;
//        
//        
//        [self.mapView updateUserLocationRepresentation:pre];
        
        self.userLocationAnn.lineWidth = 3;
        [self.mapView updateUserLocationRepresentation:self.userLocationAnn];
        
        view.calloutOffset = CGPointMake(0, 0);
        view.canShowCallout = NO;
        
        
        view.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        view.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        view.layer.shadowRadius = 2;//阴影半径，默认3
        view.layer.rasterizationScale = [[UIScreen mainScreen] scale];//光栅化处理
        self.userLocationAnnotationView = view;
    }
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && self.userLocationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
            
        }];
    }
    
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if (overlay == self.polyLine)
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 8.f;
        //        polylineRenderer.strokeColors = _speedColors;
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonRenderer *polygonRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
        polygonRenderer.lineWidth   = 4.f;
        polygonRenderer.strokeColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
        polygonRenderer.fillColor   = [UIColor redColor];
        
        return polygonRenderer;
    }
    return nil;
}
//选择图片
#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    cell.imageView.image  = self.imgArr[indexPath.row];
    [cell.contentView addSubview:cell.imageView];
    if ((indexPath.row != self.imgArr.count - 1 && [UserManager sharedManager].isAddImg) || ![UserManager sharedManager].isAddImg) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(cell.contentView.width - 20, 0, 20, 20)];
        [button setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
        [cell.contentView addSubview:button];
        button.tag = indexPath.row;
        [button addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.imgArr.count -1 && [UserManager sharedManager].isAddImg) {
        [self.addView close];
        //选择图片逻辑
        AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
        picker.maximumNumberOfSelection = 3;
        picker.multipleSelection = YES;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups = YES;
        picker.delegate=self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return YES;
        }];
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - AJPhotoPickerProtocol Delegate
- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.addView show];
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    
    if ((self.imgArr.count + assets.count - 1) > 3) {
        [kMainWindow showWarning:@"不能超过3张图片"];
        return;
    }
    for (int i = 0; i < assets.count; i ++ ) {
        ALAsset *asset = assets[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [self.imgArr insertObject:tempImg atIndex:0];
    }
    if (self.imgArr.count > 3) {
        [UserManager sharedManager].isAddImg = NO;
        [self.imgArr removeLastObject];
    }
    [self.submitReportView.collectionView reloadData];
    [self.securityReportView.collectionView reloadData];
    [self.helpReportView.collectionView reloadData];
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self.addView show];
    
    //显示预览
    //    AJPhotoBrowserViewController *photoBrowserViewController = [[AJPhotoBrowserViewController alloc] initWithPhotos:assets];
    //    photoBrowserViewController.delegate = self;
    //    [self presentViewController:photoBrowserViewController animated:YES completion:nil];
    
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAsset:(ALAsset *)asset {
    NSLog(@"%s",__func__);
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didDeselectAsset:(ALAsset *)asset {
    NSLog(@"%s",__func__);
}

//超过最大选择项时
- (void)photoPickerDidMaximum:(AJPhotoPickerViewController *)picker {
    NSLog(@"%s",__func__);
}

//低于最低选择项时
- (void)photoPickerDidMinimum:(AJPhotoPickerViewController *)picker {
    NSLog(@"%s",__func__);
}

- (void)photoPickerTapCameraAction:(AJPhotoPickerViewController *)picker {
    [self checkCameraAvailability:^(BOOL auth) {
        if (!auth) {
            NSLog(@"没有访问相机权限");
            return;
        }
        
        [picker dismissViewControllerAnimated:NO completion:nil];
        UIImagePickerController *cameraUI = [UIImagePickerController new];
        cameraUI.allowsEditing = NO;
        cameraUI.delegate = self;
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraUI.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
        
        [self presentViewController: cameraUI animated: YES completion:nil];
    }];
}

#pragma mark - UIImagePickerControler Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *tempImage = info[UIImagePickerControllerOriginalImage];
    [self.imgArr insertObject:tempImage atIndex:0];
    if (self.imgArr.count > 3) {
        [UserManager sharedManager].isAddImg = NO;
        [self.imgArr removeLastObject];
    }
    [self.submitReportView.collectionView reloadData];
    [self.securityReportView.collectionView reloadData];
    [self.helpReportView.collectionView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.addView show];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.addView show];
}

- (void)checkCameraAvailability:(void (^)(BOOL auth))block {
    BOOL status = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        status = YES;
    } else if (authStatus == AVAuthorizationStatusDenied) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                if (block) {
                    block(granted);
                }
            } else {
                if (block) {
                    block(granted);
                }
            }
        }];
        return;
    }
    if (block) {
        block(status);
    }
}

#pragma mark - Lazy Load
//- (AMapLocationManager *)locationManager {
//    if (!_locationManager) {
//        _locationManager = [[AMapLocationManager alloc] init];
//        _locationManager.delegate = self;
//        //开始定位
//        [_locationManager startUpdatingLocation];
//
//        //设置多少米定位一次
//        [_locationManager setDistanceFilter:20];
//
//        //设置期望定位精度
//        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
//
//        //设置不允许系统暂停定位
//        [_locationManager setPausesLocationUpdatesAutomatically:NO];
//
//        //设置允许在后台定位
//        //        [_locationManager setAllowsBackgroundLocationUpdates:YES];
//
//        //设置定位超时时间
//        [_locationManager setLocationTimeout:5];
//
//        //设置逆地理超时时间
//        [_locationManager setReGeocodeTimeout:5];
//
//    }
//    return _locationManager;
//}

- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        //[_mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading animated:YES];
        // 开启定位
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.showsUserLocation = YES;
        [_mapView setZoomLevel:16.1 animated:YES];
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

- (MAUserLocationRepresentation *)userLocationAnn {
    if (!_userLocationAnn) {
        _userLocationAnn = [[MAUserLocationRepresentation alloc] init];
        _userLocationAnn.image = [UIImage imageNamed:@"userPoint"];
    }
    return _userLocationAnn;
}

- (UIBarButtonItem *)notifItem {
    if (!_notifItem) {
        UIButton *button = [Common addBtnWithImage:@"notifications"];
        [button addTarget:self action:@selector(notiCenter) forControlEvents:UIControlEventTouchUpInside];
        _notifItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        _badgeLab = [Common badgeNumLabWithFrame:CGRectMake(18, -5, 20, 20)];
        [button addSubview:_badgeLab];
    }
    return _notifItem;
}

- (UIButton *)startTaskBtn {
    if (!_startTaskBtn) {
        _startTaskBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        [self.view addSubview:_startTaskBtn];
        _startTaskBtn.backgroundColor = kColorMain;
        _startTaskBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _startTaskBtn.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
        if (self.workType == 4) {
           [_startTaskBtn setTitle: @"开始\n航行" forState: UIControlStateNormal];
        }else {
            [_startTaskBtn setTitle: @"开始\n任务" forState: UIControlStateNormal];
        }
        
        [_startTaskBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _startTaskBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _startTaskBtn.layer.cornerRadius = 30;
        _startTaskBtn.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        _startTaskBtn.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _startTaskBtn.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _startTaskBtn.layer.shadowRadius = 2;//阴影半径，默认3
        
        [_startTaskBtn addTarget:self action:@selector(startTask) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startTaskBtn;
}

- (UIButton *)helpBtn {
    if (!_helpBtn) {
        _helpBtn = [[UIButton alloc] init];
        [self.view addSubview:_helpBtn];
        [_helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        _helpBtn.backgroundColor = KcolorRed;
        _helpBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _helpBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_helpBtn setTitle: @"一键\n求助" forState: UIControlStateNormal];
        
        [_helpBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _helpBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _helpBtn.layer.cornerRadius = 25;
        _helpBtn.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        _helpBtn.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _helpBtn.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _helpBtn.layer.shadowRadius = 2;//阴影半径，默认3
        [_helpBtn addTarget:self action:@selector(oneKeyForHelp) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _helpBtn;
}

- (UIView *)menuView {
    if (!_menuView) {
        _menuView = [Common addViewWithFrame:CGRectMake(15, kMainScreenHeight * 0.3, 45, 100)];
        [self.view addSubview:_menuView];
        
        _lineBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 50)];
        [_menuView addSubview:_lineBtn];
        
        [_lineBtn setTitleColor:kColorMain forState:UIControlStateNormal];
        _lineBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        if (self.workType == 1) {
            [_lineBtn setTitle:@"路线" forState:UIControlStateNormal];
        }
        if(self.workType == 2) {
            [_lineBtn setTitle:@"区域" forState:UIControlStateNormal];
        }
        if(self.workType == 3) {
            [_lineBtn setTitle:@"路线" forState:UIControlStateNormal];
        }
        if(self.workType == 4) {
            [_lineBtn setTitle:@"航线" forState:UIControlStateNormal];
        }
        [_lineBtn addTarget:self action:@selector(showLine) forControlEvents:UIControlEventTouchUpInside];
        
        
        _taskBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 45, 50)];
        [_menuView addSubview:_taskBtn];
        [_taskBtn setTitle:@"任务" forState:UIControlStateNormal];
        [_taskBtn setTitleColor:kColorMain forState:UIControlStateNormal];
        _taskBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_taskBtn addTarget:self action:@selector(showTaskView) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _menuView;
}

- (UIButton *)gpsBtn {
    if (!_gpsBtn) {
        _gpsBtn = [[UIButton alloc] init];
        [self.view addSubview:_gpsBtn];
        
        [_gpsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(40);
            make.left.mas_equalTo(self.view).offset(15);
            make.bottom.mas_equalTo(self.view).offset(-20);
        }];
        _gpsBtn.backgroundColor = [UIColor whiteColor];
        _gpsBtn.layer.cornerRadius = 20;
        _gpsBtn.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        _gpsBtn.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _gpsBtn.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _gpsBtn.layer.shadowRadius = 2;//阴影半径，默认3
        
        [_gpsBtn setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
        [_gpsBtn addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gpsBtn;
}

- (AddView *)addView {
    if (!_addView) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        _addView = [[AddView alloc] initWithFrame:window.frame];
    }
    return _addView;
}

- (ClockInView *)clockInView {
    if (!_clockInView) {
        if (self.workType == 3) {
            _clockInView = [[ClockInView alloc] initWithFrame:CGRectMake(25, 50, kMainScreenWidth - 50, 435)];
        }else {
            _clockInView = [[ClockInView alloc] initWithFrame:CGRectMake(25, 50, kMainScreenWidth - 50, 350)];
        }
        __weak __typeof(self)weakSelf = self;
        if (self.workType == 3) {
            [_clockInView setPickBtnBlock1:^{
                [weakSelf getAllShuttleBus];
            }];
        }
        [_clockInView setPickBtnBlock:^{
            [weakSelf getAllTask];
        }];
        [_clockInView setSubmitBtnBlock:^{
            [weakSelf submitTask];
        }];
        [_clockInView setCloseBtnBlock:^{
            [weakSelf.addView close];
        }];
    }
    return _clockInView;
}

- (BoatReportView *)boatReportView {
    if (!_boatReportView) {
        _boatReportView = [[BoatReportView alloc] initWithFrame:CGRectMake(25, 50, kMainScreenWidth - 50, 360) andState:1];
        __weak __typeof(self)weakSelf = self;
        [_boatReportView setPickBtnBlock:^{
            [weakSelf getAllShuttleBus];
        }];
        [_boatReportView setSubmitBtnBlock:^{
            [weakSelf submitBoatReportWithState:1];
        }];
        [_boatReportView setCloseBtnBlock:^{
            [weakSelf.addView close];
        }];
    }
    return _boatReportView;
}

- (BoatReportView *)bringBoatReportView {
    if (!_bringBoatReportView) {
        _bringBoatReportView = [[BoatReportView alloc] initWithFrame:CGRectMake(25, 50, kMainScreenWidth - 50, 300) andState:0];;
        __weak __typeof(self)weakSelf = self;
        [_bringBoatReportView setSubmitBtnBlock:^{
            [weakSelf submitBoatReportWithState:0];
        }];
        [_bringBoatReportView setCloseBtnBlock:^{
            [weakSelf.addView close];
        }];
    }
    return _bringBoatReportView;
}

- (NSMutableArray *)pickArr {
    if (!_pickArr) {
        _pickArr = [NSMutableArray new];
    }
    return _pickArr;
}

- (NSMutableArray *)lineIdArr {
    if (!_lineIdArr) {
        _lineIdArr = [NSMutableArray new];
    }
    return _lineIdArr;
}

- (NSMutableArray *)BusBoatArr {
    if (!_BusBoatArr) {
        _BusBoatArr = [NSMutableArray new];
    }
    return _BusBoatArr;
}

- (LineModel *)lineModel {
    if (!_lineModel) {
        _lineModel = [[LineModel alloc] init];
    }
    return _lineModel;
}

- (SecuritySocketModel *)socketModel {
    if (!_socketModel) {
        _socketModel = [[SecuritySocketModel alloc] init];
    }
    return _socketModel;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        [self.view addSubview:_submitBtn];
        [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-20);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(40);
        }];
        _submitBtn.backgroundColor = RGBColor(25, 182, 158);
        if (self.workType == 4) {
            [_submitBtn setTitle:@"安全到岸" forState:UIControlStateNormal];
        }else {
            [_submitBtn setTitle:@"上传报告" forState:UIControlStateNormal];
        }
        _submitBtn.layer.cornerRadius = 6;
        [_submitBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        _submitBtn.layer.cornerRadius = 4;
        _submitBtn.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        _submitBtn.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _submitBtn.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _submitBtn.layer.shadowRadius = 2;//阴影半径，默认3
        
        [_submitBtn addTarget:self action:@selector(showSubmitReportView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (SubmitReportView *)submitReportView {
    if (!_submitReportView) {
        _submitReportView = [[SubmitReportView alloc] initWithFrame:CGRectMake(25, 50, kMainScreenWidth - 50, 480)];
        _submitReportView.collectionView.delegate = self;
        _submitReportView.collectionView.dataSource = self;
        [_submitReportView.collectionView registerClass:[ImgCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        __weak __typeof(self)weakSelf = self;
        [_submitReportView setSubmitBtnBlock:^{
            [weakSelf submitReport];
        }];
        [_submitReportView setCloseBtnBlock:^{
            [weakSelf.addView close];
        }];
    }
    return _submitReportView;
}

- (SubmitReportView *)helpReportView {
    if (!_helpReportView) {
        _helpReportView = [[SubmitReportView alloc] initWithFrame:CGRectMake(25, 50, kMainScreenWidth - 50, 440)];
        _helpReportView.collectionView.delegate = self;
        _helpReportView.collectionView.dataSource = self;
        [_helpReportView.collectionView registerClass:[ImgCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        __weak __typeof(self)weakSelf = self;
        [_helpReportView setSubmitBtnBlock:^{
            [weakSelf submitHelpReport];
        }];
        [_helpReportView setCloseBtnBlock:^{
            [weakSelf.addView close];
        }];
    }
    return _helpReportView;
}

- (SecurityReportView *)securityReportView {
    if (!_securityReportView) {
        _securityReportView = [[SecurityReportView alloc] initWithFrame:CGRectMake(25, 50, kMainScreenWidth - 50, 200)];
        _securityReportView.collectionView.delegate = self;
        _securityReportView.collectionView.dataSource = self;
        [_securityReportView.collectionView registerClass:[ImgCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        __weak __typeof(self)weakSelf = self;
        [_securityReportView setSubmitBtnBlock:^{
            [weakSelf securitySubmitReport];
        }];
        [_securityReportView setCloseBtnBlock:^{
            [weakSelf.addView close];
        }];
    }
    return _securityReportView;
}

- (NSMutableArray *)imgArr {
    if (!_imgArr) {
        _imgArr = [NSMutableArray new];
        UIImage *image = [UIImage imageNamed:@"add_pic"];
        [_imgArr addObject:image];
    }
    return _imgArr;
}

@end
