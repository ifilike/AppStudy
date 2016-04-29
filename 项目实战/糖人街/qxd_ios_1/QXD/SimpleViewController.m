//
//  SimpleViewController.m
//  TCCloudPlayerSDKTest
//
//  Created by AlexiChen on 15/8/13.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "SimpleViewController.h"

#import "TCCloudPlayerSDK.h"

#import "TCReportEngine.h"

@interface SimpleViewController ()
{
    CGFloat _limitedSeconds;
}

@end

@implementation SimpleViewController

- (BOOL)prefersStatusBarHidden
{
    UIInterfaceOrientation ort = [UIApplication sharedApplication].statusBarOrientation;

    return !UIInterfaceOrientationIsPortrait(ort);
}

- (CGRect)playViewFrame
{
    return CGRectMake(20, 80, self.view.bounds.size.width - 40, 240);
}

- (void)addPlayerView
{
    
    _playerView = [[TCCloudPlayerView alloc] initWithNotFullFrame:[self playViewFrame]];
    [self.view addSubview:_playerView];
    [_playerView changeBottomFullImage:[UIImage imageNamed:@"full.jpg"] notFullImage:[UIImage imageNamed:@"notfull.jpg"]];
    
    __weak typeof(self) ws = self;
    //    _playerView.playbackReadyBlock = ^(void){
    //        [ws playbackReadyBlock];
    //    };
    _playerView.playbackBeginBlock = ^(void){
        [ws playbackBeginBlock];
    };
    
    _playerView.playbackFailedBlock = ^(NSError* error){
        [ws playbackFailedBlock:error];
    };
    _playerView.playbackEndBlock = ^(void){
        [ws playbackEndBlock];
    };
    _playerView.playbackPauseBlock = ^(UIImage* curImg, TCCloudPlayerPauseReason reason){
        [ws playbackPauseBlock:curImg pauseReason:reason];
    };
    
    _playerView.singleClickblock = ^ (BOOL isInFullScreen) {
        
        if (ws.navigationController.topViewController == ws)
        {
            [[UIApplication sharedApplication] setStatusBarHidden:isInFullScreen withAnimation:UIStatusBarAnimationSlide];
            [ws.navigationController setNavigationBarHidden:isInFullScreen animated:YES];
        }
        
    };
    
    _playerView.clickPlaybackViewblock = ^ (BOOL isFullScreen) {
        if (isFullScreen)
        {
            NSLog(@"当前是全屏");
        }
        else
        {
            NSLog(@"当前不是全屏");
        }
    };
    
    _playerView.enterExitFullScreenBlock = ^ (BOOL enterFullScreen) {
        if (ws.navigationController.topViewController == ws)
        {
            [[UIApplication sharedApplication] setStatusBarHidden:enterFullScreen withAnimation:UIStatusBarAnimationSlide];
            [ws.navigationController setNavigationBarHidden:enterFullScreen animated:YES];
            if (enterFullScreen)
            {
                NSLog(@"进入全屏");
            }
            else
            {
                NSLog(@"退出全屏");
            }
        }
    };
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addPlayerView];
}

- (IBAction)playVideo:(id)sender
{
    NSMutableArray* mutlArray = [NSMutableArray array];
    TCCloudPlayerVideoUrlInfo* info = [[TCCloudPlayerVideoUrlInfo alloc]init];
    info.videoUrlTypeName = @"原始";
    info.videoUrl = [NSURL URLWithString:@"http://4500.vod.myqcloud.com/4500_80db160778860658b284fe171aca3751d5b88471.f20.mp4"];
    [mutlArray addObject:info];

    TCCloudPlayerVideoUrlInfo* info1 = [[TCCloudPlayerVideoUrlInfo alloc]init];
    info1.videoUrlTypeName = @"标清";
    info1.videoUrl = [NSURL URLWithString:@"http://4500.vod.myqcloud.com/4500_80db160778860658b284fe171aca3751d5b88471.f20.mp4"];
    [mutlArray addObject:info1];
    
    [self loadVideoPlaybackView:mutlArray defaultPlayIndex:0 startTime:0];
}

- (IBAction)setLimitPlay:(id)sender
{
    _limitedSeconds = 60;
    [self playVideo:nil];
}

- (void)initPlayerView
{
//    _playerView = [[TCCloudPlayerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    //playerView.backgroundColor = [UIColor redColor];
//    //[self.view addSubview:playerView];
//    self.view = _playerView;
    
    // 添加播放器上的控制操作
    //    [self addPlayerCtrlView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(onLeftBtnClick)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
}


- (void)addMaskView:(NSArray *)buttons size:(CGSize)btnSize
{
    if (buttons.count)
    {
        [_playerView addMaskView:buttons size:btnSize];
    }
}

