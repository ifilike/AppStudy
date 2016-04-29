//
//  InterestSubView.m
//  QXD
//
//  Created by WZP on 15/11/22.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "InterestSubView.h"
#import "DeleteLienLabel.h"
#import "InterestProductModel.h"
#import "TopLabel.h"



//#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height


@implementation InterestSubView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    float yy=0;
    self.imageView2=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
    [self addSubview:_imageView2];
    UIImage * image=[UIImage imageNamed:@"喜欢"];
    
    //赋值图片
    _imageView2.image=image;
    
    yy+=frame.size.width+10*PROPORTION_WIDTH;
    self.goodsNameLable=[[TopLabel alloc] initWithFrame:CGRectMake(0, yy, frame.size.width, 40*PROPORTION_WIDTH)];
    [_goodsNameLable setVerticalAlignment:VerticalAlignmentTop];
    //赋值产品名
    _goodsNameLable.textColor=[self colorWithHexString:@"#545454"];
    //设置行间距
    NSString * lll=@"咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡咖啡";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lll];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [lll length])];
    _goodsNameLable.attributedText = attributedString;
    _goodsNameLable.textAlignment=1;
    _goodsNameLable.numberOfLines=2;
    _goodsNameLable.font=[UIFont systemFontOfSize:12*PROPORTION_WIDTH];
    [self addSubview:_goodsNameLable];
    
    
    yy+=40*PROPORTION_WIDTH;
    self.goodsPriceLable=[[UILabel alloc] initWithFrame:CGRectMake(0, yy, frame.size.width/2-5, 20)];
    //赋值产品现价
    _goodsPriceLable.text=@"￥60";
    _goodsPriceLable.textAlignment=2;
//    _goodsPriceLable.backgroundColor=[UIColor redColor];
    _goodsPriceLable.textColor=[self colorWithHexString:@"#FD681F"];
    _goodsPriceLable.font=[UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    [self addSubview:_goodsPriceLable];
    //赋值产品原价
    self.oldProice=[[DeleteLienLabel alloc] initWithFrame:CGRectMake(frame.size.width/2, yy+4*PROPORTION_WIDTH, frame.size.width/2, 15*PROPORTION_WIDTH) content:@"" textColor:[self colorWithHexString:@"#999999"] textSize:11 deleteColor:[self colorWithHexString:@"#999999"]];
    
    [self addSubview:_oldProice];
    
    return self;
}


- (void)setModel:(InterestProductModel*)model{
    //改变图片
    NSURL * url=[NSURL URLWithString:model.product_img1];
    [_imageView2 sd_setImageWithURL:url];
    //改变现价
    _goodsPriceLable.text=[NSString stringWithFormat:@"%@%@",@"￥",model.product_present_price];
    //改变原价
    if (model.product_original.length==0) {
        _oldProice.hidden=YES;
    }else{
        NSString * oldPrice=[NSString stringWithFormat:@"%@%@",@"￥",model.product_original];
        [_oldProice changeTextWithNewText:oldPrice];
    }

    //改变名字
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.product_name];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.product_name length])];
    _goodsNameLable.attributedText = attributedString;
    _goodsNameLable.textAlignment=1;

    //赋值产品ID
    _productID=model.ID;

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
