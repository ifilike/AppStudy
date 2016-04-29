//
//  AVPlayerView.m
//  QXD
//
//  Created by wzp on 15/12/17.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "AVPlayerView.h"

@implementation AVPlayerView





+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}
- (void)playMovie{
    [self.player play];

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
