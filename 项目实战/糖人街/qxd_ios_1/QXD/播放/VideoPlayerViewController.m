//
//  VideoPlayerViewController.m
//  播放器Demo
//
//  Created by WJM on 16/2/1.
//  Copyright © 2016年 WJM. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "KMPMoviePlayerController.h"
#import "UIView+Extension.h"

#define kSMainWidth [UIScreen mainScreen].bounds.size.width
#define kSMainHeight [UIScreen mainScreen].bounds.size.height
#define kNavViewHeight 64
#define kVideoViewHeight kSMainWidth*(9.0/16.0)
#define kVideoViewMaxBottom kSMainWidth*(9.0/16.0)+kNavViewHeight

@interface VideoPlayerViewController ()<UIScrollViewDelegate,KMPMoviePlayerControllerDelegate>
{
    CGFloat scrollViewOffY;
    CGFloat lastPosition;
}
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIView *navView;

@property (nonatomic, strong) KMPMoviePlayerController *videoController;

@property (strong, nonatomic) UIScrollView *mainScrollView;

@end

@implementation VideoPlayerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    scrollViewOffY = 0;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.videoController.view];
    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.navView];
    [self.navView addSubview:self.button];
    
    [self.view bringSubviewToFront:self.navView];

    
    for (int i=0; i<25; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, i*50, kSMainWidth, 40)];
        label.text = [NSString stringWithFormat:@"第%d个label",i];
        label.textColor = [UIColor greenColor];
        label.textAlignment = NSTextAlignmentCenter;
        [_mainScrollView addSubview:label];
    }
    
    NSURL *url = [NSURL URLWithString:@"http://video.szzhangchu.com/laohuangguachaohuajiaB.mp4"];
    _videoController.contentURL = url;
    _videoController.defaultImageUrl = @"http://images.tiantian.com/upload/Cosmetics/cd2/8tt11-19da4-3.jpg";
}
#pragma mark - Property
- (KMPMoviePlayerController *)videoController
{
    if (!_videoController) {
        _videoController = [[KMPMoviePlayerController alloc] initWithFrame:CGRectMake(0, kNavViewHeight, kSMainWidth, kVideoViewHeight)];
        _videoController.delegate = self;
    }
    return _videoController;
}
- (UIView *)navView
{
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSMainWidth, kNavViewHeight)];
        _navView.backgroundColor = [UIColor whiteColor];
    }
    return _navView;
}
- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.videoController.view.bottom, kSMainWidth, kSMainHeight-kVideoViewMaxBottom)];
        _mainScrollView.delegate = self;
        _mainScrollView.backgroundColor = [UIColor yellowColor];
        _mainScrollView.contentSize = CGSizeMake(kSMainWidth, kSMainHeight*2);
    }
    return _mainScrollView;
}
- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton new];
        _button.frame = CGRectMake(0, 20, 60, 44);
        [_button setTitle:@"返回" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(dealBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ///!!!!!!如果类中有多个scrollView  则此处需要判断scrollView
    
    if (_videoController.isPlaying) {
        
        [self setVideoViewOriginalFrame];
        
    }else{
        // 保证是垂直方向滚动，而不是水平滚动
        if (scrollView.contentOffset.x == 0) {
            
            CGFloat y = scrollView.contentOffset.y;
            // 这个是非常关键的变量，用于记录上一次滚动到哪个偏移位置
            static CGFloat previousOffsetY = 0;
            // 向上滚动
            if (y > 0) {
                if (self.videoController.view.bottom <= kNavViewHeight) {
                    return;
                }
                // 计算两次回调的滚动差:fabs(y - previousOffsetY)值
                CGFloat bottom = self.videoController.view.bottom - fabs(y - previousOffsetY);
                bottom = bottom >= 0 ? bottom : 0;
                self.videoController.view.bottom = bottom;
                
                _mainScrollView.frame = CGRectMake(0, self.videoController.view.bottom,
                                                  scrollView.width,
                                                  kSMainHeight-self.videoController.view.bottom);
                previousOffsetY = y;
                // 如果一直不松手滑动，重复向上向下滑动时，如果没有设置还原为0，则会出现马上到顶的情况。
                if (previousOffsetY >= self.videoController.view.height) {
                    previousOffsetY = 0;
                }
            }
            // 向下滚动
            else if (y < 0) {
                if (self.videoController.view.originY >= 64) {
                    return;
                }
                CGFloat bottom = self.videoController.view.bottom + fabs(y);
                bottom = (bottom <= kVideoViewMaxBottom) ? bottom : kVideoViewMaxBottom;
                self.videoController.view.bottom = bottom;
                
                _mainScrollView.frame = CGRectMake(0,
                                                  self.videoController.view.bottom,
                                                  scrollView.width,
                                                  kSMainHeight - self.videoController.view.bottom);
            }
        }
    }
}
///改变VideoView.originY
- (void)setVideoViewOriginY:(CGFloat)originY
{
    _videoController.view.originY = originY;
}
///VideoView原始Frame
- (void)setVideoViewOriginalFrame
{
    if (self.videoController.view.originY != 64) {
        //禁止视频播放时,调用改变视频视图Frame的方法
        if (!_videoController.isPlaying) {
            [UIView animateWithDuration:0.5 animations:^{
                self.videoController.view.frame = CGRectMake(0, 64, kSMainWidth, kVideoViewHeight);
                self.mainScrollView.frame = CGRectMake(0, self.videoController.view.bottom, kSMainWidth, kSMainHeight-64);
            }];
        }
    }
}
-(void)KMPMoviePlayerScreenState:(BOOL)fullScreen
{
    ///当切换为半屏状态时  回复为初始状态 当滑动 tableView时 会判断self.videoController.view的归属 此处无需判断
    if (!fullScreen) {
        [self setVideoViewOriginalFrame];
    }
}
- (void)KMPMoviePlaybackState:(MPMoviePlaybackState)State
{
    if (State == MPMoviePlaybackStatePlaying) {
        [UIView animateWithDuration:0.5 animations:^{
            self.videoController.view.frame = CGRectMake(0, 64, kSMainWidth, kVideoViewHeight);
            self.mainScrollView.frame = CGRectMake(0, self.videoController.view.bottom, kSMainWidth, kSMainHeight-64);
        }];
    }
}
#pragma mark - Action
- (void)dealBtn
{
    [self dismissViewControllerAnimated:YES completion:^{
        [_videoController dismiss];
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
