//
//  WelcomeViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/8/23.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic) NSArray *imagesArr;
@end

@implementation WelcomeViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self scrollView];
    [self pageControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method
//保存版本号, 并且获取AppDelegate实例来跳转页面
- (void)enterMainPage {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [Common setAsynchronous:version WithKey:kRunVersion];
    LoginViewController *loginVc = [LoginViewController new];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVc];
    [self presentViewController:loginNav animated:YES completion:nil];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //lronund() 把浮点型 -> 整型,四舍五入
    long int page = lroundf(scrollView.contentOffset.x/scrollView.frame.size.width);
    //currentPage当前页数
    self.pageControl.currentPage = page;
}
#pragma mark - Lazy Load
- (NSArray *)imagesArr {
    if (!_imagesArr) {
        _imagesArr = @[@"Welcome1.png",@"Welcome2.png",@"Welcome3.png",@"Welcome4.png"];
    }
    return _imagesArr;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        //翻页滚动模式
        _scrollView.pagingEnabled = YES;
        //隐藏横向滚动提示
        _scrollView.showsHorizontalScrollIndicator = NO;
        //设置代理来实时接收当前滚动状态
        _scrollView.delegate = self;
        //弹簧禁用
        _scrollView.bounces = NO;
        NSInteger count = self.imagesArr.count;
        UIView *lastView = nil;
        for (int i = 0; i < count; i ++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [_scrollView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(_scrollView);
                make.top.bottom.mas_equalTo(0);
                if (i == 0) {
                    make.left.mas_equalTo(0);
                }else{
                    make.left.mas_equalTo(lastView.mas_right).mas_equalTo(0);
                    if (i == count - 1) {
                        make.right.mas_equalTo(0);
                    }
                }
            }];
            
            lastView = imageView;
            
            NSString *imgPath = [[NSBundle mainBundle] pathForResource:self.imagesArr[i] ofType:nil];
            imageView.image = [UIImage imageWithContentsOfFile:imgPath];
            if (i == 3) {
                
                imageView.userInteractionEnabled = YES;
                
                UIButton *button = [[UIButton alloc] init];
                [imageView addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(120, 40));
                    make.centerX.mas_equalTo(0);
                    make.bottom.mas_equalTo(-50);
                }];
                [button setTitle:@"立即体验" forState:UIControlStateNormal];
                button.layer.cornerRadius = 5;
                [button setTitleColor:kColorWhite forState:UIControlStateNormal];
                [button setBorderColor:kColorWhite width:1 cornerRadius:5];
                [button addTarget:self action:@selector(enterMainPage) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        [self.view addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-20);
            make.centerX.mas_equalTo(0);
        }];
        _pageControl.numberOfPages = self.imagesArr.count;
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

@end
