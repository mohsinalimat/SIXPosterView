//
//  ViewController.m
//  SIXPosterView
//
//  Created by liujiliu on 16/9/26.
//  Copyright © 2016年 six. All rights reserved.
//

#import "ViewController.h"
#import "SIXPosterView.h"
#import "SIXPageView.h"
#import <UIImageView+WebCache.h>

@interface ViewController ()

@property (nonatomic, strong) SIXPosterView *posterView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"SIXPosterView";
    NSArray *data = @[@"http://img.ads.csdn.net/2016/201609301045384008.jpg", @"http://images.csdn.net/20161010/Andro1_meitu_1.jpg", @"http://img.ads.csdn.net/2016/201610091508399146.jpg", @"", @"", @"http://img.ads.csdn.net/2016/201608121800517211.png", @"http://img.knowledge.csdn.net/upload/base/1474966029376_376.jpg"];
    
    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:5];
    for (int i=0; i<5; i++) {
//        [mutArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"image%d", i+80]]];
        [mutArr addObject:[NSString stringWithFormat:@"image%d", i+80]];
    }
    _posterView = [SIXPosterView posterViewWithImages:data];

    _posterView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.bounds.size.width, 250);
    _posterView.duration = 4;
    _posterView.pageStyle = 0;
    [_posterView setPlaceholderImage:[UIImage imageNamed:@"image87"]];
    __weak typeof(self)weak_self = self;
    [_posterView setClickImageBlock:^(NSInteger index) {
        weak_self.posterView.automaticScrollEnabled = !weak_self.posterView.isAutomaticScrollEnabled;
    }];
    [self.view addSubview:_posterView];
    
    
    SIXPageView *pageView = [[SIXPageView alloc] initWithFrame:CGRectMake(50, 400, 300, 30)];
    pageView.pageNumber = 5;
    pageView.userInteractionEnabled = YES;
    [self.view addSubview:pageView];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _posterView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.bounds.size.width, 250);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
