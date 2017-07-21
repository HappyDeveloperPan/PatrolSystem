//
//  KGPickerView.m
//  LotteryTicket
//
//  Created by lin on 12-11-14.
//
//

#import "KGPickerView.h"

#define kDuration 0.3
#define kWidth   [[UIScreen mainScreen] bounds].size.width

@implementation KGPickerView

#define kTravleArr @[@"自驾游", @"飞机", @"汽车", @"火车", @"轮船", @"骑车", @"步行", @"其他"]
#define kSexArr @[@"男",@"女"]
#define kWorkTypeArr @[@"安保", @"保洁", @"摆渡车", @"游船"]

- (id)initWithStyle:(KGPickerViewStyle )style Title:(NSString *)title delegate:(id <KGPickerViewDelegate>)delegate
{
    self = [super initWithFrame:CGRectMake(0, 0, kWidth, 260)];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        self.style = style;
        self.backgroundColor = [UIColor whiteColor];
        // 头部
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
		toolBar.barStyle = UIBarStyleBlack;
		UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style: UIBarButtonItemStylePlain target: self action: @selector(done)];
		UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStylePlain target: self action: @selector(cancel)];
		UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
		NSArray *array = [[NSArray alloc] initWithObjects: leftButton,fixedButton, rightButton, nil];
		[toolBar setItems: array];
		[self addSubview:toolBar];
        
        // 标题 其它
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:title];
        [self addSubview:titleLabel];
        
        //picker 
        UIPickerView *pickerView = self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, kWidth, 216)];
        pickerView.showsSelectionIndicator = YES;
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [self addSubview:pickerView];
        
        if (style == KGPickerViewStyleProvinece) {
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Provineces" ofType:@"plist"];
            self.provinecesArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
            NSDictionary *firstDic = [self.provinecesArray objectAtIndex:0];
            self.secondList = [firstDic objectForKey:@"cities"];
        }
        if (style == KGPickerViewStyleTravelmodes) {
            self.travelmodesArr = kTravleArr;
            self.userString = [self.travelmodesArr objectAtIndex:0];
        }
        if (style == KGPickerViewStyleSex) {
            self.userSexArr = kSexArr;
            self.userString = [self.userSexArr objectAtIndex:0];
        }
        if (style == KGPickerViewStyleWorkType) {
            self.workTypeArr = kWorkTypeArr;
            self.userString = [self.workTypeArr objectAtIndex:0];
        }
    }
    return self;
}

- (id)initWithTitle:(NSString *)title andContent:(NSArray *)content andDelegate:(id<KGPickerViewDelegate>)delegate {
    self = [super initWithFrame:CGRectMake(0, 0, kWidth, 260)];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        self.backgroundColor = [UIColor whiteColor];
        // 头部
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
        toolBar.barStyle = UIBarStyleBlack;
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style: UIBarButtonItemStylePlain target: self action: @selector(done)];
        UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStylePlain target: self action: @selector(cancel)];
        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
        NSArray *array = [[NSArray alloc] initWithObjects: leftButton,fixedButton, rightButton, nil];
        [toolBar setItems: array];
        [self addSubview:toolBar];
        
        // 标题 其它
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:title];
        [self addSubview:titleLabel];
        
        //picker
        UIPickerView *pickerView = self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, kWidth, 216)];
        pickerView.showsSelectionIndicator = YES;
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [self addSubview:pickerView];
        
        self.pickerViewArr = content;
//        self.userString = [[self.pickerViewArr objectAtIndex:0] objectForKey:@"cleaning_area_id"];
        self.userString = [self.pickerViewArr objectAtIndex:0];
        
    }
    return self;
}

- (id)initWithTitle:(NSString *)title andContent:(NSArray *)content andDelegate:(id<KGPickerViewDelegate>)delegate andStyle:(KGPickerViewStyle)style {
    self = [super initWithFrame:CGRectMake(0, 0, kWidth, 260)];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        self.style = style;
        self.backgroundColor = [UIColor whiteColor];
        // 头部
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
        toolBar.barStyle = UIBarStyleBlack;
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style: UIBarButtonItemStylePlain target: self action: @selector(done)];
        UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStylePlain target: self action: @selector(cancel)];
        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
        NSArray *array = [[NSArray alloc] initWithObjects: leftButton,fixedButton, rightButton, nil];
        [toolBar setItems: array];
        [self addSubview:toolBar];
        
        // 标题 其它
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:title];
        [self addSubview:titleLabel];
        
        //picker
        UIPickerView *pickerView = self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, kWidth, 216)];
        pickerView.showsSelectionIndicator = YES;
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [self addSubview:pickerView];
        
        self.pickerViewArr = content;
        if (self.pickerViewArr.count != 0) {
            self.userString = [self.pickerViewArr objectAtIndex:0];
        }else {
            self.userString = @"";
        }
        
        
    }
    return self;
}

