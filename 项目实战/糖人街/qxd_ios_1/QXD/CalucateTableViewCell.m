//
//  CalucateTableViewCell.m
//  QXD
//
//  Created by zhujie on 平成27-12-07.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "CalucateTableViewCell.h"
#import "FriendsModel.h"

@implementation CalucateTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return  self;
}
-(void)creatUI{
    self.iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 15*PROPORTION_WIDTH, 100*PROPORTION_WIDTH, 100*PROPORTION_WIDTH)];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImg.frame) + 10*PROPORTION_WIDTH, 30*PROPORTION_WIDTH, WIDTH - 140*PROPORTION_WIDTH ,45*PROPORTION_WIDTH )];
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImg.frame)+10*PROPORTION_WIDTH, CGRectGetMaxY(self.titleLabel.frame), self.titleLabel.frame.size.width, 20*PROPORTION_WIDTH)];
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImg.frame) + 10*PROPORTION_WIDTH, CGRectGetMaxY(self.detailLabel.frame), self.titleLabel.frame.size.width/2 - 5*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
    
    self.priceNumbelLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame) + 10*PROPORTION_WIDTH, CGRectGetMaxY(self.detailLabel.frame), self.titleLabel.frame.size.width/2 - 20*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
    
    
    
    self.iconImg.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
//    self.titleLabel.backgroundColor = [UIColor cyanColor];
//    self.detailLabel.backgroundColor = [UIColor yellowColor];
//    self.priceLabel.backgroundColor = [UIColor orangeColor];
//    self.priceNumbelLabel.backgroundColor = [UIColor redColor];

    
    [self addSubview:self.iconImg];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.priceNumbelLabel];
    
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    self.titleLabel.textColor = [self colorWithHexString:@"#555555"];
    self.detailLabel.font = [UIFont systemFontOfSize:10*PROPORTION_WIDTH];
    self.detailLabel.textColor = [self colorWithHexString:@"#999999"];
    
    self.priceLabel.font = self.priceNumbelLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    self.priceLabel.textColor = self.priceNumbelLabel.textColor = [self colorWithHexString:@"#FD681F"];
    
    self.priceNumbelLabel.textAlignment = NSTextAlignmentRight;
    
}
-(void)configCellWithShopCarModel:(FriendsModel *)modle{
    
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:modle.product_img]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",modle.product_name];
    self.detailLabel.text = [NSString stringWithFormat:@"%@",modle.product_standard];
    self.priceLabel.text = [NSString stringWithFormat:@" ￥%@",modle.product_price];
    self.priceNumbelLabel.text = [NSString stringWithFormat:@"X %@",modle.product_num];

    
    

    //行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5*PROPORTION_WIDTH];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.titleLabel.text length])];
    self.titleLabel.attributedText = attributedString;
    [self.titleLabel sizeToFit];
}


#pragma mark --- 颜色 ---
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

-(void)setFrame:(CGRect)frame{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
