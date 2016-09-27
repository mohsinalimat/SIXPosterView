//
//  SIXPosterView.m
//  SIXPosterView
//
//  Created by liujiliu on 16/9/26.
//  Copyright © 2016年 six. All rights reserved.
//

#import "SIXPosterView.h"
#import "SIXPageView.h"


@interface SIXPosterView () <UIScrollViewDelegate> {
    SIXPosterViewClickBlock _clickImageBlock;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) SIXPageView *pageView;

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
    _duration = 1;
    [self createHierarchy];
    return self;
}

- (void)createHierarchy {
    [self addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.middleView];
    [self.scrollView addSubview:self.leftView];
    [self.scrollView addSubview:self.rightView];
    
    [self addSubview:self.pageView];
    [self createTimer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    _scrollView.frame = rect;
    _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.contentSize = CGSizeMake(rect.size.width * 3, 0);
    _pageView.frame = CGRectMake(0, 0, 200, 30);
    _pageView.center = CGPointMake(self.center.x, rect.size.height - 25);
    
    _leftView.frame = rect;
    rect.origin.x = rect.size.width;
    _middleView.frame = rect;
    rect.origin.x = 2*rect.size.width;
    _rightView.frame = rect;
    
    [_scrollView setContentOffset:CGPointMake(rect.size.width, 0)];
}

- (void)createTimer {
    if (_timer) {
        [self.timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(cutImage) userInfo:nil repeats:YES];
}

- (void)cutImage {
    [_scrollView setContentOffset:CGPointMake(2*_scrollView.frame.size.width, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:_scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger number = scrollView.contentOffset.x/scrollView.frame.size.width;
    if (number == 0) {
        _currentIndex--;
    }else if (number == 2) {
        _currentIndex++;
    }else {
        return;
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0)];
    _middleView.image = [_images objectAtIndex:_currentIndex%_images.count];
    _leftView.image = [_images objectAtIndex:(_currentIndex-1)%_images.count];
    _rightView.image = [_images objectAtIndex:(_currentIndex+1)%_images.count];
    _pageView.currentPage = _currentIndex%_images.count;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_opened) {
       [self createTimer];
    }
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

- (SIXPageView *)pageView {
    if (!_pageView) {
        _pageView = [SIXPageView new];
//        _pageView.backgroundColor = [UIColor clearColor];
        _pageView.pageNumber = _images.count;
        __weak typeof(self)weak_self = self;
        [_pageView setClickPageBlock:^(NSInteger index) {
            _currentIndex = index;
            weak_self.middleView.image = [weak_self.images objectAtIndex:_currentIndex%_images.count];
            weak_self.leftView.image = [weak_self.images objectAtIndex:(_currentIndex-1)%_images.count];
            weak_self.rightView.image = [weak_self.images objectAtIndex:(_currentIndex+1)%_images.count];
        }];
    }
    return _pageView;
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

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    [_timer invalidate];
    [self createTimer];
}

- (UIImageView *)createImageView {
    UIImageView *view = [UIImageView new];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [view addGestureRecognizer:tap];
    return view;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (_clickImageBlock) {
        UIImageView *imageView = (UIImageView *)tap.view;
        NSInteger index = [_images indexOfObject:imageView.image];
        _clickImageBlock(index);
    }
}

- (void)setClickImageBlock:(SIXPosterViewClickBlock)block {
    _clickImageBlock = [block copy];
    _middleView.userInteractionEnabled =
    _leftView.userInteractionEnabled =
    _rightView.userInteractionEnabled = YES;
}

- (void)setOpened:(BOOL)opened {
    _opened = opened;
    if (opened == NO) {
        [self.timer invalidate];
    } else {
        [self createTimer];
    }
}

@end
