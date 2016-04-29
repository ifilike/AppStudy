//
//  KMPMoviePlayerController.m
//  播放器Demo
//
//  Created by WJM on 16/2/1.
//  Copyright © 2016年 WJM. All rights reserved.
//

#import "KMPMoviePlayerController.h"
#import "KVideoPlayerControlView.h"
#import "UIImageView+WebCache.h"
#define kSMainWidth [UIScreen mainScreen].bounds.size.width
#define kSMainHeight [UIScreen mainScreen].bounds.size.height
#define kVideoViewHeight kSMainWidth*(9.0/16.0)

static const CGFloat kVideoPlayerControllerAnimationTimeInterval = 0.3f;

@interface KMPMoviePlayerController ()

@property (nonatomic, strong) KVideoPlayerControlView *videoControl;
@property (nonatomic, assign) BOOL isFullscreenMode;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, strong) NSTimer *durationTimer;
@property (nonatomic, strong) UIView *kSuperView;

@end

@implementation KMPMoviePlayerController
- (void)dealloc
{
    [self cancelObserver];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.isPlaying = NO;
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor whiteColor];
        self.controlStyle = MPMovieControlStyleNone;
        [self.view addSubview:self.videoControl];
        self.videoControl.frame = self.view.bounds;
        [self configObserver];
        [self configControlAction];
    }
    return self;
}

#pragma mark - Override Method
- (void)setContentURL:(NSURL *)contentURL
{
    [self stop];
    [super setContentURL:contentURL];
}
- (void)setDefaultImageUrl:(NSString *)defaultImageUrl
{
    [self.videoControl.weatingImageView sd_setImageWithURL:[NSURL URLWithString:defaultImageUrl]];
}
#pragma mark - Public Method
- (void)showInWindow
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        keyWindow = [[[UIApplication sharedApplication] windows] firstObject];
    }
    [keyWindow addSubview:self.view];
    self.view.alpha = 0.0;
    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeInterval animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)dismiss
{
    [self stopDurationTimer];
    [self stop];
    self.isPlaying = NO;
    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeInterval animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

#pragma mark - Private Method

- (void)configObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackStateDidChangeNotification) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerLoadStateDidChangeNotification) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerReadyForDisplayDidChangeNotification) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMovieDurationAvailableNotification) name:MPMovieDurationAvailableNotification object:nil];
}

- (void)cancelObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configControlAction
{
    [self.videoControl.playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.pauseButton addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.fullScreenButton addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.shrinkScreenButton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [self setProgressSliderMaxMinValues];
    [self monitorVideoPlayback];
}

- (void)onMPMoviePlayerPlaybackStateDidChangeNotification
{
    if (self.playbackState == MPMoviePlaybackStatePlaying) {
        self.videoControl.weatingImageView.hidden = YES;
        self.isPlaying = YES;
        self.videoControl.pauseButton.hidden = NO;
        self.videoControl.playButton.hidden = YES;
        [self startDurationTimer];
        [self.videoControl.indicatorView stopAnimating];
        [self.videoControl autoFadeOutControlBar];
    } else {
        self.isPlaying = NO;
        self.videoControl.pauseButton.hidden = YES;
        self.videoControl.playButton.hidden = NO;
        [self stopDurationTimer];
        if (self.playbackState == MPMoviePlaybackStateStopped) {
            [self.videoControl animateShow];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(KMPMoviePlaybackState:)]) {
        [self.delegate KMPMoviePlaybackState:self.playbackState];
    }
}

- (void)onMPMoviePlayerLoadStateDidChangeNotification
{
    if (self.loadState & MPMovieLoadStateStalled) {
        [self.videoControl.indicatorView startAnimating];
    }
}

- (void)onMPMoviePlayerReadyForDisplayDidChangeNotification
{
    
}

- (void)onMPMovieDurationAvailableNotification
{
    [self setProgressSliderMaxMinValues];
}

- (void)playButtonClick
{
    [self play];
    self.videoControl.weatingImageView.hidden = YES;
    self.videoControl.playButton.hidden = YES;
    self.videoControl.pauseButton.hidden = NO;
}

- (void)pauseButtonClick
{
    [self pause];
    self.videoControl.weatingImageView.hidden = YES;
    self.videoControl.playButton.hidden = NO;
    self.videoControl.pauseButton.hidden = YES;
}

- (void)fullScreenButtonClick
{
    if (self.isFullscreenMode) {
        return;
    }
    self.kSuperView = self.view.superview;
    [self.view removeFromSuperview];
    self.originFrame = self.view.frame;
    [self showInWindow];
    
    CGFloat height = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = [[UIScreen mainScreen] bounds].size.height;
    CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);

    [UIView animateWithDuration:0.3f animations:^{
        self.frame = frame;
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    } completion:^(BOOL finished) {
        self.isFullscreenMode = YES;
        self.videoControl.fullScreenButton.hidden = YES;
        self.videoControl.shrinkScreenButton.hidden = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(KMPMoviePlayerScreenState:)]) {
            [self.delegate KMPMoviePlayerScreenState:YES];
        }

    }];
}

