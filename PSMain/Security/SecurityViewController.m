//
//  SecurityViewController.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/12.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "SecurityViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "JPUSHService.h"
#import "AddView.h"
#import "ClockInView.h"
#import "KGPickerView.h"
#import "SecurityModel.h"
#import "SecuritySocketModel.h"
#import "SocketManager.h"
#import "SubmitReportView.h"
#import "AJPhotoBrowserViewController.h"
#import "AJPhotoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface SecurityViewController ()<AMapLocationManagerDelegate, MAMapViewDelegate, KGPickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, AJPhotoPickerProtocol,AJPhotoBrowserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIButton *patrolBtn, *gpsBtn, *lineBtn, *taskBtn, *submitBtn;
@property (nonatomic, strong) UIBarButtonItem *notifItem;
@property (nonatomic, strong) UILabel *badgeLab;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) NSMutableArray *menuArr, *pickArr, *lineIdArr, *imgArr;
@property (nonatomic, retain) MAMapView *mapView;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (nonatomic, strong) AddView *addView;
@property (nonatomic, strong) ClockInView *clockInView;
@property (nonatomic, strong) SubmitReportView *submitReportView;
@property (nonatomic, strong) LineModel *lineModel;
@property (nonatomic, strong) SecurityModel *securityModel;
@property (nonatomic, strong) SecuritySocketModel *socketModel;
@property (nonatomic, strong) MAMultiPolyline *polyLine;
@property (nonatomic, assign) CLLocationCoordinate2D *runningCoords;
@property (nonatomic, copy) NSString *lineId;
@end

@implementation SecurityViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorWhite;
    self.navigationItem.rightBarButtonItem = self.notifItem;
    
    [AMapServices sharedServices].enableHTTPS = YES;
    [self mapView];
    [self patrolBtn];
    [self gpsBtn];
    [self menuView];
    [self submitBtn];
    
    [kNotificationCenter addObserver:self selector:@selector(getSelectedTask) name:kReloadInfo object:nil];
    [kNotificationCenter addObserver:self selector:@selector(socketReturnData:) name:kSocketData object:nil];
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
- (void)notiCenter {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
}

//开始巡逻
- (void)startTask {
    if (![UserManager sharedManager].user.staff.task) {
        [kMainWindow showWarning:@"请先选择任务"];
        return;
    }
//    [[SocketManager sharedSocket] connectServerWithAdress:socketAdress andPort:socketPort];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    parameters[@"lat"] = [NSString stringWithFormat:@"%f", [LocationManager sharedManager].coordinate.latitude];
    parameters[@"lng"] = [NSString stringWithFormat:@"%f", [LocationManager sharedManager].coordinate.longitude];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_ConnectJudge parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                SecurityModel *model = [SecurityModel parse:jsonData[@"result"]];
                if (model.isEnter) {
                    [kMainWindow showWarning:@"任务开始"];
                    [[SocketManager sharedSocket] connectServerWithAdress:socketAdress andPort:socketPort];
                }else {
                    [kMainWindow showWarning:[NSString stringWithFormat:@"未到任务地点,距离%d米", model.distance]];
                }
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }

    }];
}

