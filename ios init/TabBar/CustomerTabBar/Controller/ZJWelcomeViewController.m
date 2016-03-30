//
//  ZJWelcomeViewController.m
//  loveinvest
//
//  Created by babbage on 16/3/18.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ZJWelcomeViewController.h"
#import "ZJTabBarViewController.h"

@interface ZJWelcomeViewController ()
@property(nonatomic,strong) UIScrollView *scrollView;
@end

@implementation ZJWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}
-(void)creatUI{
    NSArray *imageNameArray = @[@"welcome1",@"welcome2",@"welcome3"];
    for (int i = 0; i < imageNameArray.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WINSIZEWIDTH * i, 0, WINSIZEWIDTH, WINSIZEHEIGHT)];
        imageView.image = [UIImage imageNamed:imageNameArray[i]];
        [self.scrollView addSubview:imageView];
        // 添加跳转到tabbar
        if (i == imageNameArray.count - 1) {
            UIButton *scaleBtn = [[UIButton alloc] initWithFrame:imageView.frame];
            [scaleBtn addTarget:self action:@selector(scanle) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:scaleBtn];
            scaleBtn.backgroundColor = [UIColor clearColor];
        }
    }
    [self.view addSubview:self.scrollView];
}
-(void)scanle{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[ZJTabBarViewController alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 懒加载 ---
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WINSIZEWIDTH, WINSIZEHEIGHT)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(WINSIZEWIDTH * 3, WINSIZEHEIGHT);
        _scrollView.userInteractionEnabled = YES;
    }
    return _scrollView;
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
