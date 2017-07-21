//
//  NSData+Extension.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/21.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Extension)

/**
 图片压缩

 @param image 图片
 @return 返回data
 */
+ (NSData *)photoCompression:(UIImage *)image;
@end
