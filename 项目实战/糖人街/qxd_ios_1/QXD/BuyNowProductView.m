//
//  BuyNowProductView.m
//  QXD
//
//  Created by wzp on 16/1/19.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "BuyNowProductView.h"
#import "ZTProductListModel.h"

@implementation BuyNowProductView


- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //产品图片
        self.imageView2=[[UIImageView alloc] initWithFrame:CGRectMake(0, 10*PROPORTION_WIDTH, frame.size.height-20*PROPORTION_WIDTH, frame.size.height-20*PROPORTION_WIDTH)];
      //  _imageView2.backgroundColor=[UIColor orangeColor];
        [self addSubview:_imageView2];
        
        //产品名
        self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(100*PROPORTION_WIDTH, 10*PROPORTION_WIDTH, (345-100)*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
        self.nameLabel.text=@"SNP动物补水保湿面膜";
        self.nameLabel.font=[UIFont systemFontOfSize:17*PROPORTION_WIDTH];
        self.nameLabel.textColor=[self colorWithHexString:@"#555555"];
        
//        _nameLabel.backgroundColor=[UIColor redColor];
        [self addSubview:_nameLabel];
        
        //产品简介
        self.detailsLabel=[[UILabel alloc] initWithFrame:CGRectMake(100*PROPORTION_WIDTH, 40*PROPORTION_WIDTH, (345-100)*PROPORTION_WIDTH, 50*PROPORTION_WIDTH)];
        self.detailsLabel.numberOfLines=2;
        self.detailsLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        self.detailsLabel.textColor=[self colorWithHexString:@"#666666"];
        
        NSString *labelText = @"祛痘效果明显,物美价廉.精心挑选搭配,还您光滑脸庞祛痘效果明显,物美价廉.精心挑选搭配";
        
        //设置行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        self.detailsLabel.attributedText = attributedString;
        NSLog(@"高度是:%f",_detailsLabel.frame.size.height);
        
//        _detailsLabel.backgroundColor=[UIColor purpleColor];
        [self addSubview:_detailsLabel];
        
        
        //立即购买
        self.buyBut=[[UIButton alloc] initWithFrame:CGRectMake((345-10-35)*PROPORTION_WIDTH, (120-35)*PROPORTION_WIDTH, 35*PROPORTION_WIDTH, 35*PROPORTION_WIDTH)];
        [self.buyBut setImage:[UIImage imageNamed:@"shopping cart_icon"] forState:0];
        //_buyBut.backgroundColor=[UIColor brownColor];
        [self addSubview:_buyBut];
        
        
        self.layer.cornerRadius=5;
        self.layer.borderWidth=0.5;
        self.layer.borderColor=[self colorWithHexString:@"#DDDDDD"].CGColor;
//        self.backgroundColor=[UIColor greenColor];
        
    }

    return self;


}
- (void)setZTProductListModel:(ZTProductListModel*)model tag:(NSInteger)tag{

    //产品图片
    NSURL * url=[NSURL URLWithString:model.product_img1];
    [_imageView2 sd_setImageWithURL:url];
    //产品名
    _nameLabel.text=model.product_name;
    //产品简介
    NSString *labelText = model.product_details;
    
    //设置行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.detailsLabel.attributedText = attributedString;

    _buyBut.tag=tag;

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
