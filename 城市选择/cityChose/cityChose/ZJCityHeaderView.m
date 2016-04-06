//
//  ZJCityHeaderView.m
//  cityChose
//
//  Created by babbage on 16/4/5.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ZJCityHeaderView.h"

@implementation ZJCityHeaderView
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if ( self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.titleLabel];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel setFrame:CGRectMake(10, 0, self.frame.size.width - 10, self.frame.size.height)];
}
-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_titleLabel setTextColor:[UIColor blackColor]];
    }
    return _titleLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
