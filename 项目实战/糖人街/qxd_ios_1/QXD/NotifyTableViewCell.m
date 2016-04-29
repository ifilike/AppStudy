//
//  NotifyTableViewCell.m
//  QXD
//
//  Created by zhujie on 平成28-01-11.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import "NotifyTableViewCell.h"

@implementation NotifyTableViewCell

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
    self.imageV = [[UIView alloc] initWithFrame:CGRectMake(21*PROPORTION_WIDTH, 15*PROPORTION_WIDTH, 40*PROPORTION_WIDTH, 40*PROPORTION_WIDTH)];
    self.imageV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"information_icon"]];
    [self.contentView addSubview:self.imageV];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageV.frame) + 20*PROPORTION_WIDTH, 15*PROPORTION_WIDTH, WIDTH - 102*PROPORTION_WIDTH, 40)];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.textColor = [self colorWithHexString:@"#999999"];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.backgroundColor = [self colorWithHexString:@"#f7f7f7"];
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



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
