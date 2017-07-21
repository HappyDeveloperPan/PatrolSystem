//
//  CleaningViewController.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/13.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "CleaningViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "KGPickerView.h"
#import "CleaningAreaModel.h"
#import "AddView.h"
#import "ClockInView.h"
#import "SubmitReportView.h"
#import "AJPhotoPickerViewController.h"
#import "AJPhotoBrowserViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "JPUSHService.h"

@interface CleaningViewController ()<AMapLocationManagerDelegate, MAMapViewDelegate,KGPickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,AJPhotoPickerProtocol,AJPhotoBrowserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, retain) MAMapView *mapView;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (nonatomic, strong) MAMultiPolyline *polyLine;
@property (nonatomic, strong) UIBarButtonItem *notifItem;
@property (nonatomic, strong) UILabel *badgeLab;
@property (nonatomic, strong) NSMutableArray *pickArr, *imgArr;
@property (nonatomic, strong) AddView *addView;
@property (nonatomic, strong) ClockInView *clockInView;
@property (nonatomic, strong) SubmitReportView *submitReportView;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIButton *submitBtn, *gpsBtn, *startSweepBtn;
@end

@implementation CleaningViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorWhite;
    self.navigationItem.rightBarButtonItem = self.notifItem;
    
    
    [self showStaffInformation];
    
    [kNotificationCenter addObserver:self selector:@selector(loadClockInViewStaff) name:kReloadInfo object:nil];
    [kNotificationCenter addObserver:self selector:@selector(showTaskView) name:KNotifShowTask object:nil];
    
    //根据是否提交任务显示提交任务界面
//    if (![UserManager sharedManager].user.staff.task && [UserManager sharedManager].isLogin) {
//        [self showTaskView];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method
//显示工作人员基本信息界面
- (void)showStaffInformation {
    [self mapView];
    [self startSweepBtn];
    [self gpsBtn];
    [self submitBtn];
}

- (void)notiCenter {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
}

//定位自己
- (void)gpsAction {
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [self.gpsBtn setSelected:YES];
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    }
}

//开始打扫
- (void)startSweep {
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
//                SecurityModel *model = [SecurityModel parse:jsonData[@"result"]];
//                if (model.isEnter) {
//                    [kMainWindow showWarning:@"任务开始"];
//                    [[SocketManager sharedSocket] connectServerWithAdress:socketAdress andPort:socketPort];
//                }else {
//                    [kMainWindow showWarning:[NSString stringWithFormat:@"未到任务地点,距离%d米", model.distance]];
//                }
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
        
    }];
}

//显示提交任务界面
- (void)showTaskView {
    self.clockInView.center = self.addView.center;
    [self.addView addSubview:self.clockInView];
    [self.addView show];
}

//获取打扫区域信息
- (void)getCleanArea {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_QueryCleaningArea parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                self.pickArr = [NSMutableArray new];
                for (NSDictionary *dic in jsonData[@"result"]) {
                    CleaningAreaModel *clea = [CleaningAreaModel parse:dic];
//                    [self.pickArr addObject:clea.cleaning_area_id];
                }
                KGPickerView *pickerView = [[KGPickerView alloc] initWithTitle:@"请选择打扫区域" andContent:self.pickArr andDelegate:self];
                [pickerView showInView:self.view];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }

    }];
}

//刷新打卡信息
- (void)loadClockInViewStaff {
    self.clockInView.nameLab.text = [NSString stringWithFormat:@"姓名: %@",[UserManager sharedManager].user.staff.staff_name];
    self.clockInView.workTypeLab.text = [NSString stringWithFormat:@"工种: %@",[UserManager sharedManager].user.staff.workType];
    self.clockInView.phoneLab.text = [NSString stringWithFormat:@"电话: %@",[UserManager sharedManager].user.staff.staff_phone];
}

