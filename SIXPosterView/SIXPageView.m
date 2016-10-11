//
//  SIXPageView.m
//  SIXPosterView
//
//  Created by liujiliu on 16/9/27.
//  Copyright © 2016年 six. All rights reserved.
//

#import "SIXPageView.h"


#define SIXPageViewNormalImage [UIImage imageNamed:@"normal_pageControl_icon"]
#define SIXPageViewSelectedImage [UIImage imageNamed:@"choose_pageControl_icon"]
static CGFloat PageMargin = 10;
static NSInteger const PageViewTag = 1000;

@interface SIXPageView ()
{
    UIColor *_normalColor;
    UIColor *_selectedColor;
    SIXPageViewClickBlock _clickBlock;
    BOOL _layoutSubviewsOrNo;
}


@end

@implementation SIXPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _duration = 0.8;
        _layoutSubviewsOrNo = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_layoutSubviewsOrNo) {
        self.layer.cornerRadius = self.bounds.size.height/2;
        [self becomeNormal];
    }
    _layoutSubviewsOrNo = YES;
}

- (UIImageView *)createImageView {
    UIImageView *imageView = [UIImageView new];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [imageView addGestureRecognizer:tap];
    return imageView;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    self.currentPage = tap.view.tag - PageViewTag;
    if (_clickBlock) {
        _clickBlock(self.currentPage);
    }
}

- (void)setPageNumber:(NSInteger)pageNumber {
    _pageNumber = pageNumber;
    
    for (int i=0; i<pageNumber; i++) {
        UIImageView *imageView = [self createImageView];
        imageView.image = SIXPageViewNormalImage;
        imageView.tag = PageViewTag + i;
        [self addSubview:imageView];
    }
    
    self.currentPage = 0;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    [UIView animateWithDuration:_duration*0.4f animations:^{
        [self becomeNormal];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:_duration*0.6f animations:^{
            [self becomeSelected:currentPage];
        }];
    }];
    
    _currentPage = currentPage;
}

- (void)setNormalColor:(UIColor *)norColor andSelectedColor:(UIColor *)selColor {
    _normalColor = norColor;
    _selectedColor = selColor;
}

- (void)becomeNormal {
    UIImage *image = SIXPageViewNormalImage;
    CGFloat pageW = image.size.width;
    CGFloat pageH = image.size.height;
    
    for (int i=0; i<_pageNumber; i++) {
        UIImageView *imageView = [self viewWithTag:i+PageViewTag];
        imageView.image = image;
        imageView.frame = CGRectMake(0, 0, pageW, pageH);
        imageView.center = CGPointMake(i * (pageW+PageMargin) + pageW/2 + (self.bounds.size.width-(_pageNumber*pageW + (_pageNumber-1)*PageMargin))/2, self.bounds.size.height/2);
    }
    _layoutSubviewsOrNo = NO;
}

- (void)becomeSelected:(NSInteger)index {
    UIImage *image = SIXPageViewNormalImage;
    UIImage *selImage = SIXPageViewSelectedImage;
    CGFloat pageW = image.size.width;
    
    for (int i=0; i<_pageNumber; i++) {
        UIImageView *imageView = [self viewWithTag:i+PageViewTag];
        if (i == index) {
            imageView.image = selImage;
            imageView.bounds = CGRectMake(0, 0, selImage.size.width, selImage.size.height);
            imageView.center = CGPointMake(i * (pageW+PageMargin) + pageW/2 + (self.bounds.size.width-(_pageNumber*pageW + (_pageNumber-1)*PageMargin))/2, self.bounds.size.height/2);
            
        } else if (i<index) {
            imageView.center = CGPointMake(imageView.center.x - (selImage.size.width- pageW)/2, self.bounds.size.height/2);
            
        }else if (i>index) {
            imageView.center = CGPointMake(imageView.center.x  + (selImage.size.width- pageW)/2, self.bounds.size.height/2);
        }
    }
    _layoutSubviewsOrNo = NO;
}

- (void)setClickPageBlock:(SIXPageViewClickBlock)block {
    _clickBlock = [block copy];
    for (int i=0; i<_pageNumber; i++) {
        [self viewWithTag:i+PageViewTag].userInteractionEnabled = YES;
    }
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    [super setUserInteractionEnabled:userInteractionEnabled];
    for (int i=0; i<_pageNumber; i++) {
        [self viewWithTag:i+PageViewTag].userInteractionEnabled = userInteractionEnabled;
    }
}
























@end
