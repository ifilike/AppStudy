//
//  NaviagtionBarShareView.m
//  QXD
//
//  Created by WZP on 15/11/18.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "NaviagtionBarShareView.h"

@implementation NaviagtionBarShareView



- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _cancellBut=[[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, frame.size.height)];
        UIImageView * image=[[UIImageView alloc] initWithFrame:CGRectMake(20, 31, 21, 21)];
        image.image=[UIImage imageNamed:@"return_icon"];
        [self addSubview:image];
        [self addSubview:_cancellBut];
        _wxBut=[[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-162, 20,44,44)];
        [_wxBut setImage:[UIImage imageNamed:@"weixin_icon"] forState:0];
        [self addSubview:_wxBut];
        
        _friendBut=[[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-108, 20, 44,44)];
        [_friendBut setImage:[UIImage imageNamed:@"pengyouquan_icon"] forState:0];
        [self addSubview:_friendBut];

        _moreBut=[[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-54,20,44,44)];
        [_moreBut setImage:[UIImage imageNamed:@"qq-icon"] forState:0];

        [self addSubview:_moreBut];

        self.backgroundColor=[UIColor whiteColor];
        
//        
//        UIView * lienView=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 0.5)];
//        lienView.backgroundColor=[UIColor grayColor];
//        
//        [self addSubview:lienView];
        
        
        
    }
    
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    
    
    // Drawing code
}


@end
