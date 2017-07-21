//
//  LineModel.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/5/4.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinateModel.h"

@interface LineModel : NSObject
@property (nonatomic, copy) NSString *the_security_line_name;
@property (nonatomic, copy) NSString *the_security_line_id;
@property (nonatomic, strong) NSArray< CoordinateModel *> *the_security_line;

@end
