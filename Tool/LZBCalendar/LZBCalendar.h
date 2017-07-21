//
//  LZBCalendar.h
//  LZBCalendar
//
//  Created by zibin on 16/11/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZBCalendarAppearStyle.h"
#import "LZBCalendarHeaderView.h"
#import "LZBCalendarDateCell.h"

@class LZBCalendar;

@protocol LZBCalendarDataSource <NSObject>
@required
/**
 * Tells the dataSource a call back is the calendar of height.
 */
- (void)calendar:(LZBCalendar *)calendar layoutCallBackHeight:(CGFloat)height;

@optional
/**
 * Asks the dataSource for a title for the specific date as a replacement of the day text
 */
- (NSString *)calendar:(LZBCalendar *)calendar titleForDate:(NSDate *)date;

/**
 * Asks the dataSource for a subtitle for the specific date under the day text.
 */
- (NSString *)calendar:(LZBCalendar *)calendar subtitleForDate:(NSDate *)date;

- (UIColor *)calendar:(LZBCalendar *)calendar subtitleColorForDate:(NSDate *)date;

@end


@protocol LZBCalendarDataDelegate <NSObject>

@optional

/**
 * Asks the delegate whether the specific date is allowed to be selected by tapping.
 */
- (BOOL)calendar:(LZBCalendar *)calendar shouldSelectDate:(NSDate *)date;

/**
 * Tells the delegate a date in the calendar is selected by tapping.
 */
- (void)calendar:(LZBCalendar *)calendar didSelectDate:(NSDate *)date;


/**
 告诉代理头部视图点击的响应

  */
- (void)calendar:(LZBCalendar *)calendar didSelectHeaderView:(NSDate *)date;

@end

@interface LZBCalendar : UIView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectFlowLayout;
@property (nonatomic, strong) LZBCalendarDateCell *currentSelctCell;

- (instancetype)initWithStyle:(LZBCalendarAppearStyle *)style;

/**
 * The object that acts as the data source of the calendar.
 */
@property (nonatomic, weak)  id<LZBCalendarDataSource> dataSource;

/**
 * The object that acts as the data source of the calendar.
 */
@property (nonatomic, weak)  id<LZBCalendarDataDelegate> delegate;

@end
