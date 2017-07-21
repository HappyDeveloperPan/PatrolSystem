//
//  HelpInfoViewController.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/19.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, InfoType) {
    HelpInfo,
    UnusualInfo,
};

@interface HelpInfoViewController : UIViewController
@property (nonatomic, assign) NSInteger notiNumber;
@property (nonatomic, assign) InfoType infoType;
@end