//获取当天已选任务
- (void)getSelectedTask {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_GetStaffTask parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                self.securityModel = [SecurityModel parse:jsonData[@"result"]];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
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

//显示任务路线
- (void)showLine {
    if (![UserManager sharedManager].user.staff.task) {
        [kMainWindow showWarning:@"请先选择任务"];
        return;
    }
    if (self.lineBtn.selected) {
        [self.lineBtn setSelected:NO];
        [self.mapView removeOverlay:self.polyLine];
    }else {
        [self.lineBtn setSelected:YES];
        //    _speedColors = [NSMutableArray array];
        NSMutableArray * indexes = [NSMutableArray array];
        NSInteger count = 0;
        if (self.securityModel.theSecurityLine.the_security_line.count > 0)
        {
            count = self.securityModel.theSecurityLine.the_security_line.count;
            self.runningCoords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
            
            for (int i = 0; i < count; i++)
            {
                @autoreleasepool
                {
                    CoordinateModel *coor = self.securityModel.theSecurityLine.the_security_line[i];
                    self.runningCoords[i].latitude = coor.lat;
                    self.runningCoords[i].longitude = coor.lng;
                    
//                    UIColor * speedColor = [self getColorForSpeed:[data[@"speed"] floatValue]];
//                    [_speedColors addObject:speedColor];
                    
                    [indexes addObject:@(i)];
                }
            }
        }
        
        self.polyLine = [MAMultiPolyline polylineWithCoordinates:_runningCoords count:count drawStyleIndexes:indexes];
        [self.mapView addOverlay:self.polyLine];
        
    }
}

#pragma mark -Socket通信
//解析socket通讯返回数据
- (void)socketReturnData:(NSNotification *)notif {
    if (notif.object != nil) {
        dispatch_async_on_main_queue(^{
            id  jsonData = [NSJSONSerialization JSONObjectWithData:notif.object options:NSJSONReadingAllowFragments error:nil];
            self.socketModel = [SecuritySocketModel parse:jsonData[@"result"]];
            NSLog(@"%@",self.socketModel.coordinateScope.lng);
        });
    }
}

#pragma mark -选择任务部分
//显示选择任务界面
- (void)showTaskView {
    if (![UserManager sharedManager].user.staff.task) {
        self.clockInView.center = self.addView.center;
        [self.addView addSubview:self.clockInView];
        [self.addView show];
    } else {
        [kMainWindow showWarning:@"已经选择过任务,请先完成"];
    }
}

//获取所有巡逻区域
- (void)getAllTask {
    if (self.pickArr.count == 0) {
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
        [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_QuerySecurityLine parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
            if (jsonData) {
                if ([jsonData[@"resultnumber"] intValue] == 200) {
                    for (id  model in jsonData[@"result"]) {
                        self.lineModel = [LineModel parse:model];
                        [self.pickArr addObject:self.lineModel.the_security_line_name];
                        [self.lineIdArr addObject:self.lineModel.the_security_line_id];
                    }
                    KGPickerView *pickView = [[KGPickerView alloc] initWithTitle:@"请选择巡逻区域" andContent:self.pickArr andDelegate:self];
                    [pickView showInView:self.view];
                }else {
                    [self.view showWarning:jsonData[@"cause"]];
                }
            } else {
                [self.view showWarning:error.domain];
            }
            
        }];
    }else {
        KGPickerView *pickView = [[KGPickerView alloc] initWithTitle:@"请选择巡逻区域" andContent:self.pickArr andDelegate:self];
        [pickView showInView:self.view];
    }
}

//提交选择任务
- (void)submitTask {
    if (self.clockInView.taskLab.text.length == 0) {
        [kMainWindow showWarning:@"请选择任务"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    parameters[@"the_security_line_id"] = self.lineId;
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_PatrolRecord parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.clockInView removeFromSuperview];
                [self.addView close];
                [self.view showWarning:@"打卡成功"];
                [UserManager sharedManager].user.staff.task = YES;
                [self getSelectedTask];
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
    if (![UserManager sharedManager].user.staff.task) {
        [kMainWindow showWarning:@"请先选择任务"];
        return;
    }
    if (![SocketManager sharedSocket].asyncSocket.isConnected) {
        [kMainWindow showWarning:@"请先开始任务"];
        return;
    }
    if (!self.socketModel.isAccomplish) {
        [kMainWindow showWarning:@"未停留足够长时间"];
        return;
    }
    self.submitReportView.center = self.addView.center;
    [self.addView addSubview:self.submitReportView];
    [self.addView show];
    
}

- (void)deletePic: (UIButton *)sender {
    if (![UserManager sharedManager].isAddImg) {
        [UserManager sharedManager].isAddImg = YES;
        UIImage *image = [UIImage imageNamed:@"add_pic"];
        [self.imgArr addObject:image];
    }
    [self.imgArr removeObjectAtIndex:sender.tag];
    [self.submitReportView.collectionView reloadData];
    //    NSLog(@"删除图片");
}

//提交报告(待完善)
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
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    if (self.submitReportView.normalSW.isOn) {
        parameters[@"state"] = @"true";
    }else {
        parameters[@"state"] = @"false";
    }
//    parameters[@"state"] = [NSNumber numberWithBool:self.submitReportView.normalSW.isOn];
    parameters[@"report"] = self.submitReportView.myTextView.text;
    [RXApiServiceEngine uploadImagesWithUrl:kUrl_SubmitPatrolRecord andImages:self.imgArr andParameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        [kMainWindow hideBusyHUD];
        [self.imgArr removeAllObjects];
        UIImage *image = [UIImage imageNamed:@"add_pic"];
        [self.imgArr addObject:image];
        [UserManager sharedManager].isAddImg = YES;
        [self.submitReportView.collectionView reloadData];
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.view showWarning:@"上传成功"];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
        [self.submitReportView removeFromSuperview];
        [self.addView close];
    }];
}
#pragma mark - KGPicker Delegate

