//
//  WarningManager.m
//  YiToOnline
//
//  Created by 刘艳凯 on 2017/2/14.
//  Copyright © 2017年 吴迪. All rights reserved.
//

#import "WarningManager.h"
@import AudioToolbox;

void soundCompleteCallback() {
//    [self performSelector:@selector(triggerShake) withObject:nil afterDelay:1]
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  //震动
//    AudioServicesPlaySystemSound(1007);  // 播放系统声音
    
    //延时执行
    dispatch_time_t myTime = dispatch_time(DISPATCH_TIME_NOW, 1ull *NSEC_PER_SEC);
    dispatch_after(myTime, dispatch_get_main_queue(), ^{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  //震动
//        AudioServicesPlaySystemSound(1007);  // 播放系统声音
    });
}



@implementation WarningManager
+ (WarningManager *)shareManager {
    static id warning;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        warning = [self new];
    });
    return warning;
}


//警报开启
- (void)startScreenFlicker {
    
    [kMainWindow addSubview:self.redView];
    
//    SystemSoundID sound;
//    NSString *path = [[NSBundle mainBundle] pathForResource:soundName ofType:nil];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &_sound);
    
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, soundCompleteCallback, NULL);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    AudioServicesPlaySystemSound(1007);
    
    [self redFlicker];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"收到一键求助任务" message:@"请前去处理" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    
    [alertView show];
}

//红光闪烁
- (void)redFlicker {
    if (self.twinkleTime) {
        [self.twinkleTime invalidate];
        self.twinkleTime = nil;
    }
    self.twinkleTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(redFlicker) userInfo:nil repeats:YES];
    
    [self.redView setAlpha:1];
    [UIView beginAnimations:@"flash screen" context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self.redView setAlpha:0.0f];
    [UIView commitAnimations];
}

//警报关闭
- (void)endScreenFlicker {
    [self.twinkleTime invalidate];
    self.twinkleTime = nil;
    [self.redView removeFromSuperview];
    
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
//    AudioServicesDisposeSystemSoundID(1007);
//    AudioServicesRemoveSystemSoundCompletion(1007);
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self endScreenFlicker];
    }
}


- (instancetype)init {
    if (self = [ super init] ) {
        
        self.redView =[[UIView alloc] initWithFrame:kMainScreenFrame];
        self.redView.backgroundColor = KcolorRed;
        [self.redView setAlpha:0];
    }
    return self;
}
@end
