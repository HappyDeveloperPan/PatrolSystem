//
//  AddView.h
//  Luohe
//
//  Created by sks on 16/6/1.
//  Copyright © 2016年 linyingbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, assign) id delegate;

- (instancetype)initWithParentView: (UIView *)parentView;
- (void)show;
- (void)close;
@end
