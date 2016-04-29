//
//  FoundZTViewController.h
//  QXD
//
//  Created by wzp on 15/12/29.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCCloudPlayerView.h"

@interface FoundZTViewController : UIViewController



//视频
{
    
@protected
    TCCloudPlayerView *_playerView;
}

- (CGRect)playViewFrame;
-(void)loadVideoPlaybackView:(NSArray*)videoUrls defaultPlayIndex:(NSUInteger)defaultPlayIndex startTime:(Float64)startTimeInSeconds;

@property(nonatomic,retain)NSString * ztID;
@end
