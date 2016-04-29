//
//  MovieDetailsView.m
//  QXD
//
//  Created by wzp on 16/1/31.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "MovieDetailsView.h"

@implementation MovieDetailsView


- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor whiteColor];
        //视频介绍的标志
        _leftLien=[[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 35*PROPORTION_WIDTH, 133*PROPORTION_WIDTH, 1)];
        _leftLien.backgroundColor=[self colorWithHexString:@"#E4E4E4"];
        
        _rightLien=[[UIView alloc] initWithFrame:CGRectMake(WIDTH-148*PROPORTION_WIDTH, 35*PROPORTION_WIDTH, 133*PROPORTION_WIDTH, 1)];
        _rightLien.backgroundColor=[self colorWithHexString:@"#E4E4E4"];
        
        _movieLabel=[[UILabel alloc] initWithFrame:CGRectMake(159*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, WIDTH-318*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
        _movieLabel.text=@"视频介绍";
        _movieLabel.textAlignment=1;
        _movieLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        _movieLabel.textColor=[self colorWithHexString:@"#FD681F"];
        
        
        [self addSubview:_leftLien];
        [self addSubview:_rightLien];
        [self addSubview:_movieLabel];
        
        
        
        //视频介绍的内容
        _mutibleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16*PROPORTION_WIDTH, 55*PROPORTION_WIDTH, WIDTH-32*PROPORTION_WIDTH, 40
                                                                  )];
        [_mutibleLabel setTextColor:[self colorWithHexString:@"#555555"]];
        [_mutibleLabel setNumberOfLines:0];
        _mutibleLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
//        _mutibleLabel.backgroundColor=[UIColor redColor];
//        _mutibleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        NSString *labelText = @"撒旦法规是打发打发撒地方阿斯蒂芬阿斯蒂芬阿萨德阿斯蒂芬撒旦个法师的发个啥地方阿斯蒂芬阿萨德盛大发售阿斯蒂芬阿萨德爱迪生发";
//        
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setLineSpacing:5];//调整行间距
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
//        _mutibleLabel.attributedText = attributedString;
//        NSLog(@"高5555度是:%f",_mutibleLabel.frame.size.height);
//        
//        [_mutibleLabel sizeToFit];
        [self addSubview:_mutibleLabel];

        
        self.mutableHigh=_mutibleLabel.frame.size.height;
        self.frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 55*PROPORTION_WIDTH+self.mutableHigh+30*PROPORTION_WIDTH);
        
        
        
    }

    return self;
    
    
}

- (void)changeContentWithText:(NSString*)contentText{

    NSString *labelText = contentText;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    _mutibleLabel.attributedText = attributedString;
    NSLog(@"高5555度是:%f",_mutibleLabel.frame.size.height);
    
    [_mutibleLabel sizeToFit];

    self.mutableHigh=_mutibleLabel.frame.size.height;

    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 55*PROPORTION_WIDTH+self.mutableHigh+30*PROPORTION_WIDTH);


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
