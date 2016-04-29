//
//  SelectView.m
//  QXD
//
//  Created by WZP on 15/11/20.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "SelectView.h"
#import "DeleteLienLabel.h"

@implementation SelectView



- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        float setY=23*PROPORTION_WIDTH;
        _nameLable=[[UILabel alloc] initWithFrame:CGRectMake(0, setY, frame.size.width, 20)];
        _nameLable.textAlignment=1;
        _nameLable.font=[UIFont systemFontOfSize:17*PROPORTION_WIDTH];
        _nameLable.text=@"";
        _nameLable.textColor=[self colorWithHexString:@"#555555"];
        [self addSubview:_nameLable];
        
        setY+=20+15*PROPORTION_WIDTH;
        _priceLable=[[UILabel alloc] initWithFrame:CGRectMake(0, setY, frame.size.width/2-8*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
        _priceLable.textColor=[self colorWithHexString:@"#FD681F"];
        _priceLable.font=[UIFont systemFontOfSize:20*PROPORTION_WIDTH];
        _priceLable.text=@"";
        _priceLable.textAlignment=2;
        [self addSubview:_priceLable];
        
        _oldPriceLable=[[DeleteLienLabel alloc] initWithFrame:CGRectMake(frame.size.width/2+8*PROPORTION_WIDTH, setY+7.5*PROPORTION_WIDTH, frame.size.width/2-8*PROPORTION_WIDTH, 15*PROPORTION_WIDTH) content:@"" textColor:[self colorWithHexString:@"#999999"] textSize:10*PROPORTION_WIDTH deleteColor:[self colorWithHexString:@"#999999"]];
        _oldPriceLable.textAlignment=0;
        [self addSubview:_oldPriceLable];
        setY+=30*PROPORTION_WIDTH+8*PROPORTION_WIDTH;
        
        _selectLable=[[UILabel alloc] initWithFrame:CGRectMake(23*PROPORTION_WIDTH, setY, frame.size.width-46*PROPORTION_WIDTH, 50*PROPORTION_WIDTH)];
        _selectLable.text=@"";
        _selectLable.textColor=[self colorWithHexString:@"#555555"];
        _selectLable.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        [self addSubview:_selectLable];
        
        //        _addBut=[[UIButton alloc] initWithFrame:CGRectMake(WIDTH-10-30*PROPORTION_WIDTH, 106*PROPORTION_WIDTH+20, 30*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
        //        [_addBut setImage:[UIImage imageNamed:@"箭头"] forState:0];
        //        [self addSubview:_addBut];
        
        setY+=50*PROPORTION_WIDTH;
        _serviceLable=[[UILabel alloc] initWithFrame:CGRectMake(23*PROPORTION_WIDTH, setY, frame.size.width-46*PROPORTION_WIDTH,50*PROPORTION_WIDTH)];
        _serviceLable.text=@"";
        _serviceLable.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        _serviceLable.textColor=[self colorWithHexString:@"#555555"];
        [self addSubview:_serviceLable];
        
        
        
        
        
        
        
    }
    
    return self;
}
- (void)reloadDataWithName:(NSString*)name price:(NSString*)price oldPrice:(NSString*)oldPrice stand:(NSString*)stand{
    _serviceLable.text=@"服务：支持7天无理由退货";
    
    self.nameLable.text=name;
    NSString * price2=[NSString stringWithFormat:@"%@%@",@"￥",price];
    self.priceLable.text=price2;
    if (oldPrice.length==0) {
        self.oldPriceLable.hidden=YES;
    }else{
        [self.oldPriceLable changeTextWithNewText:[NSString stringWithFormat:@"%@%@",@"￥",oldPrice]];
    }
    NSString * str=@"规格：";
    //    NSString * str2=@"/1件";
    _selectLable.text=[NSString stringWithFormat:@"%@%@",str,stand];
    
    
    
    
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
 */
- (void)drawRect:(CGRect)rect {
    
    //设置颜色
    UIColor * color=[self colorWithHexString:@"#DDDDDD"];
    [color set];
    
    CGSize size=self.frame.size;
    CGFloat W=size.width;
    
    UIRectFill(CGRectMake(17*PROPORTION_WIDTH, 76*PROPORTION_WIDTH+20, W-34*PROPORTION_WIDTH, 0.5));
    
    UIRectFill(CGRectMake(17*PROPORTION_WIDTH, 126*PROPORTION_WIDTH+20, W-34*PROPORTION_WIDTH, 0.5));
    
}


@end
