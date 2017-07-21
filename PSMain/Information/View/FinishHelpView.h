//
//  FinishHelpView.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/15.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "AddView.h"
#import "MyTextView.h"

@interface FinishHelpView : AddView
@property (nonatomic, strong)  MyTextView *textView;
@property (nonatomic, copy) void (^submitBtnBlock)(NSString *textStr);
@end