-(void)onLeftBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    //    {
    //        NSNumber *num = [[NSNumber alloc] initWithInt:UIInterfaceOrientationLandscapeRight];
    //        [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)num];
    //        [UIViewController attemptRotationToDeviceOrientation];
    //    }
    //    SEL selector=NSSelectorFromString(@"setOrientation:");
    //    NSInvocation *invocation =[NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    //    [invocation setSelector:selector];
    //    [invocation setTarget:[UIDevice currentDevice]];
    //    int val = UIInterfaceOrientationLandscapeRight;
    //    [invocation setArgument:&val atIndex:2];
    //    [invocation invoke];
    NSMutableArray* mutlArray = [NSMutableArray array];
    TCCloudPlayerVideoUrlInfo* info = [[TCCloudPlayerVideoUrlInfo alloc]init];
    info.videoUrlTypeName = @"原始";
    info.videoUrl = [NSURL URLWithString:@"http://4500.vod.myqcloud.com/4500_80db160778860658b284fe171aca3751d5b88471.f20.mp4"];
    [mutlArray addObject:info];
    
    TCCloudPlayerVideoUrlInfo* info1 = [[TCCloudPlayerVideoUrlInfo alloc]init];
    info1.videoUrlTypeName = @"标清";
    info1.videoUrl = [NSURL URLWithString:@"http://4500.vod.myqcloud.com/4500_80db160778860658b284fe171aca3751d5b88471.f20.mp4"];
    [mutlArray addObject:info1];
    
    [self loadVideoPlaybackView:mutlArray defaultPlayIndex:0 startTime:0];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self loadVideoPlaybackView:_videoUrls defaultPlayIndex:_defPlayIndex startTime:_startTimeInSeconds];
}
//#pragma mark
//#pragma mark - Rotation
//#pragma mark
- (BOOL)shouldAutorotate
{
    return YES;
}
//
////- (void)viewWillLayoutSubviews
////{
////    UIInterfaceOrientation ort = [UIApplication sharedApplication].statusBarOrientation;
////    if (UIInterfaceOrientationIsPortrait(ort))
////    {
////        _playerView.frame = CGRectMake(20, 80, self.view.bounds.size.width - 40, 240);
////    }
////    else if (UIInterfaceOrientationIsLandscape(ort))
////    {
////        _playerView.frame = self.view.bounds;
////    }
////}
//
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
//
//-(BOOL)setVideoInfo:(NSString*)videoFileID videoFileName:(NSString*)videoFileName videoUrls:(NSArray *)videoUrls defaultPlayIndex:(NSUInteger)defaultPlayIndex startTime:(Float64)startTimeInSeconds
//{
//    if (!videoFileID || !videoUrls || [videoUrls count] == 0 ) {
//        return NO;
//    }
//    
//    if (defaultPlayIndex >= [videoUrls count]) {
//        defaultPlayIndex = 0;
//    }
//    
//    _videoFileID = videoFileID;
//    _videoFileName = videoFileName;
//    _videoUrls = videoUrls;
//    _defPlayIndex = defaultPlayIndex;
//    _startTimeInSeconds = startTimeInSeconds;
//    
//    return YES;
//}
//
//-(BOOL)play:(Float64)beginPlayTime
//{
//    return YES;
//}
//
//-(BOOL)pause
//{
//    return YES;
//}
//
//-(Float64)currentPlayTime
//{
//    return 0;
//}

