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

//@property (nonatomic, strong) UIImageView *leftView;
//
//@property (nonatomic, strong) UIImageView *middleView;
//
//@property (nonatomic, strong) UIImageView *rightView;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SIXPosterView

- (instancetype)initWithImages:(NSArray<UIImage *> *)images {
    self = [super init];
    if (!self) return nil;
    
    _images = images;
    [self createHierarchy];
    return self;
}

- (void)createHierarchy {
    [self addSubview:self.scrollView];
    
    for (NSInteger i=0; i<_images.count; i++) {
        UIImageView *imageView = [self createImageView];
        imageView.image = _images[i];
        imageView.tag = SIXPosterView_tag + i;
        [_scrollView addSubview:imageView];
    }
    
    [self addSubview:self.pageControl];
    [self createTimer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _images.count, 0);
    _pageControl.center = CGPointMake(self.center.x, self.bounds.size.height - 10);
    
    for (int i=0; i<_images.count; i++) {
        UIImageView *imageView = [_scrollView viewWithTag:i+SIXPosterView_tag];
        imageView.frame = CGRectMake(i*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    _pageControl.currentPage = index;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self createTimer];
}

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

- (void)createTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cutImage) userInfo:nil repeats:YES];
}

- (void)cutImage {
    NSInteger offNum = _pageControl.currentPage+1;
    if (offNum >= _images.count) {
        [_scrollView setContentOffset:CGPointMake(0, 0)];
    } else {
        [_scrollView setContentOffset:CGPointMake(offNum*_scrollView.bounds.size.width, 0) animated:YES];
    }
}

- (UIImageView *)createImageView {
    UIImageView *view = [UIImageView new];
    return view;
}

@end
