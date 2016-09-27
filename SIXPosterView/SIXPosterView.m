//
//  SIXPosterView.m
//  SIXPosterView
//
//  Created by liujiliu on 16/9/26.
//  Copyright © 2016年 six. All rights reserved.
//

#import "SIXPosterView.h"


static NSInteger const SIXPosterView_tag = 1000;

@interface SIXPosterView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIImageView *leftView;

@property (nonatomic, strong) UIImageView *middleView;

@property (nonatomic, strong) UIImageView *rightView;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation SIXPosterView

- (instancetype)initWithImages:(NSArray<UIImage *> *)images {
    self = [super init];
    if (!self) return nil;
    
    _images = images;
    _currentIndex = 0;
    [self createHierarchy];
    return self;
}

- (void)createHierarchy {
    [self addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.middleView];
    [self.scrollView addSubview:self.leftView];
    [self.scrollView addSubview:self.rightView];
    
    [self addSubview:self.pageControl];
    [self createTimer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    _scrollView.frame = rect;
    _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.contentSize = CGSizeMake(rect.size.width * 3, 0);
    _pageControl.center = CGPointMake(self.center.x, rect.size.height - 10);
    
    _leftView.frame = rect;
    rect.origin.x = rect.size.width;
    _middleView.frame = rect;
    rect.origin.x = 2*rect.size.width;
    _rightView.frame = rect;
    
    [_scrollView setContentOffset:CGPointMake(rect.size.width, 0)];
}

- (void)createTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cutImage) userInfo:nil repeats:YES];
}

- (void)cutImage {
    [_scrollView setContentOffset:CGPointMake(2*_scrollView.frame.size.width, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:_scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == 0) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0)];
        _currentIndex--;
        _middleView.image = [_images objectAtIndex:_currentIndex%_images.count];
        _leftView.image = [_images objectAtIndex:(_currentIndex-1)%_images.count];
        _rightView.image = [_images objectAtIndex:(_currentIndex+1)%_images.count];
        _pageControl.currentPage = _currentIndex%_images.count;
    }
    if (scrollView.contentOffset.x == 2*scrollView.frame.size.width) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0)];
        _currentIndex++;
        _middleView.image = [_images objectAtIndex:_currentIndex%_images.count];
        _leftView.image = [_images objectAtIndex:(_currentIndex-1)%_images.count];
        _rightView.image = [_images objectAtIndex:(_currentIndex+1)%_images.count];
        _pageControl.currentPage = _currentIndex%_images.count;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self createTimer];
}

#pragma mark - lazy load
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator =
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
        _pageControl.numberOfPages = _images.count;
    }
    return _pageControl;
}

- (UIImageView *)middleView {
    if (!_middleView) {
        _middleView = [self createImageView];
        _middleView.image = _images[0];
    }
    return _middleView;
}

- (UIImageView *)leftView {
    if (!_leftView) {
        _leftView = [self createImageView];
        _leftView.image = _images.lastObject;
    }
    return _leftView;
}

- (UIImageView *)rightView {
    if (!_rightView) {
        _rightView = [self createImageView];
        _rightView.image = _images[1];
    }
    return _rightView;
}

- (UIImageView *)createImageView {
    UIImageView *view = [UIImageView new];
    return view;
}

@end