//保存打卡记录
- (void)SaveCleaningArea {
    if (self.clockInView.taskLab.text.length == 0) {
        [kMainWindow showWarning:@"请选择打扫区域"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    parameters[@"cleaning_area_id"] = self.clockInView.taskLab.text;
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_SaveCleaningArea parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.clockInView removeFromSuperview];
                [self.addView close];
                [self.view showWarning:@"打卡成功"];
//                [UserManager sharedManager].isAllowSubmitTask = YES;
                [UserManager sharedManager].user.staff.task = YES;
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

//选择打扫区域
- (void)chooseCleanArea {
    if ([UserManager sharedManager].isLogin) {
        [self getCleanArea];
    }
}

//显示工作完成上传图片界面
- (void)showSubmitReportView {
    if ([UserManager sharedManager].user.staff.task) {
        self.submitReportView.center = self.addView.center;
        [self.addView addSubview:self.submitReportView];
        [self.addView show];
    }else {
        [kMainWindow showWarning:@"当前没有任务可以提交"];
    }
}

//图片上传
- (void)uploadImage {
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
    
    [RXApiServiceEngine uploadImagesWithUrl:kUrl_SubmitCleaningRecords andImages:self.imgArr andParameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        [kMainWindow hideBusyHUD];
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.imgArr removeAllObjects];
                UIImage *image = [UIImage imageNamed:@"add_pic"];
                [self.imgArr addObject:image];
                [UserManager sharedManager].isAddImg = YES;
                [self.submitReportView.collectionView reloadData];
                [self.view showWarning:@"上传成功"];
//                [UserManager sharedManager].isAllowSubmitTask = NO;
                [UserManager sharedManager].user.staff.task = NO;
                NSLog(@"上传成功");
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
#pragma mark - KGPicker Delegate

- (void)confirmChoose:(NSString *)string andIndex:(NSInteger)index {
    self.clockInView.pickLab.text = @"打扫区域";
    self.clockInView.taskLab.text = string;
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

- (UIButton *)startSweepBtn {
    if (!_startSweepBtn) {
        _startSweepBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        [self.view addSubview:_startSweepBtn];
        _startSweepBtn.backgroundColor = kColorMain;
        _startSweepBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _startSweepBtn.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
        [_startSweepBtn setTitle: @"开始\n打扫" forState: UIControlStateNormal];
        [_startSweepBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _startSweepBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _startSweepBtn.layer.cornerRadius = 30;
        _startSweepBtn.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        _startSweepBtn.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _startSweepBtn.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _startSweepBtn.layer.shadowRadius = 2;//阴影半径，默认3
        
        [_startSweepBtn addTarget:self action:@selector(startSweep) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startSweepBtn;
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

- (ClockInView *)clockInView {
    if (!_clockInView) {
        _clockInView = [[ClockInView alloc] initWithFrame:CGRectMake(25, 50, kMainScreenWidth - 50, 350)];
        __weak __typeof(self)weakSelf = self;
        [_clockInView setPickBtnBlock:^{
            [weakSelf chooseCleanArea];
        }];
        [_clockInView setSubmitBtnBlock:^{
            [weakSelf SaveCleaningArea];
        }];
    }
    return _clockInView;
}

- (SubmitReportView *)submitReportView {
    if (!_submitReportView) {
        _submitReportView = [[SubmitReportView alloc] initWithFrame:CGRectMake(25, 50, kMainScreenWidth - 50, 450)];
        _submitReportView.collectionView.delegate = self;
        _submitReportView.collectionView.dataSource = self;
        [_submitReportView.collectionView registerClass:[ImgCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        __weak __typeof(self)weakSelf = self;
        [_submitReportView setSubmitBtnBlock:^{
            [weakSelf uploadImage];
        }];
    }
    return _submitReportView;
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

- (AddView *)addView {
    if (!_addView) {
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        _addView = [[AddView alloc] initWithParentView:window.rootViewController.view];
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        _addView = [[AddView alloc] initWithFrame:window.frame];
    }
    return _addView;
}

- (NSMutableArray *)imgArr {
    if (!_imgArr) {
        _imgArr = [NSMutableArray new];
        UIImage *image = [UIImage imageNamed:@"add_pic"];
        [_imgArr addObject:image];
    }
    return _imgArr;
}

//- (UIView *)clockInView {
//    if (!_clockInView) {
//        _clockInView = [[UIView alloc] initWithFrame:CGRectMake(25, 50, kMainScreenWidth - 50, 350)];
//        _clockInView.backgroundColor = kColorWhite;
//        _clockInView.layer.cornerRadius = 5;
//        _clockInView.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
//        _clockInView.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//        _clockInView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
//        _clockInView.layer.shadowRadius = 2;//阴影半径，默认3
////        [self.view addSubview:_clockInView];
//        
//        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _clockInView.width, 50)];
//        titleLab.text = @"员工打卡";
//        titleLab.backgroundColor = kColorMain;
//        titleLab.textColor = kColorWhite;
//        titleLab.textAlignment = NSTextAlignmentCenter;
//        //利用BezierPath设置圆角
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titleLab.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = titleLab.bounds;
//        maskLayer.path = maskPath.CGPath;
//        titleLab.layer.mask = maskLayer;
//        [_clockInView addSubview:titleLab];
//        
//        //头像
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, titleLab.bottom + 30, 80, 80)];
//        if ([[UserManager sharedManager].user.staff.staff_sex isEqualToString:@"女"]) {
//            [imageView setImage:[UIImage imageNamed:@"girl"]];
//        }else {
//            [imageView setImage:[UIImage imageNamed:@"boy"]];
//        }
//        [_clockInView addSubview:imageView];
//        
//        //姓名
//        UILabel *nameLab = self.nameLab =  [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 15, titleLab.bottom + 10, 200, 30)];
//        nameLab.textColor = kColorMajor;
//        nameLab.text = [NSString stringWithFormat:@"姓名: %@",[UserManager sharedManager].user.staff.staff_name];
//        [_clockInView addSubview:nameLab];
//        //工种
//        UILabel *workTypeLab = self.workTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 15, nameLab.bottom + 10, 200, 30)];
//        workTypeLab.textColor = kColorMajor;
//        workTypeLab.text = [NSString stringWithFormat:@"工种: %@",[UserManager sharedManager].user.staff.workType];
//        [_clockInView addSubview:workTypeLab];
//        //电话
//        UILabel *phoneLab = self.phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 15, workTypeLab.bottom + 10, 200, 30)];
//        phoneLab.textColor = kColorMajor;
//        phoneLab.text = [NSString stringWithFormat:@"电话: %@",[UserManager sharedManager].user.staff.staff_phone];
//        [_clockInView addSubview:phoneLab];
//        //选择打扫区域
//        UILabel *pickLab  = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 15, phoneLab.bottom + 10, 200, 30)];
//        pickLab.textColor = kColorMajor;
//        pickLab.text = @"打扫区域: 请选择";
//        [_clockInView addSubview:pickLab];
//        
//        UIButton *pickBtn = [[UIButton alloc] init];
//        [_clockInView addSubview:pickBtn];
//        [pickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(phoneLab.mas_bottom).mas_equalTo(15);
//            make.left.mas_equalTo(imageView.mas_right).mas_equalTo(40);
//            make.width.mas_equalTo(160);
//        }];
//        [pickBtn setImage:[UIImage imageNamed:@"right_goto"] forState:UIControlStateNormal];
//        [pickBtn addTarget:self action:@selector(chooseCleanArea) forControlEvents:UIControlEventTouchUpInside];
//        pickBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        
//        UILabel *cleanLab = self.cleanLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 15, pickLab.bottom + 10, 200, 30)];
//        cleanLab.textColor = kColorMajor;
//        [_clockInView addSubview:cleanLab];
//        
//        //提交按钮
//        UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, cleanLab.bottom + 15, _clockInView.width - 50, 50)];
//        submitBtn.backgroundColor = RGBColor(25, 182, 158);
//        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
//        submitBtn.layer.cornerRadius = 6;
//        [submitBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
//        submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [submitBtn addTarget:self action:@selector(SaveCleaningArea) forControlEvents:UIControlEventTouchUpInside];
//        [_clockInView addSubview:submitBtn];
//        
//    }
//    return _clockInView;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
