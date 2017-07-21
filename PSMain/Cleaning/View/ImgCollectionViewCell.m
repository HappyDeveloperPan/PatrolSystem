//
//  ImgCollectionViewCell.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/22.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "ImgCollectionViewCell.h"

@implementation ImgCollectionViewCell
- (instancetype)init {
    self = [super init];
    if (self) {
        [self imageView];
        [self deleteBtn];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.width - 20, 0, 20, 20)];
        [_deleteBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
//        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.contentView.mas_right).mas_equalTo(0);
//            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_equalTo(0);
//            make.size.mas_equalTo(CGSizeMake(40, 40));
//        }];
        [self.contentView addSubview:_deleteBtn];
    }
    return _deleteBtn;
}
@end
