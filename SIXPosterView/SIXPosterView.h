//
//  SIXPosterView.h
//  SIXPosterView
//
//  Created by liujiliu on 16/9/26.
//  Copyright © 2016年 six. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIXPageView.h"

typedef void (^SIXPosterViewClickBlock)(NSInteger index);

typedef NS_ENUM(NSUInteger, SIXPosterViewPageStyle) {
    SIXPosterViewPageStyleCustom,
    SIXPosterViewPageStyleSystem
};

typedef NS_ENUM(NSUInteger, SIXPosterViewDataStyle) {
    SIXPosterViewDataStyleImage,
    SIXPosterViewDataStyleURL
};

@class SIXPosterView;
@protocol SIXPosterViewDelegate <NSObject>

- (void)clickImage:(SIXPosterView *)posterView atIndex:(NSInteger)index;

@end

@interface SIXPosterView : UIView
/** images中元素  可以是UIImage、NSURL、URLString、本地图片名称 */
+ (instancetype)posterViewWithImages:(NSArray *)images;

- (instancetype)initWithImages:(NSArray *)images;

@property (nonatomic, strong) UIImage *placeholderImage;

- (void)setBackgroundImage:(UIImage *)backgroundImage;

- (void)setClickImageBlock:(SIXPosterViewClickBlock)block;

@property (nonatomic, weak) id <SIXPosterViewDelegate> delegate;

@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, assign) SIXPosterViewPageStyle pageStyle;

/** 可以开关其自动滑动 */
@property (nonatomic, assign, getter=isAutomaticScrollEnabled) BOOL automaticScrollEnabled;

/** 修改页码视图的外形时才需要调用 */
@property (nonatomic, weak) SIXPageView *pageView;
@property (nonatomic, weak) UIPageControl *pageControl;

@end
