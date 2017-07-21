//
//  SecurityReportView.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/23.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextView.h"

@interface SecurityReportView : UIView
@property (nonatomic, copy) void (^submitBtnBlock)();
@property (nonatomic, copy) void (^closeBtnBlock)();
@property (nonatomic, strong) MyTextView *myTextView;
@property (nonatomic, strong) UILabel *warningLab;
@property (nonatomic, strong) NSMutableArray *buttonArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) BOOL isShow; //是否已经显示
@end
