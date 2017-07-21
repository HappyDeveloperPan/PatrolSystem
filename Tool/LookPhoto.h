//
//  LookPhoto.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/21.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LookPhoto : NSObject
@property (nonatomic, strong) UIView *backgroundView;
/**
 *  浏览大图
 *
 *  @param currentImageview 图片所在的imageView
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview;
@end
