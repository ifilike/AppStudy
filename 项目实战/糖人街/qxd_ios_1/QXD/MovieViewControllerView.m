//
//  MovieViewControllerView.m
//  QXD
//
//  Created by wzp on 16/1/5.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "MovieViewControllerView.h"

@implementation MovieViewControllerView


- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _playBut=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_playBut setBackgroundImage:[UIImage imageNamed:@"播放"] forState:0];
        [self addSubview:_playBut];
        
        _timeSlider=[[UISlider alloc] initWithFrame:CGRectMake(35, 0, WIDTH-35-80, 30)];
        _timeSlider.value=0;
        [self addSubview:_timeSlider];
        _timeLable=[[UILabel alloc] initWithFrame:CGRectMake(WIDTH-80, 0, 80, 30)];
        _timeLable.text=@"时间";
        _timeLable.textColor=[UIColor whiteColor];
        [self addSubview:_timeLable];
        
    }

    return self;

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
