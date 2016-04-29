//
//  MoreShareButView.m
//  QXD
//
//  Created by wzp on 15/12/29.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "MoreShareButView.h"

@implementation MoreShareButView



- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.shareWB=[[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-54, 0, 44, 44)];
        [_shareWB setBackgroundImage:[UIImage imageNamed:@"微博"] forState:0];
        [self addSubview:_shareWB];
        self.shareQQZoom=[[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-108, 0, 44, 44)];
        [_shareQQZoom setBackgroundImage:[UIImage imageNamed:@"空间"] forState:0];
        [self addSubview:_shareQQZoom];
        self.shareQQ=[[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-162, 0, 44, 44)];
        [_shareQQ setBackgroundImage:[UIImage imageNamed:@"QQ"] forState:0];
        [self addSubview:_shareQQ];
        self.backgroundColor=[UIColor grayColor];
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
