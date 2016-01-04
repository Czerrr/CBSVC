//
//  CBScrollViewController.m
//  CBScrollViewController
//
//  Created by Czer Bourne on 16/1/4.
//  Copyright © 2016年 Czerrr. All rights reserved.
//

#import "CBScrollViewController.h"
#import "UIView+CBFrameExtension.h"
#import "CBTitleButton.h"

@interface CBScrollViewController () <UIScrollViewDelegate>
/**
 *  当前屏幕页面所在的页数
 */
@property (nonatomic, assign) int pageNum;
/**
 *  标题scroll
 */
@property (nonatomic, strong, readonly) UIScrollView *titleScrollView;
/**
 *  标题scroll上显示的button数组
 */
@property (nonatomic, strong) NSArray *titleButtonArray;
/**
 *  当前选中的titleButton
 */
@property (nonatomic, strong) CBTitleButton *selectedButton;
/**
 *  内容scroll
 */
@property (nonatomic, strong, readonly) UIScrollView *contentScrollView;
/**
 *  内容scroll中循环使用view的数组
 */
@property (nonatomic, strong) NSMutableArray *reuseArray;
/**
 *  内容scroll上一次滑动停止时的contentOffset.x
 */
@property (nonatomic, assign) CGFloat oldOffsetX;
/**
 *  从reuseArray中取出view临时存放
 */
@property (nonatomic, strong) UIView *tmpView;
/**
 *  判断是否为手动滑动（与点击titleButton区分）
 */
@property (nonatomic, assign) BOOL isSlided;

@end

@implementation CBScrollViewController

/** titleButton宽度 */
#define titleButtonWidth (self.titleScrollView.width / 4)
/** titleButton高度 */
#define titleButtonHeight self.titleScrollView.height

#pragma mark - 系统自带方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化titleScrollView
    if (self.navigationController != nil) {
        [self setupTitleScrollViewWithFrame:CGRectMake(0, 64, self.view.width, 35)];
    } else {
        [self setupTitleScrollViewWithFrame:CGRectMake(0, 20, self.view.width, 35)];
    }

    
    // 初始化contentScrollView
    [self setupContentScrollView];
}

- (void)viewDidLayoutSubviews {
    self.titleScrollView.contentInset = UIEdgeInsetsZero;
    self.contentScrollView.contentInset = UIEdgeInsetsZero;
}

#pragma mark - 自定义方法
+ (instancetype)scrollViewControllerWithTitleButtonArray:(NSArray *)titleButtonArray {
    CBScrollViewController *vc = [[self alloc] init];
    vc.titleButtonArray = titleButtonArray;
    for (int i = 0; i < titleButtonArray.count; i++) {
        CBTitleButton *titleButton = titleButtonArray[i];
        [vc addChildViewController:titleButton.viewController];
    }
    return vc;
}

/** 初始化标题部分 titleScrollView */
- (void)setupTitleScrollViewWithFrame:(CGRect)frame {
    UIScrollView *titleScroll = [[UIScrollView alloc] initWithFrame:frame];
    _titleScrollView = titleScroll;
    titleScroll.bounces = NO;
    titleScroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:titleScroll];
    
    // 添加按钮
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    for (int i = 0; i < self.titleButtonArray.count; i++) {
        btnX = titleButtonWidth * i;
        
        CBTitleButton *btn = self.titleButtonArray[i];
        btn.frame = CGRectMake(btnX, btnY, titleButtonWidth, titleButtonHeight);
        btn.tag = i;
        [titleScroll addSubview:btn];
        
        [btn addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 设置titleScroll.contentSize
    titleScroll.contentSize = CGSizeMake(self.titleButtonArray.count * titleButtonWidth, 0);
    
    // 第一个titleButton默认为选中状态
    self.selectedButton = self.titleButtonArray[0];
    self.selectedButton.selected = YES;
}

/** titleButton点击事件函数 */
- (void)titleButtonClicked:(CBTitleButton *)button {
    self.pageNum = (int)button.tag;
}

/** self.pageNum的setter */
- (void)setPageNum:(int)pageNum {
    if (_pageNum == pageNum) {
        return;
    }
    
// 处理titleScrollView的button显示(button选中状态、位置frame的改变等)
    // 改变选中状态
    self.selectedButton.selected = NO;
    self.selectedButton = self.titleButtonArray[pageNum];
    self.selectedButton.selected = YES;
    
    // 改变frame
    if (pageNum == 0 || pageNum == 1) { // 前两页titleButton位置不变
        [self.titleScrollView setContentOffset:CGPointZero animated:YES];
    } else if (pageNum == self.titleButtonArray.count - 2 || pageNum == self.titleButtonArray.count - 1) { // 后两页titleButton位置不变
        [self.titleScrollView setContentOffset:CGPointMake(titleButtonWidth * (self.titleButtonArray.count - 4), 0) animated:YES];
    } else { // 其余的titleButton被点击时居中显示
        [self.titleScrollView setContentOffset:CGPointMake((pageNum - 1.5) * titleButtonWidth, 0) animated:YES];
    }
    
    // 通过点击titleButton的方式（非滑动）切换contentScrollView
    if (!self.isSlided) {
        // 目标位置的contentOffset.x
        CGFloat destinationContentOffsetX = pageNum * self.contentScrollView.width;
        // 起始位置的contentOffset.x
        CGFloat oldContentOffsetX = self.oldOffsetX;
        // 滑动方向
        CGFloat direction = destinationContentOffsetX - oldContentOffsetX;
        
        if (direction > 0) { // 向左滑动
            for (; oldContentOffsetX < destinationContentOffsetX; oldContentOffsetX+=self.contentScrollView.width) {
                self.contentScrollView.contentOffset = CGPointMake(self.contentScrollView.contentOffset.x + self.contentScrollView.width, 0);
                [self scrollViewDidEndDecelerating:self.contentScrollView];
                _pageNum += 1;
            }
        } else if (direction < 0) { // 向右滑动
            for (; oldContentOffsetX > destinationContentOffsetX; oldContentOffsetX-=self.contentScrollView.width) {
                self.contentScrollView.contentOffset = CGPointMake(self.contentScrollView.contentOffset.x - self.contentScrollView.width, 0);
                [self scrollViewDidEndDecelerating:self.contentScrollView];
                _pageNum -= 1;
            }
        }
    }
    
    _pageNum = pageNum;
    
}

/** 初始化内容部分 contentScrollView */
- (void)setupContentScrollView {
    // 创建一个scrollView
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame), self.view.width, self.view.height)];
    scroll.pagingEnabled = YES;
    scroll.bounces = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.contentSize = CGSizeMake(self.view.width * self.titleButtonArray.count, 0);
    [self.view addSubview:scroll];
    _contentScrollView = scroll;
    scroll.delegate = self;
    
    // 创建三个UIView到scroll上，并添加到循环使用池数组
    // 第一个view上暂时不显示
    UIView *one = [[UIView alloc] initWithFrame:CGRectMake(-self.view.width, 0, self.view.width, self.view.height)];
    [scroll addSubview:one];
    
    // 第二个view上显示titleButtonArray中的第一个button对应controller的view
    UIView *two = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    CBTitleButton *firstButton = self.titleButtonArray[0];
    [two addSubview:firstButton.viewController.view];
    [scroll addSubview:two];
    
    // 第三个view上显示titleButtonArray中的第二个button对应controller的view
    UIView *three = [[UIView alloc] initWithFrame:CGRectMake(self.view.width, 0, self.view.width, self.view.height)];
    CBTitleButton *secondButton = self.titleButtonArray[1];
    [three addSubview:secondButton.viewController.view];
    [scroll addSubview:three];
    
    // 添加到循环使用池数组reuseArray
    self.reuseArray = [NSMutableArray array];
    [self.reuseArray addObject:one];
    [self.reuseArray addObject:two];
    [self.reuseArray addObject:three];
}

