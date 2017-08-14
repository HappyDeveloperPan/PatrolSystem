//
//  WarningManager.h
//  YiToOnline
//
//  Created by 刘艳凯 on 2017/2/14.
//  Copyright © 2017年 吴迪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WarningManager : NSObject<UIAlertViewDelegate>
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) NSTimer *twinkleTime;
@property (nonatomic, copy) NSData *returnData;

+ (WarningManager *)shareManager;


//警报开启
- (void)startScreenFlicker;

//警报关闭
- (void)endScreenFlicker;
@end
