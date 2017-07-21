//
//  StaffAnnotationView.m
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/7/17.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "StaffAnnotationView.h"
#import "CustomCalloutView.h"

@implementation StaffAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.canShowCallout) {
        return;
    }
    if (self.selected == selected)
    {
        return;
    }
    if (selected)
    {
        if (self.calloutView == nil)
        {
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, 280, 180)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            
            UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 40, 40)];
            headImg.backgroundColor = [UIColor clearColor];
            headImg.layer.cornerRadius = 20;
            headImg.clipsToBounds = YES;
            if ([self.staffModel.staff.staff_sex isEqualToString:@"男"]) {
                [headImg setImage:[UIImage imageNamed:@"boy"]];
            }else {
                [headImg setImage:[UIImage imageNamed:@"girl"]];
            }
            [self.calloutView addSubview:headImg];
            
//            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.calloutView.width, 40)];
//            titleLab.text = @"详情报告";
//            titleLab.backgroundColor = kColorMain;
//            titleLab.textColor = kColorWhite;
//            titleLab.textAlignment = NSTextAlignmentCenter;
//            //利用BezierPath设置圆角
//            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titleLab.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6,6)];
//            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//            maskLayer.frame = titleLab.bounds;
//            maskLayer.path = maskPath.CGPath;
//            titleLab.layer.mask = maskLayer;
//            [self.calloutView addSubview:titleLab];
            
            //姓名
            UILabel *nameLab = self.nameLab =  [[UILabel alloc] initWithFrame:CGRectMake(headImg.right + 10,10, self.calloutView.width - 70, 20)];
            nameLab.textColor = kColorMajor;
            nameLab.text = [NSString stringWithFormat:@"姓名: %@", self.staffModel.staff.staff_name];
            nameLab.font = [UIFont systemFontOfSize:15];
            [self.calloutView addSubview:nameLab];
            //电话
            UILabel *phoneLab = self.phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(headImg.right + 10, nameLab.bottom + 10, self.calloutView.width - 70, 20)];
            phoneLab.textColor = kColorMajor;
            phoneLab.text = [NSString stringWithFormat:@"电话: %@", self.staffModel.staff.staff_phone];
            phoneLab.font = [UIFont systemFontOfSize:15];
            [self.calloutView addSubview:phoneLab];
            //工种
            UILabel *workTypeLb  =  [[UILabel alloc] initWithFrame:CGRectMake(headImg.right + 10, phoneLab.bottom + 10, self.calloutView.width - 70, 20)];
            workTypeLb.textColor = kColorMajor;
            workTypeLb.font = [UIFont systemFontOfSize:15];
            workTypeLb.text = [NSString stringWithFormat:@"工种: %@", self.staffModel.staff.workType];
            [self.calloutView addSubview:workTypeLb];
            //距离
            UILabel *distanceLb = [[UILabel alloc] initWithFrame:CGRectMake(headImg.right + 10, workTypeLb.bottom + 10, self.calloutView.width - 70, 20)];
            distanceLb.textColor = kColorMajor;
            distanceLb.font = [UIFont systemFontOfSize:15];
            distanceLb.text = [NSString stringWithFormat:@"距离: %f", self.staffModel.distance];
            [self.calloutView addSubview:distanceLb];
        }
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}
#pragma mark - Method

- (UILabel *)addLableWithFrame:(CGRect)frame andText:(NSString *)text {
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = text;
    lable.textColor = kColorMajor;
    lable.font = [UIFont systemFontOfSize:13];
    [lable sizeToFit];
    return lable;
}

- (UILabel *)addLableWithFrame2:(CGRect)frame andText:(NSString *)text {
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = text;
    lable.textColor = RGBColor(248, 117, 69);
    lable.font = [UIFont systemFontOfSize:13];
    lable.adjustsFontSizeToFitWidth = YES;
    [lable sizeToFit];
    return lable;
}

//- (CLLocationDistance)howDistance {
//    CLLocationCoordinate2D loc1 = self.userLocation.coordinate;
//    CLLocationCoordinate2D loc2 = [self.annotation coordinate];
//    
//    MAMapPoint p1 = MAMapPointForCoordinate(loc1);
//    MAMapPoint p2 = MAMapPointForCoordinate(loc2);
//    
//    CLLocationDistance distance =  MAMetersBetweenMapPoints(p1, p2);
//    return distance;
//}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        self.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        self.layer.shadowRadius = 2;//阴影半径，默认3
    }
    
    return self;
}

- (StaffOnLineModel *)staffModel {
    if (!_staffModel) {
        _staffModel = [[StaffOnLineModel alloc] init];
    }
    return _staffModel;
}
#pragma mark - Lazy Load

@end
