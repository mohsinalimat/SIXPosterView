//
//  SIXPosterView.m
//  SIXPosterView
//
//  Created by liujiliu on 16/9/26.
//  Copyright © 2016年 six. All rights reserved.
//

#import "SIXPosterView.h"
#import <UIImageView+WebCache.h>


@interface SIXPosterView () <UIScrollViewDelegate> {
    SIXPosterViewClickBlock _clickImageBlock;
}

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIImageView *leftView;

@property (nonatomic, weak) UIImageView *middleView;

@property (nonatomic, weak) UIImageView *rightView;

@property (nonatomic, weak) UIImageView *backgroundImageView;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation SIXPosterView

+ (instancetype)posterViewWithImages:(NSArray *)images {
    return [[self alloc] initWithImages:images];
}

- (instancetype)initWithImages:(NSArray *)images
{
    self = [super init];
    if (self) {
        _images = images;
        _currentIndex = 0;
        _duration = 2;
        _automaticScrollEnabled = NO;
        [self setupViews];
        if (_images.count > 1) {
            [self createTimer];
        }
    }
    return self;
}

- (void)setupViews {
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.showsVerticalScrollIndicator =
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    [self addSubview: scrollView];
    _scrollView = scrollView;
   
    UIImageView *middleView = [self createImageView];
    [scrollView addSubview:middleView];
    _middleView = middleView;
    
    UIImageView *leftView = [self createImageView];
    [scrollView addSubview:leftView];
    _leftView = leftView;
    
    UIImageView *rightView = [self createImageView];
    [scrollView addSubview:rightView];
    _rightView = rightView;
    
    [self updateImages];
    [self updatePageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    _scrollView.frame = rect;
    _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.contentSize = CGSizeMake(rect.size.width * 3, 0);
    
    if (_pageStyle == SIXPosterViewPageStyleCustom) {
        _pageView.frame = CGRectMake(0, 0, 200, 30);
        _pageView.center = CGPointMake(self.center.x, rect.size.height - 25);
    }else {
        _pageControl.frame = CGRectMake(0, 0, 200, 30);
        _pageControl.center = CGPointMake(self.center.x, rect.size.height - 25);
    }
    
    if (_backgroundImageView) {
        _backgroundImageView.frame = rect;
    }
    
    _leftView.frame = rect;
    rect.origin.x = rect.size.width;
    _middleView.frame = rect;
    rect.origin.x = 2*rect.size.width;
    _rightView.frame = rect;
    
    [_scrollView setContentOffset:CGPointMake(rect.size.width, 0)];
}

- (void)updateImages {
    NSInteger middleIndex = self.currentIndex%self.images.count;
    NSInteger leftIndex = (self.currentIndex-1)%self.images.count;
    NSInteger rightIndex = (self.currentIndex+1)%self.images.count;
    
    if ([self.images.firstObject isKindOfClass:[UIImage class]]) {
        self.middleView.image = self.images[middleIndex];
        self.leftView.image = self.images[leftIndex];
        self.rightView.image = self.images[rightIndex];
    } else if ([_images.firstObject isKindOfClass:[NSURL class]]) {
        [self.middleView sd_setImageWithURL:self.images[middleIndex] placeholderImage:_placeholderImage];
        [self.leftView sd_setImageWithURL:self.images[leftIndex] placeholderImage:_placeholderImage];
        [self.rightView sd_setImageWithURL:self.images[rightIndex] placeholderImage:_placeholderImage];
    } else if ([self.images.firstObject isKindOfClass:[NSString class]]) {
        if ([self.images.firstObject containsString:@"http"]) {
            [self.middleView sd_setImageWithURL:[NSURL URLWithString:self.images[middleIndex]] placeholderImage:_placeholderImage];
            [self.leftView sd_setImageWithURL:[NSURL URLWithString:self.images[leftIndex]] placeholderImage:_placeholderImage];
            [self.rightView sd_setImageWithURL:[NSURL URLWithString:self.images[rightIndex]] placeholderImage:_placeholderImage];
        } else {
            self.middleView.image = [UIImage imageNamed:self.images[middleIndex]];
            self.leftView.image = [UIImage imageNamed:self.images[leftIndex]];
            self.rightView.image = [UIImage imageNamed:self.images[rightIndex]];
        }
    }
}

- (void)updatePageView {
    if (_pageStyle == SIXPosterViewPageStyleCustom) {
        if (_pageControl) {
            [_pageControl removeFromSuperview];
            _pageControl = nil;
        }
        SIXPageView *pageView = [SIXPageView new];
        pageView.pageNumber = _images.count;
        pageView.duration = MIN(0.8f, _duration*0.5);
        [self addSubview:pageView];
        _pageView = pageView;
        
        __weak typeof(self)weak_self = self;
        [pageView setClickPageBlock:^(NSInteger index) {
            weak_self.currentIndex = index;
            [weak_self updateImages];
        }];
        
    } else {
        if (_pageView) {
            [_pageView removeFromSuperview];
            _pageView = nil;
        }
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = _images.count;
        pageControl.currentPage = 0;
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    [self updateImages];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (_backgroundImageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self insertSubview:imageView atIndex:0];
        _backgroundImageView = imageView;
    }
    _backgroundImageView.image = backgroundImage;
}

- (void)createTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(switchImage) userInfo:nil repeats:YES];
}

- (void)switchImage {
    [_scrollView setContentOffset:CGPointMake(2*_scrollView.frame.size.width, 0) animated:YES];
}

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    [self createTimer];
}

- (UIImageView *)createImageView {
    UIImageView *view = [UIImageView new];
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [view addGestureRecognizer:tap];
    return view;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (_clickImageBlock) {
        _clickImageBlock(self.currentIndex);
    }
    if ([self respondsToSelector:@selector(clickImage:atIndex:)]) {
        [self performSelector:@selector(clickImage:atIndex:) withObject:self withObject:@(_currentIndex%_images.count)];
    }
}

- (void)setClickImageBlock:(SIXPosterViewClickBlock)block {
    _clickImageBlock = [block copy];
}

- (void)setAutomaticScrollEnabled:(BOOL)automaticScrollEnabled {
    _automaticScrollEnabled = automaticScrollEnabled;
    if (automaticScrollEnabled == YES) {
        [self.timer invalidate];
        self.timer = nil;
    } else {
        [self createTimer];
    }
}

- (void)setPageStyle:(SIXPosterViewPageStyle)pageStyle {
    if (_pageStyle == pageStyle) {
        return;
    }
    _pageStyle = pageStyle;
    [self updatePageView];
    [self setNeedsDisplay];
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
    [self updateImages];
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0)];
    if (_pageStyle == SIXPosterViewPageStyleCustom) {
        _pageView.currentPage = _currentIndex%_images.count;
    }else {
        _pageControl.currentPage = _currentIndex%_images.count;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_automaticScrollEnabled == NO) {
        [self createTimer];
    }
}

@end
