//
//  AddView.m
//  Luohe
//
//  Created by sks on 16/6/1.
//  Copyright © 2016年 linyingbin. All rights reserved.
//

#import "AddView.h"

@implementation AddView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (instancetype)initWithParentView:(UIView *)parentView {
    self = [super initWithFrame:parentView.frame];
    if (self) {
        self.parentView = parentView;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return YES;
    }
    return NO;
}

- (void)show {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
//    [self.parentView addSubview:self];
    [kMainWindow addSubview:self];
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    } completion:NULL];
}

- (void)close {
    [UIView animateWithDuration:0.0f delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)oneTap {
    [self close];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
