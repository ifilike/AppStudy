# 通知 本播放器不能支持iOS9 以上设备 
推荐 [kxmovie](https://github.com/kolyvan/kxmovie)  <p>[修改说明](http://www.cocoachina.com/bbs/read.php?tid=145575)</p>     <p>[修改代码](https://github.com/kinglonghuang/kxmovie)</p>
<p>2015'11'12 喧</p>



# KrVideoPlayerPlus
根据36Kr开源的[KRVideoPlayer](https://github.com/36Kr-Mobile/KRVideoPlayer) 进行修改和补充实现一个轻量级的视频播放器，满足大部分视频播放需求


![展示图片](https://github.com/835239104/KrVideoPlayerPlus/blob/master/KrVideo.gif?raw=true)
#必要框架
<p>MediaPlayer.framework</p>
<p>AVFoundation.framework</p>

#咋使

在需要使用的控制器内引入  <pre><code>#import "KrVideoPlayerController.h"</code></pre>

```objective-c
@interface ViewController ()
@property (nonatomic, strong) KrVideoPlayerController  *videoController;
@end

@implementation ViewController

- (void)viewDidLoad {
   [super viewDidLoad];
// Do any additional setup after loading the view, typically from a nib.
   [self playVideo];
}
- (void)playVideo{
  NSURL *url = [NSURL URLWithString:@"http://krtv.qiniudn.com/150522nextapp"];
  [self addVideoPlayerWithURL:url];
}

- (void)addVideoPlayerWithURL:(NSURL *)url{
  if (!self.videoController) {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 64, width, width*(9.0/16.0))];
    __weak typeof(self)weakSelf = self;
    [self.videoController setDimissCompleteBlock:^{
      weakSelf.videoController = nil;
    }];
    [self.videoController setWillBackOrientationPortrait:^{
      [weakSelf toolbarHidden:NO];
    }];
    [self.videoController setWillChangeToFullscreenMode:^{
      [weakSelf toolbarHidden:YES];
    }];
    [self.view addSubview:self.videoController.view];
  }
    self.videoController.contentURL = url;
}
```

#小知识
*隐藏navigation tabbar 电池栏
*View controller-based status bar appearance    NO
``` objective-c
- (void)toolbarHidden:(BOOL)Bool{
    self.navigationController.navigationBar.hidden = Bool;
    self.tabBarController.tabBar.hidden = Bool;
    [[UIApplication sharedApplication] setStatusBarHidden:Bool withAnimation:UIStatusBarAnimationFade];
}
```



