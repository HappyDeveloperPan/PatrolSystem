//
//  HandleResultViewController.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/15.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpModel.h"
#import "UnusualModel.h"

typedef NS_ENUM(NSUInteger, InfoType) {
    HelpInfo,
    UnusualInfo,
};

@interface HandleResultViewController : UIViewController
@property (nonatomic, strong) HelpModel *helpModel;
@property (nonatomic, strong) UnusualModel *unusualModel;
@property (nonatomic, assign) InfoType infoType;
@end
