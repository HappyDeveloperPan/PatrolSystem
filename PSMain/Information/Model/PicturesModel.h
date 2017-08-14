//
//  PicturesModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/7/14.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PicturesModel : NSObject
@property (nonatomic, copy) NSString *emergency_calling_picture;
@property (nonatomic, assign) NSInteger emergency_calling_id;
@property (nonatomic, assign) NSInteger emergency_calling_picture_id;

@property (nonatomic, assign) int nowLocationd_picture_id;
@property (nonatomic, assign) int nowLocationdId;
@property (nonatomic, copy) NSString *nowLocationd_picture_url;
@end
