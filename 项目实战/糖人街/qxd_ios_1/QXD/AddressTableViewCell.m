//
//  AddressTableViewCell.m
//  QXD
//
//  Created by zhujie on 平成27-11-25.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "AddressTableViewCell.h"
#import "AddressModel.h"

@implementation AddressTableViewCell

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
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*PROPORTION_WIDTH, 28*PROPORTION_WIDTH, WIDTH - 250*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    [self addSubview:self.titleLabel];
    self.phoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 28*PROPORTION_WIDTH, 160*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    [self addSubview:self.phoneNumber];
    self.phoneNumber.textAlignment = NSTextAlignmentRight;
//    self.titleLabel.backgroundColor = [UIColor redColor];
//    self.phoneNumber.backgroundColor = [UIColor blueColor];
    self.titleLabel.font = self.phoneNumber.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    self.titleLabel.textColor = self.phoneNumber.textColor = [self colorWithHexString:@"#555555"];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*PROPORTION_WIDTH,10*PROPORTION_WIDTH+ CGRectGetMaxY(self.titleLabel.frame), WIDTH - 95*PROPORTION_WIDTH, 48*PROPORTION_WIDTH)];
    self.detailLabel.font = [UIFont  systemFontOfSize:12];
    self.detailLabel.numberOfLines = 2;
//    self.detailLabel.backgroundColor =[UIColor yellowColor];
    self.detailLabel.textColor = [self colorWithHexString:@"#555555"];
    self.detailLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    [self addSubview:self.detailLabel];
    
    self.selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 45*PROPORTION_WIDTH, 10*PROPORTION_WIDTH+CGRectGetMaxY(self.titleLabel.frame), 25*PROPORTION_WIDTH, 25*PROPORTION_WIDTH)];
//    self.selectBtn.backgroundColor = [UIColor cyanColor];
    [self addSubview:self.selectBtn];
    self.backgroundColor  = [UIColor clearColor];
    //给每个cell 添加下划线
    UIView *lineCell = [[UIView alloc] initWithFrame:CGRectMake(20*PROPORTION_WIDTH, 124*PROPORTION_WIDTH, WIDTH - 40*PROPORTION_WIDTH, 0.5)];
    lineCell.backgroundColor = [self colorWithHexString:@"#DDDDDD"];
    [self addSubview:lineCell];
    
}


-(void)configCellWithAddressModel:(AddressModel *)model{
    
    [self.selectBtn setImage:nil forState:UIControlStateNormal];
    [self.selectBtn setImage:nil forState:UIControlStateSelected];
    //不能操作  改需求
//    self.userInteractionEnabled = NO;
    self.userInteractionEnabled = YES;
    
    self.province = model.province;
    if ([model.selected isEqualToString:@"0"]) {
        self.province = [NSString stringWithFormat:@"[默认] %@",model.province];
        self.selectBtn.selected = YES;
        [self.selectBtn setImage:[UIImage imageNamed:@"select_selected_icon"] forState:UIControlStateSelected];
        self.buttonSelcect = self.selectBtn;
    }
    self.titleLabel.text = model.name;
    self.phoneNumber.text = [NSString stringWithFormat:@"手机:%@",model.phone];
    self.detailLabel.text = [NSString stringWithFormat:@"%@%@ %@%@",self.province,model.city,model.area,model.address];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aaaa:) name:@"123" object:nil];
    
//    self.backgroundColor = [UIColor clearColor];
//    if ([model.selected isEqualToString:@"0"]) {
//        self.backgroundColor = [UIColor yellowColor];
//    }
    //行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.detailLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10*PROPORTION_WIDTH];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.detailLabel.text length])];
    if ([self.detailLabel.text hasPrefix:@"[默认]"]) {
        [attributedString setAttributes:@{NSForegroundColorAttributeName:[self colorWithHexString:@"#FD681F"], NSFontAttributeName:[UIFont systemFontOfSize:14*PROPORTION_WIDTH]} range:NSMakeRange(0, 5)];
    }
    self.detailLabel.attributedText = attributedString;
    [self.detailLabel sizeToFit];
}
-(void)aaaa:(NSNotification *)noti{
        if (self.buttonSelcect.selected == YES) {
            self.isSelcect(self.buttonSelcect);
            self.buttonSelcect.selected = YES;
        }

    self.userInteractionEnabled = YES;
    [self.selectBtn setImage:[UIImage imageNamed:@"me_feedback"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"me_about"] forState:UIControlStateSelected];
    [self.selectBtn addTarget:self action:@selector(changMorenBtnState:) forControlEvents:UIControlEventTouchUpInside];
//    self.isSelcect(self.buttonSelcect);
}
-(void)bbb{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    self.selectBtn.hidden = YES;
    
}


-(void)changMorenBtnState:(UIButton *)button{
    self.cellSelect(button);
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
