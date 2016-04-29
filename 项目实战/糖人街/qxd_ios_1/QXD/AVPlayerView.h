//
//  AVPlayerView.h
//  QXD
//
//  Created by wzp on 15/12/17.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerView : UIView


@property(nonatomic,retain)AVPlayer * player;


- (void)playMovie;

@end