- (void)shrinkScreenButtonClick
{
    if (!self.isFullscreenMode) {
        return;
    }

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setTransform:CGAffineTransformIdentity];
        self.frame = self.originFrame;

    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self.kSuperView addSubview:self.view];
        [self.kSuperView sendSubviewToBack:self.view];
        
        self.isFullscreenMode = NO;
        self.videoControl.fullScreenButton.hidden = NO;
        self.videoControl.shrinkScreenButton.hidden = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(KMPMoviePlayerScreenState:)]) {
            [self.delegate KMPMoviePlayerScreenState:NO];
        }

    }];
}

- (void)setProgressSliderMaxMinValues {
    CGFloat duration = self.duration;
    self.videoControl.progressSlider.minimumValue = 0.f;
    self.videoControl.progressSlider.maximumValue = floor(duration);
}

- (void)progressSliderTouchBegan:(UISlider *)slider {
    [self pause];
    [self.videoControl cancelAutoFadeOutControlBar];
}

- (void)progressSliderTouchEnded:(UISlider *)slider {
    [self setCurrentPlaybackTime:floor(slider.value)];
    [self play];
    [self.videoControl autoFadeOutControlBar];
}

- (void)progressSliderValueChanged:(UISlider *)slider {
    double currentTime = floor(slider.value);
    double totalTime = floor(self.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
}

- (void)monitorVideoPlayback
{
    double currentTime = floor(self.currentPlaybackTime);
    double totalTime = floor(self.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    self.videoControl.progressSlider.value = ceil(currentTime);
}

- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime {
    double minutesElapsed = floor(currentTime / 60.0);
    double secondsElapsed = fmod(currentTime, 60.0);
    NSString *timeElapsedString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesElapsed, secondsElapsed];
    
    double minutesRemaining = floor(totalTime / 60.0);;
    double secondsRemaining = floor(fmod(totalTime, 60.0));;
    NSString *timeRmainingString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesRemaining, secondsRemaining];
    
    self.videoControl.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeElapsedString,timeRmainingString];
}

- (void)startDurationTimer
{
    self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(monitorVideoPlayback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopDurationTimer
{
    [self.durationTimer invalidate];
}

- (void)fadeDismissControl
{
    [self.videoControl animateHide];
}

#pragma mark - Property
- (KVideoPlayerControlView *)videoControl
{
    if (!_videoControl) {
        _videoControl = [[KVideoPlayerControlView alloc] init];
    }
    return _videoControl;
}

- (void)setFrame:(CGRect)frame
{
    [self.view setFrame:frame];
    [self.videoControl setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.videoControl setNeedsLayout];
    [self.videoControl layoutIfNeeded];
}

@end
