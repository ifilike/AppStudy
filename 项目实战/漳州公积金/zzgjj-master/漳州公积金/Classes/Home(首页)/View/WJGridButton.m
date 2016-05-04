//
//  WJHomeButton.m
//  testtt
//
//  Created by fengwujie on 16/1/15.
//  Copyright © 2016年 dw. All rights reserved.
//

#import "WJGridButton.h"

@implementation WJGridButton

- (instancetype)init{
    self = [super init];
    if (self) {
        // 设置标题的字体
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

-(void)setImageName:(NSString *)imageName text:(NSString *)text fontSize:(float)fontSize
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self setTitle:text forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    float wH = self.frame.size.height;
    float imageH = wH * 0.2 * 2;
    float imageW = imageH;
    float imageX = (self.frame.size.width - imageW) * 0.5;
    float imageY = wH * 0.2 ;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    float labelH = wH * 0.2;
    float labelW = self.frame.size.width;
    float labelY = CGRectGetMaxY(self.imageView.frame);
    float labelX = 0;
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
    
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end
