//
//  RadialCircleAnnotationView.m
//  AMapRadialCircleDemo
//
//  Created by liubo on 11/23/16.
//  Copyright © 2016 AutoNavi. All rights reserved.
//

#import "RadialCircleAnnotationView.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomCalloutView.h"
#import "LookPhoto.h"

@interface RadialCircleAnnotationView ()<UIScrollViewDelegate>


@property (nonatomic, strong) NSMutableArray *pulseLayers;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation RadialCircleAnnotationView

#pragma mark - Lift Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self buildRadialCircle];
    }
    return self;
}

- (void)buildRadialCircle
{
    self.pulseLayers = [[NSMutableArray alloc] init];
    
    //Default Value
    self.pulseCount = 4;
    self.animationDuration = 8.0;
    self.baseDiameter = 8.0;
    self.scale = 30.0;
    self.fillColor = [UIColor colorWithRed:24.f/255.f green:137.f/255.f blue:234.f/255.f alpha:1.0];
    self.strokeColor = [UIColor colorWithRed:35.f/255.f green:35.f/255.f blue:255.f/255.f alpha:1.0];
    
    //fixedLayer
    double fixedLayerDiameter = 20;
    self.layer.bounds = CGRectMake(0, 0, fixedLayerDiameter, fixedLayerDiameter);
    
    self.fixedLayer = [CALayer layer];
    self.fixedLayer.bounds = self.layer.bounds;
    self.fixedLayer.position = CGPointMake(CGRectGetMidX(self.layer.bounds), CGRectGetMidY(self.layer.bounds));
    self.fixedLayer.cornerRadius = fixedLayerDiameter / 2.0;
    self.fixedLayer.backgroundColor = [UIColor blueColor].CGColor;
    self.fixedLayer.borderColor = [UIColor whiteColor].CGColor;
    self.fixedLayer.borderWidth = 4;
    [self.layer addSublayer:self.fixedLayer];
    
    [self startPulseAnimation];
}

#pragma mark - Interface

- (void)stopPulseAnimation
{
    for (CALayer *aLayer in self.pulseLayers)
    {
        [aLayer removeAllAnimations];
        [aLayer removeFromSuperlayer];
    }
    
    [self.pulseLayers removeAllObjects];
}

- (void)startPulseAnimation
{
    if ([self.pulseLayers count] > 0)
    {
        [self stopPulseAnimation];
    }
    
    CFTimeInterval currentMediaTime = CACurrentMediaTime();
    CFTimeInterval timeIntercal = self.animationDuration / self.pulseCount;
    
    for (int i = 0; i < self.pulseCount; i++)
    {
        CALayer *aLayer = [self buildPulseLayerWithBuginTime:(currentMediaTime + timeIntercal * i)];
        
        [self.pulseLayers addObject:aLayer];
        [self.layer addSublayer:aLayer];
    }
}

#pragma mark - Utility

- (CALayer *)buildPulseLayerWithBuginTime:(CFTimeInterval)beginTime
{
    CALayer *aLayer = [CALayer layer];
    
    aLayer.bounds = CGRectMake(0, 0, self.baseDiameter, self.baseDiameter);
    aLayer.position = CGPointMake(CGRectGetMidX(self.layer.bounds), CGRectGetMidY(self.layer.bounds));
    aLayer.cornerRadius = self.baseDiameter / 2.0;
    aLayer.backgroundColor = self.fillColor.CGColor;
    aLayer.borderColor = self.strokeColor.CGColor;
    aLayer.borderWidth = 2;
    aLayer.opacity = 0;
    aLayer.zPosition = -100;
    
    CAAnimation *pulseAnimation = [self buildPulseAnimationWithDiameter:self.baseDiameter
                                                                  scale:self.scale
                                                               duration:self.animationDuration
                                                              beginTime:beginTime];
    [aLayer addAnimation:pulseAnimation forKey:@"pulseAnimation"];
    
    return aLayer;
}