- (void)confirmChoose:(NSString *)string andIndex:(NSInteger)index {
    self.clockInView.taskLab.text = string;
    self.lineId = self.lineIdArr[index];
}

#pragma mark - mapview delegate
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.image = [UIImage imageNamed:@"userPoint"];
        pre.lineWidth = 3;
        
        
        [self.mapView updateUserLocationRepresentation:pre];
        
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

- (UIButton *)patrolBtn {
    if (!_patrolBtn) {
        _patrolBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        [self.view addSubview:_patrolBtn];
        _patrolBtn.backgroundColor = kColorMain;
        _patrolBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _patrolBtn.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
        [_patrolBtn setTitle: @"开始\n任务" forState: UIControlStateNormal];
        [_patrolBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _patrolBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _patrolBtn.layer.cornerRadius = 30;
        _patrolBtn.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        _patrolBtn.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _patrolBtn.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _patrolBtn.layer.shadowRadius = 2;//阴影半径，默认3
        
        [_patrolBtn addTarget:self action:@selector(startTask) forControlEvents:UIControlEventTouchUpInside];
    }
    return _patrolBtn;
}

- (UIView *)menuView {
    if (!_menuView) {
        _menuView = [Common addViewWithFrame:CGRectMake(15, kMainScreenHeight * 0.3, 45, 100)];
        [self.view addSubview:_menuView];
        
        _lineBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 50)];
        [_menuView addSubview:_lineBtn];
        [_lineBtn setTitle:@"路线" forState:UIControlStateNormal];
        [_lineBtn setTitleColor:kColorMain forState:UIControlStateNormal];
        _lineBtn.titleLabel.font = [UIFont systemFontOfSize:15];
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
        _clockInView = [[ClockInView alloc] initWithFrame:CGRectMake(25, 50, kMainScreenWidth - 50, 350)];
        __weak __typeof(self)weakSelf = self;
        [_clockInView setPickBtnBlock:^{
            [weakSelf getAllTask];
        }];
        [_clockInView setSubmitBtnBlock:^{
            [weakSelf submitTask];
        }];
    }
    return _clockInView;
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

- (LineModel *)lineModel {
    if (!_lineModel) {
        _lineModel = [[LineModel alloc] init];
    }
    return _lineModel;
}

- (SecurityModel *)securityModel {
    if (!_securityModel) {
        _securityModel = [[SecurityModel alloc] init];
    }
    return _securityModel;
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
        [_submitBtn setTitle:@"上传报告" forState:UIControlStateNormal];
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
    }
    return _submitReportView;
}
- (NSMutableArray *)imgArr {
    if (!_imgArr) {
        _imgArr = [NSMutableArray new];
        UIImage *image = [UIImage imageNamed:@"add_pic"];
        [_imgArr addObject:image];
    }
    return _imgArr;
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
