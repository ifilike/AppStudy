//
//  OrderDetailTableViewCell.m
//  QXD
//
//  Created by zhujie on 平成27-11-22.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "OrderDetailTableViewCell.h"
#import "OrderDetailModel.h"

@implementation OrderDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor cyanColor];
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    //图片
    self.detailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25*PROPORTION_WIDTH, 15*PROPORTION_WIDTH, 60*PROPORTION_WIDTH, 60*PROPORTION_WIDTH)];
    self.detailImageView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self.contentView addSubview:self.detailImageView];
    //名称
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(25*PROPORTION_WIDTH + CGRectGetMaxX(self.detailImageView.frame), 15*PROPORTION_WIDTH, WIDTH - 40*PROPORTION_WIDTH - CGRectGetMaxX(self.detailImageView.frame), 50*PROPORTION_WIDTH)];
    self.detailLabel.font = [UIFont systemFontOfSize:15*PROPORTION_WIDTH];
    self.detailLabel.textColor = [self colorWithHexString:@"#555555"];
    self.detailLabel.numberOfLines = 2;
    [self.contentView addSubview:self.detailLabel];
    //规格
    self.detailDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(25*PROPORTION_WIDTH + CGRectGetMaxX(self.detailImageView.frame), CGRectGetMaxY(self.detailLabel.frame)- 2*PROPORTION_WIDTH, WIDTH - 40*PROPORTION_WIDTH - CGRectGetMaxX(self.detailImageView.frame), 10*PROPORTION_WIDTH)];
    self.detailDetailLabel.font = [UIFont systemFontOfSize:10*PROPORTION_WIDTH];
    self.detailDetailLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    [self.contentView addSubview:self.detailDetailLabel];
    
    //钱总数
    self.detailMoneyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(25*PROPORTION_WIDTH + CGRectGetMaxX(self.detailImageView.frame),CGRectGetMaxY(self.detailDetailLabel.frame), (WIDTH - 40*PROPORTION_WIDTH - CGRectGetMaxX(self.detailImageView.frame))/2.0, 25*PROPORTION_WIDTH)];
    [self.contentView addSubview:self.detailMoneyCountLabel];
    //商品总数
    self.detailTotalCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.detailMoneyCountLabel.frame),  CGRectGetMaxY(self.detailDetailLabel.frame)  , (WIDTH - 40*PROPORTION_WIDTH - CGRectGetMaxX(self.detailImageView.frame))/2.0 - 20*PROPORTION_WIDTH, 25*PROPORTION_WIDTH)];
    self.detailTotalCountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.detailTotalCountLabel];
    
    
    self.detailTotalCountLabel.font = self.detailMoneyCountLabel.font = [UIFont systemFontOfSize:12*PROPORTION_WIDTH];
    self.detailTotalCountLabel.textColor = self.detailMoneyCountLabel.textColor = [self colorWithHexString:@"FD681F"];
    //颜色
//    self.detailImageView.backgroundColor = [UIColor yellowColor];
//    self.detailLabel.backgroundColor = [UIColor redColor];
//    self.detailTotalCountLabel.backgroundColor = [UIColor blueColor];
//    self.detailMoneyCountLabel.backgroundColor = [UIColor orangeColor];
    //为了满足所购商品的申请售后 加强代码的复用
    self.serviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(275*PROPORTION_WIDTH,10*PROPORTION_WIDTH + CGRectGetMaxY(self.detailTotalCountLabel.frame), 80*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    [self.serviceBtn setTitle:@"申请售后" forState:UIControlStateNormal];
    [self.serviceBtn setTitleColor:[self colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.serviceBtn.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    self.serviceBtn.layer.borderWidth = 0.5;
    self.serviceBtn.layer.borderColor = [[self colorWithHexString:@"#999999"] CGColor];
    self.serviceBtn.layer.cornerRadius = 5;
    self.serviceBtn.layer.masksToBounds = YES;
    self.serviceBtn.hidden = YES;
    [self.serviceBtn addTarget:self action:@selector(Service:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.serviceBtn];
    //画线
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    UIView *doV = [[UIView alloc] initWithFrame:CGRectMake(0, 109*PROPORTION_WIDTH, WIDTH, 0.5)];
    topV.backgroundColor = doV.backgroundColor = [self colorWithHexString:@"#DDDDDD"];
    self.doV = doV;
    self.doV.hidden = YES;
    [self.contentView addSubview:topV];
    [self.contentView addSubview:doV];
}
#pragma mark ---- 我的全部订单的展示页面 ----
-(void)configCellWithModel:(OrderDetailModel *)orderDetailModel{
//    [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:orderDetailModel.detailImageView]];
//   
//    
//    self.detailLabel.text = orderDetailModel.detailLabel;
//    
//    self.detailTotalCountLabel.text = orderDetailModel.detailTotalCountLabel;
//    
//    self.detailMoneyCountLabel.text = orderDetailModel.detailMoneyCountLabel;
    
    [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:orderDetailModel.product_img]];
//    self.detailLabel.text = [NSString stringWithFormat:@"%@",orderDetailModel.product_name];
    self.detailTotalCountLabel.text = [NSString stringWithFormat:@"X %@",orderDetailModel.product_num];
    self.detailMoneyCountLabel.text = [NSString stringWithFormat:@"￥%@",orderDetailModel.product_price];
    self.detailDetailLabel.text = orderDetailModel.product_standard;
    
    
    //行间距
    self.detailLabel.text = @"行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.detailLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5*PROPORTION_WIDTH];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.detailLabel.text length])];
    self.detailLabel.attributedText = attributedString;
    [self.detailLabel sizeToFit];
    self.detailLabel.text = [NSString stringWithFormat:@"%@",orderDetailModel.product_name];
}
#pragma mark ---- 我的全部订单的展示页面 ----
-(void)configCellWithModel:(OrderDetailModel *)orderDetailModel WithStatue:(NSString *)string{
    //判断 审核 还是通过审核
    if ([orderDetailModel.apply isEqualToString:@"1"]) {
        self.doV.hidden = NO;
        [self.serviceBtn setTitle:@"申请售后" forState:UIControlStateNormal];
        self.doV.frame = CGRectMake(0, 159*PROPORTION_WIDTH, WIDTH, 0.5);
    }else if([orderDetailModel.apply isEqualToString:@"2"]){
        self.doV.hidden = NO;
        [self.serviceBtn setTitle:@"待审核" forState:UIControlStateNormal];
        self.doV.frame = CGRectMake(0, 159*PROPORTION_WIDTH, WIDTH, 0.5);
    }
    
    
    
    [self configCellWithModel:orderDetailModel];
    self.serviceBtn.hidden = NO;
    if (!([string isEqualToString:@"dpj"] || [string isEqualToString:@"ypj"] || [string isEqualToString:@"jycg"])) {
        self.serviceBtn.hidden = YES;
          self.doV.frame = CGRectMake(0, 109*PROPORTION_WIDTH, WIDTH, 0.5);
    }
}
#pragma mark ---- 申请售后 ---
-(void)Service:(UIButton *)button{
    // 用户id 产品id
    self.getDataBlock(button);
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