//#pragma mark - 手势 -
//- (void)playViewPanGestureAction:(UIPanGestureRecognizer *)panGesture
//{
//    switch (panGesture.state) {
//        case UIGestureRecognizerStateBegan:
//        {
//            _startPnt = [panGesture translationInView:_playerView];
//            _isLeft = [panGesture locationInView:_playerView].x < CGRectGetMidX(_playerView.bounds);
//
//            _oldLumina = _playerView.luminance;
//            MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
//            //mpc.volume = 0;  //0.0~1.0
//            _oldVolume = mpc.volume;
//
//            _oldTime = [_playerView getCurVideoPlaybackTimeInSeconds];
//        }
//            break;
//        case UIGestureRecognizerStateChanged:
//        {
//            CGPoint curPnt = [panGesture translationInView:_playerView];
//            if (GestureOperateType_Unknow == _opType) {
//                //检测_opType
//                if (ABS(curPnt.x - _startPnt.x) > ABS(curPnt.y- _startPnt.y)) {
//                    _opType = GestureOperateType_Progress;
//                } else {
//                    //根据触发位置来决定（左边亮度，右边音量）
//                    if (_isLeft) {
//                        _opType = GestureOperateType_Lumina;
//                    } else {
//                        _opType = GestureOperateType_Volume;
//                    }
//                }
//            }
//            [self dealWithOpType:_opType startPnt:_startPnt endPnt:curPnt];
//        }
//            break;
//        case UIGestureRecognizerStateEnded:
//        {
//            if (GestureOperateType_Progress == _opType) {
//                _timeLabel.hidden = YES;
//                [_playerView seekToTime:_seekTime];
//                _seekTime = 0;
//                _oldTime = 0;
//            }
//            _opType = GestureOperateType_Unknow;
//        }
//            break;
//        case UIGestureRecognizerStateCancelled:
//        {
//            _opType = GestureOperateType_Unknow;
//            _timeLabel.hidden = YES;
//        }
//            break;
//        default:
//        {
//            _opType = GestureOperateType_Unknow;
//        }
//            break;
//    }
//}
//
//- (BOOL)dealWithOpType:(GestureOperateType)opType startPnt:(CGPoint)start endPnt:(CGPoint)end
//{
//    if (opType == GestureOperateType_Progress) {
//        CGFloat uint = (end.x - start.y) / UNIT_PIXEL;
//        if (ABS(uint) < 1) {
//            return NO;
//        }
//        [self updateTimeLabel:uint];
//    } else {
//        CGFloat uint = (end.y - start.y) / UNIT_PIXEL;
//        if (ABS(uint) < 1) {
//            return NO;
//        }
//        if (opType == GestureOperateType_Lumina) {
//            [self changeLumina:-uint];
//        } else {
//            [self changeVolume:-uint];
//        }
//    }
//    return NO;
//}

//#pragma mark - 播放控制 -
//
//- (void)changeLumina:(NSInteger)change
//{
//    _playerView.luminance = _oldLumina + change * LUMINA_STEP;
//}
//
//- (void)changeVolume:(NSInteger)change
//{
//    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
//
//    float newVolume = _oldVolume + change * VOLUME_STEP;
//    if (newVolume > 1) {
//        newVolume = 1;
//    } else if (newVolume < 0) {
//        newVolume = 0;
//    }
//    mpc.volume = newVolume;
//}
//
//- (void)updateTimeLabel:(NSInteger)change
//{
//    if (!_timeLabel) {
//        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//        _timeLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
//        _timeLabel.font = [UIFont systemFontOfSize:14.0];
//        _timeLabel.textColor = [UIColor whiteColor];
//        _timeLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//        _timeLabel.center = CGPointMake(_playerView.bounds.size.width/2.0, 50);
//        [_playerView addSubview:_timeLabel];
//    }
//
//    _timeLabel.hidden = NO;
//
//    NSString *timeString = nil;
//    NSInteger time = _oldTime + change;
//
//    if (time < 0) {
//        time = 0;
//    } else if (time > _playerView.duration) {
//        time = _playerView.duration;
//    }
//    _seekTime = time;
//
//    timeString = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", time / 3600, time %3600 /60, time % 60];
//
////    NSInteger formatOfTime = _playerView.duration;
////    if (formatOfTime <= 0) {
////        formatOfTime = time;
////    }
////
////    if (formatOfTime < 3600) {
////        timeString = [NSString stringWithFormat:@"%02zd:%02zd", time/60, time % 60];
////    } else {
////        timeString = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", time / 3600, time %3600 /60, time % 60];
////    }
//    _timeLabel.text = timeString;
//    [_timeLabel sizeToFit];
//}

#pragma mark
#pragma mark 加载视频播放及回调
#pragma mark
-(void)loadVideoPlaybackView:(NSArray*)videoUrls defaultPlayIndex:(NSUInteger)defaultPlayIndex startTime:(Float64)startTimeInSeconds
{
    _playerView.isSilent = NO;
    _playerView.isCyclePlay = NO;
    
    
    
    BOOL loadVideoRet = [_playerView setUrls:videoUrls defaultPlayIndex:defaultPlayIndex startTime:startTimeInSeconds];
    //BOOL loadVideoRet = [_playerView setAVAsset:self.videoAsset startTime:[self.startTimeValue CMTimeValue]];
    if (!loadVideoRet) {
        //[[QQProgressHUD sharedInstance] showState:@"视频加载失败" success:NO];
        
    }
    
}

//注意，退后台进入前台也会进入这个函数
- (void)playbackReadyBlock
{
    [_playerView setLimitTime:_limitedSeconds];
//    [_playerView play];
}

-(void) playbackBeginBlock
{
    if (!_playerView.isInFullScreen)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:_playerView selector:@selector(reversionFullScreenState) object:nil];
        [_playerView performSelector:@selector(reversionFullScreenState) withObject:nil afterDelay:2];
    }
    
    [self postPlayNotificaction];
}

