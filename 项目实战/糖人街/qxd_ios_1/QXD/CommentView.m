//
//  CommentView.m
//  QXD
//
//  Created by wzp on 16/1/6.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView


- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        UIView * lienView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
        lienView.backgroundColor=[self colorWithHexString:@"#DDDDDD"];
        [self addSubview:lienView];
        
        
//        self.faceBut=[[UIButton alloc] initWithFrame:CGRectMake(10, 14.5, 25, 25)];
//        [_faceBut setImage:[UIImage imageNamed:@"Smile_icon"] forState:0];
//        [self addSubview:_faceBut];
//        
        
        self.sendBut=[[UIButton alloc] initWithFrame:CGRectMake(WIDTH-10-60, 9, 60, 36)];
//        _sendBut.layer.borderWidth=0.5;
//        _sendBut.layer.borderColor=[self colorWithHexString:@"#999999"].CGColor;
        [_sendBut setTitle:@"发表" forState:0];
        _sendBut.titleLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        _sendBut.layer.cornerRadius=5;
        [_sendBut setTitleColor:[self colorWithHexString:@"#FFFFFF"] forState:0];
        _sendBut.backgroundColor=[self colorWithHexString:@"#FD681F"];
        [self addSubview:_sendBut];
        
        
        self.contentField=[[UITextField alloc] initWithFrame:CGRectMake(10, 9, WIDTH-10-10-60-14, 36)];
        _contentField.textColor=[self colorWithHexString:@"#999999"];
        _contentField.layer.cornerRadius=5;
        _contentField.layer.borderColor=[self colorWithHexString:@"#DDDDDD"].CGColor;
        _contentField.layer.borderWidth=1;
        [self addSubview:_contentField];
        
        
        UIView * lienView2 =[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 1)];
        lienView2.backgroundColor=[self colorWithHexString:@"#DDDDDD"];
        [self addSubview:lienView2];
        
        
        self.backgroundColor=[UIColor whiteColor];
        self.alpha=1;
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
