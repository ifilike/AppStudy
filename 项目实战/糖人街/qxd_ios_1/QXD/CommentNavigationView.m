//
//  CommentNavigationView.m
//  QXD
//
//  Created by wzp on 16/2/2.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "CommentNavigationView.h"

@implementation CommentNavigationView





-  (instancetype)initWithFrame:(CGRect)frame withName:(NSString*)name{
    self=[super initWithFrame:frame];
    if (self) {
        self.controllerName=[[UILabel alloc] initWithFrame:CGRectMake(50, 20, WIDTH-100, 44)];
        _controllerName.text=name;
        _controllerName.textAlignment=1;
        _controllerName.textColor=[self colorWithHexString:@"#555555"];
        _controllerName.font=[UIFont systemFontOfSize:17*PROPORTION_WIDTH];
        [self addSubview:_controllerName];
        
        
        self.cancellBut=[[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 44)];
        [_cancellBut setImage:[UIImage imageNamed:@"return_icon"] forState:0];
        
        [self addSubview:_cancellBut];
        
        UIView * lien=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, WIDTH, 0.5)];
        lien.backgroundColor=[self colorWithHexString:@"#DDDDDD"];
        [self addSubview:lien];
        
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
