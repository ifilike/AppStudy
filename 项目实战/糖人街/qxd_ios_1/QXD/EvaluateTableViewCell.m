//
//  EvaluateTableViewCell.m
//  QXD
//
//  Created by zhujie on 平成27-12-23.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "EvaluateTableViewCell.h"
#import "EvaluateModle.h"

@implementation EvaluateTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    self.iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(20*PROPORTION_WIDTH, 25*PROPORTION_WIDTH, 55*PROPORTION_WIDTH, 50*PROPORTION_WIDTH)];
    self.clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(280*PROPORTION_WIDTH, 35*PROPORTION_WIDTH, 80*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImg.frame) +20*PROPORTION_WIDTH, 30*PROPORTION_WIDTH, 140*PROPORTION_WIDTH, 35*PROPORTION_WIDTH)];
    
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    self.titleLabel.textColor = [self colorWithHexString:@"#555555"];

    //颜色
    self.iconImg.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
//    self.titleLabel.backgroundColor = [UIColor cyanColor];
    
    self.clickBtn.layer.borderWidth = 1;
    self.clickBtn.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
//    [self.clickBtn setTitle:@"评价" forState:UIControlStateNormal];
    [self.clickBtn setTitleColor:[self colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self.clickBtn addTarget:self action:@selector(pinjia:) forControlEvents:UIControlEventTouchUpInside];
    self.clickBtn.layer.cornerRadius = 5*PROPORTION_WIDTH;
    self.clickBtn.layer.masksToBounds = YES;

    
    [self.contentView addSubview:self.iconImg];
    [self.contentView addSubview:self.clickBtn];
    [self.contentView addSubview:self.titleLabel];
    
}
-(void)configWithEvaluatModel:(EvaluateModle *)model{
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.product_img]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.product_name];
    
    if ([model.is_comment isEqualToString:@"1"]) {
        [self.clickBtn setTitle:@"已评价" forState:UIControlStateNormal];
    }else{
        [self.clickBtn setTitle:@"评价" forState:UIControlStateNormal];
    }
    
    
    //行间距
    self.titleLabel.text = @"行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3*PROPORTION_WIDTH];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.titleLabel.text length])];
    self.titleLabel.attributedText = attributedString;
    [self.titleLabel sizeToFit];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.product_name];

}
-(void)pinjia:(UIButton *)button{
    self.DetailBlock();
}

-(void)setFrame:(CGRect)frame{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

@end
