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
    [self.view addSubview:_posterView];
    
//    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
//    _imageView.center = self.view.center;
//    _imageView.clipsToBounds = YES;
//    _imageView.image = [UIImage imageNamed:@"image81"];
//    _imageView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:_imageView];
//    
//    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
//    _label.center = CGPointMake(self.view.center.x, self.view.center.y + 300);
//    _label.text = @"UIViewContentModeScaleToFill";
//    [self.view addSubview:_label];
}

//static NSInteger num = 1;
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.imageView.contentMode = num%3;
//    _label.text = @[@"UIViewContentModeScaleToFill", @"UIViewContentModeScaleAspectFit", @"UIViewContentModeScaleAspectFill"][num%3];
//    num++;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