-(void) playbackFailedBlock:(NSError*)error
{
    if (_playerView.isInFullScreen) {
        [NSObject cancelPreviousPerformRequestsWithTarget:_playerView selector:@selector(reversionFullScreenState) object:nil];
        [_playerView reversionFullScreenState];
    }
    
    NSString* strTile = [NSString stringWithFormat:@"视频播放失败(%zd)",[error code]];
    NSString* errorDes = nil;
    //#if DEBUG
    errorDes = [error localizedDescription];
    //#endif
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTile message:errorDes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    //显示AlertView
    [alert show];
    
    [self postStopNotificationWithError:error];
}

-(void) playbackPauseBlock:(UIImage*)curImg pauseReason:(TCCloudPlayerPauseReason)reason
{
    [NSObject cancelPreviousPerformRequestsWithTarget:_playerView selector:@selector(reversionFullScreenState) object:nil];
    if (_playerView.isInFullScreen)
    {
        [_playerView reversionFullScreenState];
    }
    
    [self postPauseNotificationWithReason:reason];
}

-(void) playbackEndBlock
{
  
    
    if (_playerView.isInFullScreen)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:_playerView selector:@selector(reversionFullScreenState) object:nil];
        [_playerView reversionFullScreenState];
    }
    [self postStopNotificationWithError:nil];
}

#pragma mark
#pragma mark 全屏
#pragma mark
-(void)clickPlayView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:_playerView selector:@selector(reversionFullScreenState) object:nil];
    [_playerView reversionFullScreenState];
    
    if (!_playerView.isInFullScreen && [_playerView isPlaying])
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:_playerView selector:@selector(reversionFullScreenState) object:nil];
        [self performSelector:@selector(reversionFullScreenState) withObject:nil afterDelay:5];
    }
}

//-(void)reversionFullScreenState
//{
//    if (![_playerView canHiddenBottemBar]) {
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reversionFullScreenState) object:nil];
//        [self performSelector:@selector(reversionFullScreenState) withObject:nil afterDelay:5];
//        return;
//    }
//
//    _isInFullScreen = !_isInFullScreen;
//
//    //BOOL bHidden = [[UIApplication sharedApplication] isStatusBarHidden];
//    [[UIApplication sharedApplication] setStatusBarHidden:_isInFullScreen withAnimation:UIStatusBarAnimationSlide];
//    [self.navigationController setNavigationBarHidden:_isInFullScreen animated:YES];
//
//    if(_isInFullScreen)
//    {
//        [UIView beginAnimations:@"hideVideoBottomView" context:nil];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationDuration:0.2];
//        CGRect f = _playerView.bottomView.frame;
//        f.origin.y = _playerView.bounds.size.height;
//        _playerView.bottomView.frame = f;
//        [UIView commitAnimations];
//    }
//    else
//    {
//        [UIView beginAnimations:@"showVideoBottomView" context:nil];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationDuration:0.2];
//        CGRect f = _playerView.bottomView.frame;
//        f.origin.y = _playerView.bounds.size.height - f.size.height;
//        _playerView.bottomView.frame = f;
//        [UIView commitAnimations];
//
//    }
//}

#pragma mark - 抛通知 -

- (NSMutableDictionary *)commVideoParam
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@([_playerView getCurVideoPlaybackTimeInSeconds]) forKey:kTCCloudPlayTime];
    [param setObject:@(_playerView.duration) forKey:kTCCloudPlayDuration];
    TCCloudPlayerVideoUrlInfo *url = [_playerView currentUrl];
    if (url) {
        [param setObject:url forKey:kTCCloudPlayQaulity];
    }
    return param;
}

- (void)postPlayNotificaction
{
    NSMutableDictionary *param = [self commVideoParam];
    [param setObject:@(1) forKey:kTCCloudPlayState];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TCCloudPlayStateChangeNotification object:nil userInfo:param];
}

- (void)postPauseNotificationWithReason:(TCCloudPlayerPauseReason)reason
{
    NSMutableDictionary *param = [self commVideoParam];
    [param setObject:@(2) forKey:kTCCloudPlayState];
    [param setObject:@(reason) forKey:kTCCloudPlayPauseReason];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TCCloudPlayStateChangeNotification object:nil userInfo:param];
}

- (void)postStopNotificationWithError:(NSError *)error
{
    NSMutableDictionary *param = [self commVideoParam];
    [param setObject:@(0) forKey:kTCCloudPlayState];
    if (error) {
        [param setObject:error forKey:kTCCloudPlayError];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TCCloudPlayStateChangeNotification object:nil userInfo:param];
}


- (IBAction)testReport:(id)sender
{
}



@end
