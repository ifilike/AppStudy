//
//  WithLabelImageView.m
//  QXD
//
//  Created by wzp on 15/12/22.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "WithLabelImageView.h"

@implementation WithLabelImageView


#define HeIgHt frame.size.height
#define WiDtH frame.size.width
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, HeIgHt-30, WiDtH, 30)];
        _titleLabel.textAlignment=1;
        _titleLabel.text=@"适用人群";
        _titleLabel.backgroundColor=[UIColor grayColor];
        _titleLabel.alpha=0.5;
        self.backgroundColor=[UIColor redColor];
        [self addSubview:_titleLabel];
        
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
