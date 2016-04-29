//
//  BuyView.m
//  QXD
//
//  Created by wzp on 16/1/28.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "BuyView.h"

@implementation BuyView




- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        
        
        self.addButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width*0.44, frame.size.height)];
        self.buyButton=[[UIButton alloc] initWithFrame:CGRectMake(frame.size.width*0.44, 0, frame.size.width*0.56, frame.size.height)];
        _buyButton.backgroundColor=[self colorWithHexString:@"#FD681F"];
        [_buyButton setTitle:@"立即购买" forState:0];
        _buyButton.titleLabel.font=[UIFont fontWithName:@"PingFang SC" size:14*PROPORTION_WIDTH];
        [_buyButton setTitleColor:[self colorWithHexString:@"#FFFFFF"] forState:0];
        [self addSubview:_addButton];
        [self addSubview:_buyButton];
        
        self.carView=[[UIImageView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 16*PROPORTION_WIDTH, 22*PROPORTION_WIDTH, 22*PROPORTION_WIDTH)];
        _carView.image=[UIImage imageNamed:@"shopping cart_icon"];
        [self addSubview:_carView];
        self.textLabel=[[UILabel alloc] initWithFrame:CGRectMake(50*PROPORTION_WIDTH, 0, frame.size.width*0.44-50*PROPORTION_WIDTH, frame.size.height)];
        _textLabel.text=@"加入购物车";
        _textLabel.font=[UIFont fontWithName:@"PingFang SC" size:14*PROPORTION_WIDTH];
        _textLabel.textColor=[self colorWithHexString:@"#555555"];
        [self addSubview:_textLabel];
        
        UIView * lien=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
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
