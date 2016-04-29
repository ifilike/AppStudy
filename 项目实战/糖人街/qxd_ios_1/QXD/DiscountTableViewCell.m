//
//  DiscountTableViewCell.m
//  QXD
//
//  Created by zhujie on 平成27-12-17.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "DiscountTableViewCell.h"
#import "DiscountModle.h"

@implementation DiscountTableViewCell

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
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 15*PROPORTION_WIDTH, 177, 84*PROPORTION_WIDTH)];
    UILabel *Ylabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 37*PROPORTION_WIDTH, 15, 14*PROPORTION_WIDTH)];
    Ylabel.text = @"￥";
    Ylabel.textColor = [UIColor whiteColor];
    Ylabel.font = [UIFont systemFontOfSize:12];
    [self.imgView addSubview:Ylabel];
    
    self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30*PROPORTION_WIDTH, 50, 24*PROPORTION_WIDTH)];
    
    self.useLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 25*PROPORTION_WIDTH, 110, 15*PROPORTION_WIDTH)];
    self.useLabel.textAlignment = NSTextAlignmentRight;
    self.useLabel.font = [UIFont systemFontOfSize:12];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 45*PROPORTION_WIDTH, 110, 15*PROPORTION_WIDTH)];
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imgView.frame.size.width + 20, 36*PROPORTION_WIDTH, 115, 14*PROPORTION_WIDTH)];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [self colorWithHexString:@"#555555"];
    
    self.limitTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imgView.frame.size.width + 20, CGRectGetMaxY(self.titleLabel.frame) + 20*PROPORTION_WIDTH, 115, 14*PROPORTION_WIDTH)];
    self.limitTimeLabel.font = [UIFont systemFontOfSize:14];
    self.limitTimeLabel.textColor = [self colorWithHexString:@"#FD681F"];
    
    //颜色
    self.imgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"coupon_Unused_icon"]];
//    self.moneyLabel.backgroundColor = [UIColor redColor];
//    self.useLabel.backgroundColor = [UIColor yellowColor];
//    self.timeLabel.backgroundColor = [UIColor cyanColor];
//    self.titleLabel.backgroundColor = [UIColor blueColor];
//    self.limitTimeLabel.backgroundColor = [UIColor yellowColor];
    self.moneyLabel.font = [UIFont systemFontOfSize:20];
    self.moneyLabel.textColor = [UIColor whiteColor];
    self.useLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.limitTimeLabel.textColor = [UIColor redColor];
    
    
    [self.imgView addSubview:self.moneyLabel];
    [self.imgView addSubview:self.useLabel];
    [self.imgView addSubview:self.timeLabel];
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.limitTimeLabel];
   
}
-(void)configCellWithModle:(DiscountModle *)model{
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",model.coupon_sums];
    self.useLabel.text = model.condition_descript;
    self.timeLabel.text = model.deadline;
    self.titleLabel.text = model.coupon_descript;
    self.limitTimeLabel.text = [NSString stringWithFormat:@"还有%d天过期",[model.time_limt intValue]];
    self.limitTimeLabel.textColor = [self colorWithHexString:@"#FD681F"];
}

#pragma mark ---- 颜色 ---
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

    // Configure the view for the selected state
}

@end