- (CAAnimation *)buildPulseAnimationWithDiameter:(CGFloat)diameter scale:(float)scale duration:(float)duration beginTime:(CFTimeInterval)beginTime
{
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *aniFade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    aniFade.fromValue = @(0.65);
    aniFade.toValue = @(0.0);
    
    CABasicAnimation *aniScale = [CABasicAnimation animationWithKeyPath:@"bounds"];
    aniScale.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, diameter, diameter)];
    aniScale.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, diameter * scale, diameter * scale)];
    
    CABasicAnimation *aniCorner = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    aniCorner.fromValue = @(diameter / 2.0);
    aniCorner.toValue = @(diameter * scale / 2.0);
    
    aniGroup.animations = @[aniFade, aniScale, aniCorner];
    aniGroup.removedOnCompletion = NO;
    aniGroup.duration = duration;
    aniGroup.repeatCount = HUGE_VALF;
    aniGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    aniGroup.beginTime = beginTime;
    
    return aniGroup;
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
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, 280, 300)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.calloutView.width, 40)];
            titleLab.text = @"详情报告";
            titleLab.backgroundColor = kColorMain;
            titleLab.textColor = kColorWhite;
            titleLab.textAlignment = NSTextAlignmentCenter;
            //利用BezierPath设置圆角
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titleLab.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6,6)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = titleLab.bounds;
            maskLayer.path = maskPath.CGPath;
            titleLab.layer.mask = maskLayer;
            [self.calloutView addSubview:titleLab];
            
            //姓名
            UILabel *nameLab = self.nameLab =  [[UILabel alloc] initWithFrame:CGRectMake(25, titleLab.bottom + 10, 200, 20)];
            nameLab.textColor = kColorMajor;
            nameLab.font = [UIFont systemFontOfSize:15];
            [self.calloutView addSubview:nameLab];
            //电话
            UILabel *phoneLab = self.phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(25, nameLab.bottom + 10, 200, 20)];
            phoneLab.textColor = kColorMajor;
            phoneLab.font = [UIFont systemFontOfSize:15];
            [self.calloutView addSubview:phoneLab];
            //报告
            UILabel *reportLab  =  [[UILabel alloc] initWithFrame:CGRectMake(25, phoneLab.bottom + 10, 40, 20)];
            reportLab.textColor = kColorMajor;
            reportLab.font = [UIFont systemFontOfSize:15];
            reportLab.text = @"报告: ";
            [self.calloutView addSubview:reportLab];
            
            self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(reportLab.right, phoneLab.bottom + 10, self.calloutView.width - 85, 100)];
            self.scrollView.delegate = self;
            self.scrollView.bounces = NO;
            self.scrollView.indicatorStyle =UIScrollViewIndicatorStyleWhite;
            self.scrollView.backgroundColor = kColorBg;
            UILabel *introduceLab = self.reportLab =  [[UILabel alloc] initWithFrame:CGRectMake(5 , 5, self.scrollView.width - 10, 50)];
            introduceLab.numberOfLines = 0;
            introduceLab.textColor = kColorMajor;
            introduceLab.text = self.helpModel.emergencyCalling.origin;
            introduceLab.font = [UIFont systemFontOfSize:14];
            [introduceLab sizeToFit];
            [self.scrollView addSubview:introduceLab];
            self.scrollView.contentSize = CGSizeMake(introduceLab.width, introduceLab.height);
            [self.calloutView addSubview:self.scrollView];
            //图片
            [self showHelpStaffData:self.helpModel];
        }
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (void)showHelpStaffData:(HelpModel *)helpModel {
    self.nameLab.text = [NSString stringWithFormat:@"姓名: %@", helpModel.staffOnLine.staff.staff_name];
    self.phoneLab.text = [NSString stringWithFormat:@"电话: %@", helpModel.staffOnLine.staff.staff_phone];
//    self.reportLab.text = helpModel.emergencyCalling.origin;
    
    //图片
    CGFloat width = (self.calloutView.width - 25) / 3;
    for (int i=0; i< helpModel.emergencyCallingPictures.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((width)*i + 25, self.scrollView.bottom + 10, 60, 60)];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPic:)]];
        imageView.tag = i;
        PicturesModel *picturesModel = helpModel.emergencyCallingPictures[i];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.yituinfo.cn/Patrolling%@",picturesModel.emergency_calling_picture]] placeholder:[UIImage imageNamed:@"default"]];
        [imageView setMultipleTouchEnabled:YES];
        [self.calloutView addSubview:imageView];
    }
}


- (void)showPic:(UITapGestureRecognizer *)tap{
    
//    NSArray *imageUrlArray = self.detailModel.pictures;
//    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:imageUrlArray.count];
//    
//    for (int i=0; i<imageUrlArray.count; i++) {
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString:imageUrlArray[i]]; // 图片路径
//        photo.srcImageView = [[UIImageView new] viewWithTag:i]; // 来源于哪个UIImageView
//        [photos addObject:photo];
//    }
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = [[tapGes view] tag]; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    [browser show];
    
    UIImageView *imageView = (UIImageView *)tap.view;
    [LookPhoto scanBigImageWithImageView:imageView];
}

@end
