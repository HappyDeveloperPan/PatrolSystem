//
//  KGPickerView.h
//  LotteryTicket
//
//  Created by lin on 12-11-14.
//
//

//typedef enum : NSUInteger{
//    KGPickerViewStyleNormal = 0,
//    KGPickerViewStyleBet = 1,
//    KGPickerViewStyleDouble = 2,
//    KGPickerViewStyleProvinece = 3,
//    KGPickerViewStyleIntegral = 4,
//    /* 新增 */
//    KGPickerViewStyleTravelmodes = 5,
//    KGPickerViewStyleSex = 6,
//    KGPickerViewStyleWorkType = 7,
//    /*******/
//    KGPickerViewStyleDate   = 8
////    UITableViewScrollPositionBottom
//} KGPickerViewStyle;

typedef NS_ENUM(NSUInteger, KGPickerViewStyle) {
    KGPickerViewStyleNormal = 0,
    KGPickerViewStyleBet = 1,
    KGPickerViewStyleDouble = 2,
    KGPickerViewStyleProvinece = 3,
    KGPickerViewStyleIntegral = 4,
    /* 新增 */
    KGPickerViewStyleTravelmodes = 5,
    KGPickerViewStyleSex = 6,
    KGPickerViewStyleWorkType = 7,
    KGPickerViewStyleBus = 8,
    KGPickerViewStyleBoat = 9,
    /*******/
    KGPickerViewStyleDate   = 10
};

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KGModal.h"

@protocol KGPickerViewDelegate;

@interface KGPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign) KGPickerViewStyle style;
@property (strong) KGModal *kgView;
@property (strong) id<KGPickerViewDelegate> delegate;
@property (strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSArray *firstList,*secondList,*provinecesArray, *travelmodesArr, *userSexArr, *workTypeArr, *pickerViewArr;
@property (assign) NSInteger firstIndex,secondIndex;
@property (strong) UIDatePicker *datePicker;
@property (nonatomic, copy) NSString *userString;
@property (nonatomic, assign) NSInteger myindex;

- (id)initWithStyle:(KGPickerViewStyle)style Title:(NSString *)title delegate:(id<KGPickerViewDelegate>)delegate ;
- (id)initDatePickerWithTitle:(NSString *)title delegate:(id <KGPickerViewDelegate>)delegate;
- (id)initWithTitle: (NSString *)title andContent: (NSArray *)content andDelegate:(id<KGPickerViewDelegate>)delegate;
- (id)initWithTitle: (NSString *)title andContent: (NSArray *)content andDelegate:(id<KGPickerViewDelegate>)delegate andStyle:(KGPickerViewStyle)style;
- (void)showInView:(UIView *) view;
-(void)hideView;

@end


@protocol KGPickerViewDelegate <NSObject>

@optional
-(void)confirmIndex:(NSInteger)firstIndex;
-(void)confirmDate:(NSDate *)date;
-(void)confirmFirst:(NSInteger)firstIndex Second:(NSInteger)secondIndex;
-(void)confirmProvinceName:(NSString *)provinceName cityName:(NSString *)cityName First:(NSInteger)firstIndex Second:(NSInteger)secondIndex;
- (void)confirmTravelmodes:(NSString *)string;
- (void)confirmSex:(NSString *)string;
- (void)confirmWorkType:(NSString *)string;
- (void)confirmChoose:(NSString *)string;
- (void)confirmChoose:(NSString *)string andIndex:(NSInteger)index andStyle:(KGPickerViewStyle)style;
@end
