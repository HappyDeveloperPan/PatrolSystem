//
//  SubmitReportView.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/21.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextView.h"
#import "ImgCollectionViewCell.h"

@interface SubmitReportView : UIView
//@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) MyTextView *myTextView;
@property (nonatomic, copy) void (^submitBtnBlock)();
@property (nonatomic, copy) void (^closeBtnBlock)();
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UISwitch *normalSW;
@property (nonatomic, assign) BOOL isShow; //是否已经显示
@end
