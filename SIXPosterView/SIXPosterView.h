//
//  SIXPosterView.h
//  SIXPosterView
//
//  Created by liujiliu on 16/9/26.
//  Copyright © 2016年 six. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^SIXPosterViewClickBlock)(NSInteger index);

@interface SIXPosterView : UIView

/** images.count至少为3 */
- (instancetype)initWithImages:(NSArray<UIImage *> *)images;

- (void)setClickImageBlock:(SIXPosterViewClickBlock)block;

@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, assign, getter=isOpened) BOOL opened;

@end
