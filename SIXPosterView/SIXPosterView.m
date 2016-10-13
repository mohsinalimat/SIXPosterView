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

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation SIXPosterView

+ (instancetype)posterViewWithImages:(NSArray *)images {
    SIXPosterView *posterView = [[self alloc] init];
    posterView.images = images;
    return posterView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = 0;
        _duration = 2;
        _automaticScrollEnabled = NO;
        _pageStyle = SIXPosterViewPageStyleCustom;
        [self setupViews];
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
}

- (void)setImages:(NSArray *)images {
    _images = images;
    if (_images.count == 0) {
        return;
    }
    [self updateImages];
    [self updatePageView];
    if (_images.count > 1) {
        [self createTimer];
    }
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
    
    [self setImage:self.middleView withImage:self.images[middleIndex]];
    [self setImage:self.leftView withImage:self.images[leftIndex]];
    [self setImage:self.rightView withImage:self.images[rightIndex]];
}

- (void)setImage:(UIImageView *)imageView withImage:(id)image {
    if ([image isKindOfClass:[UIImage class]]) {
        imageView.image = image;
    } else if ([image isKindOfClass:[NSURL class]]) {
        [imageView sd_setImageWithURL:image placeholderImage:_placeholderImage];
    } else if ([image isKindOfClass:[NSString class]]) {
        if ([image containsString:@"http"]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:self.placeholderImage];
        } else if ([image hasSuffix:@"png"] || [image hasSuffix:@"jpg"]) {
            imageView.image = [UIImage imageWithContentsOfFile:image];
        } else {
            imageView.image = [UIImage imageNamed:image];
        }
    }
}

- (void)updatePageView {
    if (_pageControl) {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
    if (_pageView) {
        [_pageView removeFromSuperview];
        _pageView = nil;
    }
    
    if (_pageStyle == SIXPosterViewPageStyleCustom) {
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
    if (_automaticScrollEnabled == NO && _timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(switchImage) userInfo:nil repeats:YES];
    }
}

- (void)switchImage {
    [_scrollView setContentOffset:CGPointMake(2*_scrollView.frame.size.width, 0) animated:YES];
}

- (UIImageView *)createImageView {
    UIImageView *view = [UIImageView new];
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction:)];
    [view addGestureRecognizer:tap];
    return view;
}

- (void)tapImageAction:(UITapGestureRecognizer *)tap {
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

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    [_timer invalidate];
    _timer = nil;
    [self createTimer];
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
    [self createTimer];
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

@end
