//
//  PayTableViewCell.m
//  QXD
//
//  Created by zhujie on 平成27-12-08.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "PayTableViewCell.h"

@implementation PayTableViewCell

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
    self.iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 15*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImg.frame)+14*PROPORTION_WIDTH, 10*PROPORTION_WIDTH, 100*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    self.selectButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 40*PROPORTION_WIDTH, 15*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
    
    self.iconImg.backgroundColor = [UIColor whiteColor];
    self.iconImg.layer.cornerRadius =  2;
    self.iconImg.layer.masksToBounds = YES;
//    self.selectButton.backgroundColor = [UIColor blackColor];
//    [self.selectButton setTitle:@"no" forState:UIControlStateNormal];
//    [self.selectButton setTitle:@"yes" forState:UIControlStateSelected];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"select_normal_icon"] forState:UIControlStateNormal];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"select_selected_icon"] forState:UIControlStateSelected];
    
    
    [self.contentView addSubview:self.iconImg];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selectButton];
    [self.selectButton addTarget:self action:@selector(clickWith:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickWith:(UIButton *)button{
    self.SelectPay(button);
}
-(void)configCellWithString:(NSString *)string WithPayType:(NSString *)payType{
    self.titleLabel.text = string;
    self.titleLabel.textColor = [self colorWithHexString:@"#555555"];
    if ([self.titleLabel.text isEqualToString:@"支付宝"]) {
        self.iconImg.image = [UIImage imageNamed:@"zhifubao_icon"];
//        if ([payType isEqualToString:@"zfb"]) {
//            self.selectButton.selected = YES;
//        }
    }else{
        self.iconImg.image = [UIImage imageNamed:@"weixin_icon_icon"];
//        if ([payType isEqualToString:@"wx"]) {
//            self.selectButton.selected = YES;
//        }
    }
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
