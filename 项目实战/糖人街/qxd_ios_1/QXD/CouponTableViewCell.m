//
//  CouponTableViewCell.m
//  QXD
//
//  Created by zhujie on 平成27-12-07.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "CouponTableViewCell.h"
#import "DiscountModle.h"

@implementation CouponTableViewCell

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
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 10*PROPORTION_WIDTH, WIDTH - 100*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    
    self.SelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 50*PROPORTION_WIDTH , 10*PROPORTION_WIDTH, 30*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
//    [self.SelectBtn setTitle:@"未点击" forState:UIControlStateNormal];
//    [self.SelectBtn setTitle:@"点击" forState:UIControlStateSelected];
    [self.SelectBtn setImage:[UIImage imageNamed:@"select_normal_icon"] forState:UIControlStateNormal];
    [self.SelectBtn setImage:[UIImage imageNamed:@"select_selected_icon"] forState:UIControlStateSelected];
    
//    self.titleLabel.backgroundColor = [UIColor yellowColor];
//    self.SelectBtn.backgroundColor = [UIColor redColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.SelectBtn];
    
    self.titleLabel.textColor = [self colorWithHexString:@"#555555"];
    self.titleLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    
    [self.SelectBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)configWithDisModle:(DiscountModle *)modle{
    self.SelectBtn.selected = NO;
    self.titleLabel.text = modle.coupon_descript;
    self.money = modle.coupon_sums;
    self.youfei = modle.coupon_type;
    self.youhuijuanID = modle.ID; 
}
-(void)configWithDis:(DiscountModle *)modle{
    self.SelectBtn.selected = YES;
    self.titleLabel.text = modle.coupon_descript;
    self.money = modle.coupon_sums;
    self.youfei = modle.coupon_type;
    self.youhuijuanID = modle.ID;
    
    self.moneyBlock(self.money);
    self.youfeiBlock(self.youfei);
    self.youhuijuanBlock(self.youhuijuanID);
    self.SelectWithSelect(self.SelectBtn);
}

-(void)click:(UIButton *)btn{
    self.moneyBlock(self.money);
    self.youfeiBlock(self.youfei);
    self.youhuijuanBlock(self.youhuijuanID);
    self.SelectBtnWithCoupon(btn);
    
    //新加功能 点击时候缩回去
    self.dismisss(self.titleLabel.text);
    
    NSLog(@"-------btn ---click---------%@",self.titleLabel.text);
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