- (id)initDatePickerWithTitle:(NSString *)title delegate:(id <KGPickerViewDelegate>)delegate
{
    self = [super initWithFrame:CGRectMake(0, 0, kWidth, 260)];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        self.backgroundColor = [UIColor whiteColor];
        self.style = 10;
        // 头部
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
        toolBar.barStyle = UIBarStyleBlack;
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style: UIBarButtonItemStylePlain target: self action: @selector(done)];
        UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStylePlain target: self action: @selector(cancel)];
        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
        NSArray *array = [[NSArray alloc] initWithObjects: leftButton,fixedButton, rightButton, nil];
        [toolBar setItems: array];
        [self addSubview:toolBar];
        
        // 标题 其它
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:title];
        [self addSubview:titleLabel];
        
        //picker
        UIDatePicker *pickerView = self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, kWidth, 216)];
        pickerView.datePickerMode = UIDatePickerModeDate;
        [self addSubview:pickerView];
    }
    return self;
}

- (void)showInView:(UIView *) view
{
    _kgView = [KGModal sharedInstance];
    _kgView.tapOutsideToDismiss = YES;
    [_kgView setShowCloseButton:NO];
    [_kgView showPickerWithContentView:self andAnimated:YES];
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //if (_style == KGPickerViewStyleNormal || _style == KGPickerViewStyleIntegral) {
      //  return 1;
   // }else{
     //   return 2;
    //}
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_style == KGPickerViewStyleProvinece) {
        switch (component) {
            case 0:
            {
                return self.provinecesArray.count;
            }
                break;
            case 1:
            {
                return [self.secondList count];
            }
                break;
            default:
                return 0;
                break;
        }
    }
    if (_style == KGPickerViewStyleTravelmodes) {
        return self.travelmodesArr.count;
    }
    if (_style == KGPickerViewStyleSex) {
        return self.userSexArr.count;
    }
    if (_style == KGPickerViewStyleWorkType) {
        return self.workTypeArr.count;
    }
    return self.pickerViewArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_style == KGPickerViewStyleProvinece) {
        switch (component) {
            case 0:
            {
                NSDictionary *firstDic = [self.provinecesArray objectAtIndex:row];
                return [firstDic objectForKey:@"ProvinceName"];
            }
                break;
            case 1:
            {
                return [[self.secondList objectAtIndex:row] objectForKey:@"CityName"];
            }
                break;
            default:
                return nil;
                break;
        }
    }
    if (_style == KGPickerViewStyleTravelmodes) {
        return [self.travelmodesArr objectAtIndex:row];
    }
    if (_style == KGPickerViewStyleSex) {
        return [self.userSexArr objectAtIndex:row];
    }
    if (_style == KGPickerViewStyleWorkType) {
        return [self.workTypeArr objectAtIndex:row];
    }
//    return [[self.pickerViewArr objectAtIndex:row] objectForKey:@"cleaning_area_id"];
    return [self.pickerViewArr objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (_style == KGPickerViewStyleTravelmodes) {
        self.userString =  [self.travelmodesArr objectAtIndex:row];
    }else if (_style == KGPickerViewStyleSex) {
        self.userString =  [self.userSexArr objectAtIndex:row];
    }else if (_style == KGPickerViewStyleWorkType) {
        self.userString = [self.workTypeArr objectAtIndex:row];
    }else {
        self.userString = [self.pickerViewArr objectAtIndex:row];
        self.myindex = row;
    }
    
//    self.userString = [[self.pickerViewArr objectAtIndex:row] objectForKey:@"cleaning_area_id"];
    
}

#pragma mark - Button lifecycle

- (void)cancel{
    [self hideView];
}

- (void)done{
    [self hideView];
    // 点击确定，执行代理方法
    
    
    ////////
    if (_style == KGPickerViewStyleTravelmodes) {
        [_delegate confirmTravelmodes:self.userString];
        return;
    }
    if (_style == KGPickerViewStyleSex) {
        [_delegate confirmSex:self.userString];
        return;
    }
    if (_style == KGPickerViewStyleWorkType) {
        [_delegate confirmWorkType:self.userString];
        return;
    }
//    [_delegate confirmChoose:self.userString];
    [_delegate confirmChoose:self.userString andIndex:self.myindex andStyle:self.style];
}
-(void)hideView
{
    [_kgView hide];
}

#pragma mark - Lazy Load
- (NSArray *)pickerViewArr {
    if (!_pickerViewArr) {
        _pickerViewArr = [NSArray new];
    }
    return _pickerViewArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
