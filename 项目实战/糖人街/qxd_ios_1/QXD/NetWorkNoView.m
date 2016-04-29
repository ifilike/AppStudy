//
//  NetWorkNoView.m
//  QXD
//
//  Created by wzp on 16/2/3.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "NetWorkNoView.h"

@implementation NetWorkNoView



- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        UIImageView * image404=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        image404.image=[UIImage imageNamed:@"404.png"];
        [self addSubview:image404];
        
        
        
        
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
