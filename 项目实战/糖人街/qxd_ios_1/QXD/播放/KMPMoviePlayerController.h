//
//  KMPMoviePlayerController.h
//  播放器Demo
//
//  Created by WJM on 16/2/1.
//  Copyright © 2016年 WJM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class KMPMoviePlayerController;

@protocol KMPMoviePlayerControllerDelegate <NSObject>
///动态获得播放器播放状态
- (void)KMPMoviePlaybackState:(MPMoviePlaybackState)State;
///动态获得是否是全屏 全屏/YES
- (void)KMPMoviePlayerScreenState:(BOOL)fullScreen;
@end

@interface KMPMoviePlayerController : MPMoviePlayerController

@property (weak, nonatomic) id<KMPMoviePlayerControllerDelegate>delegate;

///播放页面Frame
@property (nonatomic, assign) CGRect frame;
///播放状态
@property (nonatomic, assign) BOOL isPlaying;
///默认图片
@property (nonatomic, strong) NSString *defaultImageUrl;

- (instancetype)initWithFrame:(CGRect)frame;

///disMiss掉视图
- (void)dismiss;
///播放
- (void)playButtonClick;
///暂停
- (void)pauseButtonClick;
///全屏
- (void)fullScreenButtonClick;
///取消全屏
- (void)shrinkScreenButtonClick;

@end
