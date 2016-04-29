//
//  WithUnderLienTextFieldView.m
//  QXD
//
//  Created by wzp on 16/2/17.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "WithUnderLienTextFieldView.h"

@implementation WithUnderLienTextFieldView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame withPlaceholder:(NSString*)placeText{
    self=[super initWithFrame:frame];
    if (self) {
        self.textField=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30*PROPORTION_WIDTH)];
        _textField.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        _textField.placeholder=placeText;
        [self addSubview:_textField];
        self.underlienView=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 0.5)];
        _underlienView.backgroundColor=[self colorWithHexString:@"#DDDDDD"];
        [self addSubview:_underlienView];
        
        
        
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

@end
