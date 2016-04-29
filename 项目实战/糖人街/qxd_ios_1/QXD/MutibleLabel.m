//
//  MutibleLabel.m
//  QXD
//
//  Created by WZP on 15/11/19.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "MutibleLabel.h"

@implementation MutibleLabel



- (void)changeFrameWithString:(NSString*)string{
    self.text=string;
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    CGRect frame =CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height);
    self.font = [UIFont systemFontOfSize:14];
   
    self.frame=frame;
    
}
- (CGRect)getNewFrameWithString:(NSString*)string{
    self.text=string;
    self.numberOfLines = 2;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    CGRect frame =CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height);
    self.font = [UIFont systemFontOfSize:14];
    
    return frame;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
