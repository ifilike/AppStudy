//
//  LastCollectionViewCell.m
//  QXD
//
//  Created by zhujie on 平成27-11-23.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "LastCollectionViewCell.h"
#import "DeleteLienLabel.h"

@implementation LastCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 158*PROPORTION_WIDTH, 158*PROPORTION_WIDTH)];
    self.detailView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame) + 0*PROPORTION_WIDTH, 158*PROPORTION_WIDTH, 60*PROPORTION_WIDTH)];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*PROPORTION_WIDTH, 10*PROPORTION_WIDTH, 138*PROPORTION_WIDTH, 138*PROPORTION_WIDTH)];
    [self.titleView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*PROPORTION_WIDTH ,0 , 138*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame), WIDTH/2 -40, (WIDTH/4 - 10)/3)];
//    self.priceView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.detailLabel.frame), WIDTH/2 -40, (WIDTH/4 - 10)/3)];
    self.priceView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+12*PROPORTION_WIDTH, 138*PROPORTION_WIDTH, 18*PROPORTION_WIDTH)];
    
    self.todayPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (self.priceView.frame.size.width)/2 -10*PROPORTION_WIDTH, (self.priceView.frame.size.height))];
    self.yestodayPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.todayPriceLabel.frame) +20*PROPORTION_WIDTH, 0, (self.priceView.frame.size.width)/2, (self.priceView.frame.size.height))];
    [self.priceView addSubview:self.todayPriceLabel];
    [self.priceView addSubview:self.yestodayPriceLabel];
    
    [self.detailView addSubview:self.titleLabel];
//    [self.detailView addSubview:self.detailLabel];//不需要详情
    [self.detailView addSubview:self.priceView];
    
//    self.todayPriceLabel.backgroundColor = [UIColor redColor];
//    self.yestodayPriceLabel.backgroundColor = [UIColor cyanColor];
//    self.titleLabel.backgroundColor = [UIColor blueColor];
//    self.detailLabel.backgroundColor = [UIColor brownColor];
//    self.priceView.backgroundColor = [UIColor purpleColor];
    self.imageView.backgroundColor =[UIColor colorWithWhite:0.9 alpha:1];
//    self.titleView.backgroundColor = [UIColor yellowColor];
//    self.detailView.backgroundColor = [UIColor orangeColor];
//    self.backgroundColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:12*PROPORTION_WIDTH];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textColor = [self colorWithHexString:@"#555555"];
    self.todayPriceLabel.textAlignment = NSTextAlignmentRight;
    self.todayPriceLabel.textColor = [self colorWithHexString:@"#FD681F"];
    self.todayPriceLabel.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    self.yestodayPriceLabel.textColor = [self colorWithHexString:@"#999999"];
    self.yestodayPriceLabel.font = [UIFont systemFontOfSize:10*PROPORTION_WIDTH];
    
    //边缘划线
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
//    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.titleView.frame.size.width, 1)];
//    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
//    [self.detailView addSubview:lineView];
    
    [self addSubview:self.titleView];
    [self addSubview:self.detailView];
}

-(void)configCollectionCellWithModel:(LastCollectionModel *)lastCollectionModel{
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:lastCollectionModel.imageView]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",lastCollectionModel.titleLabel];
    NSLog(@"%@",lastCollectionModel.detailLabel);
    self.detailLabel.text = lastCollectionModel.detailLabel;
    self.todayPriceLabel.text = [NSString stringWithFormat:@"￥%@",lastCollectionModel.todayPriceLabel];
    self.yestodayPriceLabel.text = [NSString stringWithFormat:@"￥%@",lastCollectionModel.yestodayPriceLabel];
    NSLog(@"selfIDLogWithHopeID:%@",lastCollectionModel.selfID);
    NSDictionary *dict = [NSDictionary dictionary];
    dict = @{NSFontAttributeName:[UIFont systemFontOfSize:10*PROPORTION_WIDTH],
                        NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                        NSStrikethroughColorAttributeName:[self colorWithHexString:@"#999999"]};
    
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:self.yestodayPriceLabel.text
                                   attributes:dict];
    self.yestodayPriceLabel.attributedText = attrStr;
   
    
    //行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5*PROPORTION_WIDTH];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.titleLabel.text length])];
    self.titleLabel.attributedText = attributedString;
    [self.titleLabel sizeToFit];
    //划线
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(-2*PROPORTION_WIDTH, self.priceView.frame.size.height/2.0, self.yestodayPriceLabel.text.length *10*PROPORTION_WIDTH, 1)];
    lineV.backgroundColor = [self colorWithHexString:@"#999999"];
//    [self.yestodayPriceLabel addSubview:lineV];
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
