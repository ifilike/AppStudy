//
//  ThreeImageAndLabelView.m
//  QXD
//
//  Created by WZP on 15/11/19.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "ThreeImageAndLabelView.h"
#import "MutibleLabel.h"

@implementation ThreeImageAndLabelView


- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _leftView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/2, frame.size.height)];
        _leftView.backgroundColor=[UIColor redColor];
        [self addSubview:_leftView];
        _topView=[[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height/2)];
        _topView.backgroundColor=[UIColor greenColor];
        [self addSubview:_topView];
        _bottomView=[[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2, frame.size.height/2, frame.size.width/2, frame.size.height/2)];
        _bottomView.backgroundColor=[UIColor blueColor];
        [self addSubview:_bottomView];
        
    }

    return self;

}

- (void)changeHeightWithString:(NSString*)string{
    _mutibleLab=[[MutibleLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height,self.frame.size.width, 50)];
    _mutibleLab.backgroundColor=[UIColor yellowColor];
    CGRect frame=[_mutibleLab getNewFrameWithString:string];
    _mutibleLab.frame=frame;
    
    float height =frame.size.height;
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height+height);
    [self addSubview:_mutibleLab];


}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
