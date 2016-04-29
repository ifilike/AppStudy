//
//  NewTrackTableViewCell.m
//  QXD
//
//  Created by zhujie on 平成28-02-02.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import "NewTrackTableViewCell.h"

@implementation NewTrackTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    UILabel *statueL = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 23*PROPORTION_WIDTH, 75*PROPORTION_WIDTH, 17*PROPORTION_WIDTH)];
    statueL.text = @"物流信息:";
    statueL.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    statueL.textColor  = [self colorWithHexString:@"#999999"];
    statueL.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:statueL];
    
//    UILabel *idL = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 6*PROPORTION_WIDTH + CGRectGetMaxY(statueL.frame), 75*PROPORTION_WIDTH, 17*PROPORTION_WIDTH)];
//    idL.text = @"订单号:";
//    idL.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
//    idL.textColor  = [self colorWithHexString:@"#999999"];
//    idL.textAlignment = NSTextAlignmentRight;
//    [self.contentView addSubview:idL];
    
    
    self.titleView = [[UILabel alloc] initWithFrame:CGRectMake(96*PROPORTION_WIDTH, 23*PROPORTION_WIDTH, WIDTH - 115*PROPORTION_WIDTH, 17*PROPORTION_WIDTH)];
    self.titleView.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    self.titleView.textColor  =  [self colorWithHexString:@"#555555"];
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(96*PROPORTION_WIDTH, 6*PROPORTION_WIDTH + CGRectGetMaxY(statueL.frame), WIDTH - 115*PROPORTION_WIDTH, 17*PROPORTION_WIDTH)];
    
    self.detailLabel.font = [UIFont systemFontOfSize:12*PROPORTION_WIDTH];
    self.titleView.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.detailLabel];
    
    self.detailLabel.textColor = [self colorWithHexString:@"#999999"];
    
    //下划线
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 79*PROPORTION_WIDTH, WIDTH, 0.5)];
    lineV.backgroundColor = [self colorWithHexString:@"#DDDDDD"];
    [self.contentView addSubview:lineV];
    
}
-(void)configCellWithModle:(NewTrackModel *)newTrackModel{
    self.titleView.text  = newTrackModel.status;
    self.detailLabel.text = newTrackModel.time;
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