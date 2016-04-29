//
//  ScheduleTableViewCell.m
//  QXD
//
//  Created by zhujie on 平成28-01-22.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import "ScheduleTableViewCell.h"
#import "ScheduleModle.h"

@implementation ScheduleTableViewCell

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
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, WIDTH - 80*PROPORTION_WIDTH, 40*PROPORTION_WIDTH)];
    
    self.detailLabe = [[UILabel alloc] initWithFrame:CGRectMake(60*PROPORTION_WIDTH, CGRectGetMaxY(self.titleLabel.frame) + 5*PROPORTION_WIDTH, WIDTH - 80*PROPORTION_WIDTH, 12*PROPORTION_WIDTH)];
    
//    self.titleLabel.backgroundColor = [UIColor redColor];
//    self.detailLabe.backgroundColor = [UIColor cyanColor];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textColor = [self colorWithHexString:@"#555555"];
    self.titleLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    
    self.detailLabe.textColor = [self colorWithHexString:@"#999999"];
    self.detailLabe.font = [UIFont systemFontOfSize:12*PROPORTION_WIDTH];
    
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabe];
}
-(void)configCellWithModel:(ScheduleModle *)modle{
    self.titleLabel.text = modle.content;
    self.detailLabe.text = modle.create_time;
    
    
    //行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5*PROPORTION_WIDTH];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.titleLabel.text length])];
    self.titleLabel.attributedText = attributedString;
    [self.titleLabel sizeToFit];
}
#pragma mark --- 改变颜色 ---
-(void)changeColorWithOrgen{
    self.titleLabel.textColor = [self colorWithHexString:@"#FD681F"];
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
