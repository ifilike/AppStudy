//
//  SubGoodsView.m
//  QXD
//
//  Created by WZP on 15/11/16.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "SubGoodsView.h"
#import "DeleteLienLabel.h"
#import "ByxxrMode.h"
#import "TopLabel.h"

@implementation SubGoodsView


- (instancetype)initWithFrame:(CGRect)frame withModel:(ByxxrMode*)model{
    self=[super initWithFrame:frame];
    self.buyPrice=model.product_present_price;
    NSString * pp=@"￥";
    NSString * oldPrice=model.product_original;
    NSLog(@"%@",oldPrice);
    
    NSLog(@"%@",model.product_name);
    NSString * price=model.product_present_price;
    self.productID=model.ID;
    float yy=0;
    self.imageButton=[[UIButton alloc] initWithFrame:CGRectMake(9.5*PROPORTION_WIDTH, yy, 125*PROPORTION_WIDTH,125*PROPORTION_WIDTH)];
    _imageStr=model.product_img1;
    NSURL * url=[NSURL URLWithString:model.product_img1];
    UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, yy, frame.size.width,frame.size.width*250/288)];
    [imageView sd_setImageWithURL:url];
    
    //赋值图片
    [self addSubview:_imageButton];
    [self addSubview:imageView];
    yy+=frame.size.width*250/288+8*PROPORTION_WIDTH;
    self.goodsNameLable=[[TopLabel alloc] initWithFrame:CGRectMake(0, yy, frame.size.width, 35)];
    [_goodsNameLable setVerticalAlignment:VerticalAlignmentTop];

    //赋值产品名
    NSString * kk=[NSString stringWithString:model.product_name];
    NSLog(@"%@",kk);
    _goodsNameLable.textColor=[self colorWithHexString:@"#545454"];
    //设置行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:kk];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [kk length])];
    _goodsNameLable.attributedText = attributedString;
    _goodsNameLable.textAlignment=1;
    _goodsNameLable.numberOfLines=2;
    _goodsNameLable.font=[UIFont systemFontOfSize:12*PROPORTION_WIDTH];
    [self addSubview:_goodsNameLable];
    yy+=30+8*PROPORTION_WIDTH;
    self.goodsPriceLable=[[UILabel alloc] initWithFrame:CGRectMake(0, yy, frame.size.width/2-5, 20)];
    //赋值产品现价
    _goodsPriceLable.text=[NSString stringWithFormat:@"%@%@",pp,price];
    _goodsPriceLable.textAlignment=2;
    _goodsPriceLable.textColor=[self colorWithHexString:@"#FD681F"];
    _goodsPriceLable.font=[UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    [self addSubview:_goodsPriceLable];
    //赋值产品原价
    self.oldProice=[[DeleteLienLabel alloc] initWithFrame:CGRectMake(frame.size.width/2, yy+4, frame.size.width/2, 15) content:[NSString stringWithFormat:@"%@%@",pp,oldPrice] textColor:[self colorWithHexString:@"#999999"] textSize:11 deleteColor:[self colorWithHexString:@"#999999"]];
    [self addSubview:_oldProice];
    self.oldProice.textAlignment=0;
    if (model.product_original.length==0) {
        _oldProice.hidden=YES;
    
    }
    yy+=20;
    if ([model.product_is_discount isEqualToString:@"1"]) {
        self.discountBut=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33.33*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
        [_discountBut setBackgroundImage:[UIImage imageNamed:@"saletag"] forState:0];
        [_discountBut setTitle:@"折" forState:0];
        _discountBut.titleLabel.font=[UIFont systemFontOfSize:11*PROPORTION_WIDTH];
        _discountBut.titleLabel.textColor=[self colorWithHexString:@"#FFFFFF"];
        //    [_discountBut setTitleColor:[UIColor whiteColor] forState:0];
        [self addSubview:_discountBut];
    }

    self.frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, yy);
    
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

//- (instancetype)initWithFrame:(CGRect)frame{
//    self=[super initWithFrame:frame];
//    self.imageButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.width)];
//    
////    self.imageButton.backgroundColor=[UIColor redColor];
//    [self addSubview:_imageButton];
//    self.goodsNameLable=[[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.width, frame.size.width, 20)];
//    
////    _goodsNameLable.backgroundColor=[UIColor orangeColor];
//    _goodsNameLable.font=[UIFont systemFontOfSize:11];
//    [self addSubview:_goodsNameLable];
//    self.goodsPriceLable=[[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.width+20, frame.size.width/2, 20)];
//    
////    _goodsPriceLable.backgroundColor=[UIColor blackColor];
//    _goodsPriceLable.textAlignment=1;
//    _goodsPriceLable.textColor=[UIColor redColor];
//    _goodsPriceLable.font=[UIFont systemFontOfSize:11];
//    [self addSubview:_goodsPriceLable];
//    self.oldProice=[[DeleteLineLabel alloc] initWithFrame:CGRectMake(frame.size.width/2, frame.size.width+20, frame.size.width/2, 20) withTitle:nil];
//    _oldProice.font=[UIFont systemFontOfSize:11];
////    _oldProice.backgroundColor=[UIColor blackColor];
//    [self addSubview:_oldProice];
//    
//    self.frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.width+40);
//    
//    return self;
//
//}
//- (void)setModel:(ByxxrMode*)model{
//    
//    NSString * pp=@"￥";
//    NSString * oldPrice=model.product_original;
//    NSString * price=model.product_present_price;
//    self.productID=model.ID;
//    _imageStr=model.product_img1;
//    NSURL * url=[NSURL URLWithString:model.product_img1];
//    self.imageData=[NSData dataWithContentsOfURL:url];
//    UIImage * image=[UIImage imageWithData:_imageData];
//    //赋值图片
//    [_imageButton setBackgroundImage:image forState:0];
//    //赋值产品名
//    _goodsNameLable.text=model.product_name;
//    _goodsNameLable.font=[UIFont systemFontOfSize:11];
//    //赋值产品现价
//    _goodsPriceLable.text=[NSString stringWithFormat:@"%@%@",pp,price];
//    _goodsPriceLable.textAlignment=1;
//    _goodsPriceLable.textColor=[UIColor redColor];
//    _goodsPriceLable.font=[UIFont systemFontOfSize:11];
//    //赋值产品原价
//    [_oldProice changeTextWith:[NSString stringWithFormat:@"%@%@",pp,oldPrice]];
//    _oldProice.font=[UIFont systemFontOfSize:11];
//}
//

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
