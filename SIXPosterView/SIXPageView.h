//
//  SIXPageView.h
//  SIXPosterView
//
//  Created by liujiliu on 16/9/27.
//  Copyright © 2016年 six. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SIXPageViewClickBlock)(NSInteger index);

@interface SIXPageView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) NSTimeInterval duration;

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled;

- (void)setClickPageBlock:(SIXPageViewClickBlock)block;

- (void)setNormalColor:(UIColor *)norColor andSelectedColor:(UIColor *)selColor;

@end
