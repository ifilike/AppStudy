//
//  PayMode.m
//  QXD
//
//  Created by wzp on 15/12/28.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "PayModeView.h"

@implementation PayModeView




- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.imageView2=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
        self.nameOfLabel=[[UILabel alloc] initWithFrame:CGRectMake(45, 0, 100, 30)];
        self.selectedBut=[[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-35, 0, 30, 30)];
        [_selectedBut setBackgroundImage:[UIImage imageNamed:@"Unselected"] forState:0];
        [self addSubview:_imageView2];
        [self addSubview:_nameOfLabel];
        [self addSubview:_selectedBut];
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
