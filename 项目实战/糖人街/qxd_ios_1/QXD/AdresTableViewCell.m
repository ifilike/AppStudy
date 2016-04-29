//
//  AdresTableViewCell.m
//  QXD
//
//  Created by zhujie on 平成27-12-25.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "AdresTableViewCell.h"

@implementation AdresTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    //
    self.firstView = [[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 26*PROPORTION_WIDTH, WIDTH - 30*PROPORTION_WIDTH, 17*PROPORTION_WIDTH)];
    //shouhuoren
    UILabel *shouHuoRenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, 70*PROPORTION_WIDTH, 17*PROPORTION_WIDTH)];
    //收货人
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shouHuoRenLabel.frame)-10*PROPORTION_WIDTH, 0, 125*PROPORTION_WIDTH, 17*PROPORTION_WIDTH)];
    //shouji
    UILabel *shoujiLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), 0, 50*PROPORTION_WIDTH, 17*PROPORTION_WIDTH)];
    //手机
    self.phomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shoujiLabel.frame) -20*PROPORTION_WIDTH,0, 120*PROPORTION_WIDTH, 17*PROPORTION_WIDTH)];
    //调整布局
    shouHuoRenLabel.textColor = shoujiLabel.textColor = [self colorWithHexString:@"#999999"];
    shouHuoRenLabel.text = @"收货人:";shoujiLabel.text = @"手机:";
    self.nameLabel.textColor = self.phomeLabel.textColor = [self colorWithHexString:@"#555555"];
    self.phomeLabel.textAlignment = NSTextAlignmentRight;
    self.phomeLabel.font = self.nameLabel.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    //
    
    [self.firstView addSubview:self.phomeLabel];
    [self.firstView addSubview:self.nameLabel];
    [self.firstView addSubview:shouHuoRenLabel];
    [self.firstView addSubview:shoujiLabel];
    //收获地址
    self.secondeView = [[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH ,10*PROPORTION_WIDTH+CGRectGetMaxY(self.firstView.frame), WIDTH - 30*PROPORTION_WIDTH, 34*PROPORTION_WIDTH)];
//    self.addressNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 70, 20)];
//    self.addressNameLabel.text = @"配送地址";
//    self.addressNameLabel.font = [UIFont systemFontOfSize:15];
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.secondeView.frame.size.width, self.secondeView.frame.size.height)];
    self.addressLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    self.addressLabel.numberOfLines = 2;
    self.addressLabel.textColor = [self colorWithHexString:@"#999999"];
    [self.secondeView addSubview:self.addressLabel];
//    [self.secondeView addSubview:self.addressNameLabel];
    //画线
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    UIView *doV = [[UIView alloc] initWithFrame:CGRectMake(0, 109*PROPORTION_WIDTH, WIDTH, 0.5)];
    topV.backgroundColor = doV.backgroundColor = [self colorWithHexString:@"#DDDDDD"];
    [self.contentView addSubview:topV];
    [self.contentView addSubview:doV];
    
    [self.contentView addSubview:self.firstView];
    [self.contentView addSubview:self.secondeView];
}
-(void)configWithDictionary:(NSString *)name WithPhone:(NSString *)phone WithDetailAddress:(NSString *)address{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",name];
    self.phomeLabel.text = [NSString stringWithFormat:@"%@",phone];
    self.addressLabel.text = [NSString stringWithFormat:@"收货地址：%@",address];
    
    
    //行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.addressLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5*PROPORTION_WIDTH];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.addressLabel.text length])];
    self.addressLabel.attributedText = attributedString;
    [self.addressLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark  --- 颜色 ---
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
