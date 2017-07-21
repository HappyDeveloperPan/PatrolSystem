//
//  NSData+Extension.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/21.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "NSData+Extension.h"

@implementation NSData (Extension)
+ (NSData *)photoCompression:(UIImage *)image {
    NSData *data =[NSData data];
    if (image.size.width > 2048 || image.size.height > 2048) {
        image = [self imageWithImageSimple:image scaledToSize:CGSizeMake(image.size.width/2., image.size.height/2.)];
    }
    if (image.size.width > 1024 && image.size.height > 1024) {
        data = UIImageJPEGRepresentation(image, 0.5);
    }else{
        data = UIImageJPEGRepresentation(image, 1);
    }
    NSLog(@"图片宽：%f 高：%f 大小：%.1f",image.size.width,image.size.height,data.length/(1024*1024.));
    return data;
}

/**
 *  调整发图片大小
 */
+ (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}
@end
