//
//  NavigationBarLikeView.m
//  QXD
//
//  Created by WZP on 15/11/18.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "NavigationBarLikeView.h"

@implementation NavigationBarLikeView


- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _cancellBut=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, frame.size.height)];
        UIImageView * image=[[UIImageView alloc] initWithFrame:CGRectMake(20, 11, 21, 21)];
        image.image=[UIImage imageNamed:@"return_icon"];
        [self addSubview:image];
        [self addSubview:_cancellBut];
        _likeBut=[[UIButton alloc] initWithFrame:CGRectMake(frame.size.width*4/5, 0, frame.size.width/5, frame.size.height)];
        [_likeBut setImage:[UIImage imageNamed:@"attention_icon"] forState:0];
        [self addSubview:_likeBut];
        _titlelable=[[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/5, 0, frame.size.width*3/5, frame.size.height)];
        _titlelable.textAlignment=1;
        _titlelable.font=[UIFont systemFontOfSize:17*PROPORTION_WIDTH];
        _titlelable.textColor=[self colorWithHexString:@"#555555"];
        [self addSubview:_titlelable];
        self.backgroundColor=[self colorWithHexString:@"#F7F7F7"];
        
//        UIView * lienView=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 0.5)];
//        lienView.backgroundColor=[UIColor grayColor];
//        
//        [self addSubview:lienView];
        
    }

    return self;
}

- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