#pragma mark - ContentScrollViewDelegate方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat count = ABS(((scrollView.contentOffset.x - self.oldOffsetX) / scrollView.width));
    
    // 若滑动contentScrollView过快则连续滑动多页，故调用多次scrollViewDidEndDecelerating
    if (count > 1 && self.isSlided) {
        for (int i = 0; i < (int)count; i++) {
            [self scrollViewDidEndDecelerating:scrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    /* 该方法主要处理如下事务:
     判断滑动方向
     复用contentScrollView内部的三个view
     记录contentOffset.x到self.oldOffsetXXXX
     更改titleScrollView的titleButton状态（selected,frame等）
     */
    CGFloat currentContentOfffsetX = scrollView.contentOffset.x;
    
    if ((currentContentOfffsetX - self.oldOffsetX) > 0) { // 向左滑动
        self.tmpView = [self.reuseArray firstObject];
        [self.reuseArray removeObject:self.tmpView];
        [[self.tmpView.subviews firstObject] removeFromSuperview];
        
        // 此判断防止数组越界
        if (self.pageNum + 2 < self.titleButtonArray.count) {
            CBTitleButton *btn = self.titleButtonArray[self.pageNum + 2];
            [self.tmpView addSubview:btn.viewController.view];
        }
        self.tmpView.frame = CGRectMake(CGRectGetMaxX(((UIView *)[self.reuseArray lastObject]).frame), 0, scrollView.width, scrollView.height);
        [self.reuseArray addObject:self.tmpView];
        
        self.oldOffsetX = ((int)(currentContentOfffsetX / scrollView.width)) * scrollView.width;
        
    } else if ((self.oldOffsetX - currentContentOfffsetX) > 0) { // 向右滑动
        self.tmpView = [self.reuseArray lastObject];
        [self.reuseArray removeObject:self.tmpView];
        [[self.tmpView.subviews lastObject] removeFromSuperview];
        
        // 此判断防止数组越界
        if (self.pageNum - 2 >= 0) {
            CBTitleButton *btn = self.titleButtonArray[self.pageNum - 2];
            [self.tmpView addSubview:btn.viewController.view];
        }
        
        self.tmpView.frame = CGRectMake(((UIView *)[self.reuseArray firstObject]).x - scrollView.width, 0, scrollView.width, scrollView.height);
        [self.reuseArray insertObject:self.tmpView atIndex:0];
        
        self.oldOffsetX = ((int)((currentContentOfffsetX + scrollView.width - 1) / scrollView.width)) * scrollView.width;
    }
    
    // 当通过手动滑动contentScrollView时调节titleScrollView的button状态
    if (self.isSlided) {
        CBTitleButton *btn = self.titleButtonArray[(int)(self.oldOffsetX / scrollView.width)];
        [self titleButtonClicked:btn];
        self.isSlided = NO;
    }
}

// 手动滑动contentScrollView时触发该方法，点击titleButton切换contentScrollView时不会触发
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    self.isSlided = YES;
}

@end
