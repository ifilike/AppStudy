//
//  DeleteLineLabel.m
//  QXD
//
//  Created by WZP on 15/11/18.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "DeleteLineLabel.h"

@implementation DeleteLineLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    
//    
//    
//    // Drawing code
//}
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString*)title{
    self=[super initWithFrame:frame];
    if (self) {
        self.text=title;
        self.textColor=[self colorWithHexString:@"#999999"];
        self.textAlignment=1;
        UIFont * fnt=self.font;
        CGSize size = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
        CGFloat nameW = size.width;
        CGFloat w=frame.size.width;
        UIView * line=[[UIView alloc] initWithFrame:CGRectMake((w-nameW)/2, frame.size.height/2, nameW, 1)];
        line.backgroundColor=[self colorWithHexString:@"#999999"];
        [self addSubview:line];
        
        
    }
    return self;
}
- (instancetype)initWithFrame2:(CGRect)frame withTitle:(NSString*)title{
    self=[super initWithFrame:frame];
    if (self) {
        self.text=title;
        self.textColor=[self colorWithHexString:@"#999999"];
        self.textAlignment=1;
        UIFont * fnt=self.font;
        CGSize size = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
        CGFloat nameW = size.width;
        UIView * line=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height/2, nameW/2, 1)];
        line.backgroundColor=[self colorWithHexString:@"#999999"];
        [self addSubview:line];
        
        
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

- (void)changeTextWith:(NSString*)string{
    self.text=[NSString stringWithFormat:@"%@%@",@"￥",string];
    
}

//- (void)drawRect:(CGRect)rect
//{
//    // 调用super的drawRect:方法,会按照父类绘制label的文字
//    [super drawRect:rect];
//    
//    
//    // 取文字的颜色作为删除线的颜色
//    [self.textColor set];
//    // 根据字体得到NSString的尺寸
//    UIFont * fnt=self.font;
//    CGSize size = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
//    // 名字的H
//    // 名字的W
//    CGFloat nameW = size.width;
//    CGFloat w = rect.size.width;
//    CGFloat h = rect.size.height;
//
//    // 绘制(这个数字是为了找到label的中间位置,0.35这个数字是试出来的,如果不在中间可以自己调整)
////    UIRectFill(CGRectMake((w-nameW)/2, nameH * 0.6, nameW, 1));
//    UIRectFill(CGRectMake((w-nameW)/2, h * 0.4, nameW, 1));
//
//    
//}

@end
