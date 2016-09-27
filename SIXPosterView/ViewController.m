//
//  ViewController.m
//  SIXPosterView
//
//  Created by liujiliu on 16/9/26.
//  Copyright © 2016年 six. All rights reserved.
//

#import "ViewController.h"
#import "SIXPosterView.h"

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
    
    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:5];
    for (int i=0; i<5; i++) {
        [mutArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"image%d", i+80]]];
    }
    _posterView = [[SIXPosterView alloc] initWithImages:mutArr.copy];
    _posterView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.bounds.size.width, 250);
    _posterView.duration = 2;
    [_posterView setClickImageBlock:^(NSInteger index) {
        NSLog(@"%ld", index);
    }];
    [self.view addSubview:_posterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
