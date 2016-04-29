//
//  GuideViewController.m
//  QXD
//
//  Created by zhujie on 平成28-01-04.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatScrollView];
}
-(void)creatScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(3*SCREEN_W, SCREEN_H);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.contentOffset = CGPointZero;
    for (int i = 1 ; i < 4 ; i++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((i - 1)*SCREEN_W, 0, SCREEN_W, SCREEN_H)];
        imageV.userInteractionEnabled = YES;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"引导页%d.png",i]];
        [imageV setImage:image];
        [scrollView addSubview:imageV];
        if (i == 3) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100*PROPORTION_WIDTH, SCREEN_H - 230, 170, 50)];
//            [button setTitle:@"开始体验" forState:UIControlStateNormal];
            [imageV addSubview:button];
            [button addTarget:self action:@selector(GoTo) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [self.view addSubview:scrollView];
}
-(void)GoTo{
    [UIView animateWithDuration:1 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [delegate creatMainViewController];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
