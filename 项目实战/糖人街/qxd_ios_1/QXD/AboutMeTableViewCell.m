//
//  AboutMeTableViewCell.m
//  QXD
//
//  Created by zhujie on 平成27-11-16.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "AboutMeTableViewCell.h"



@implementation AboutMeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatCell];
    }
    return self;
}

-(void)creatCell{
    
        self.icon_bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
        [self.contentView addSubview:self.icon_bg];
    
    self.labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.bounds.size.width , 60)];
    [self.contentView addSubview:self.labelView];
    
    
    
    
    
    float leftWidth = (WIDTH - (100*3*PROPORTION_WIDTH))/2;//65*PROPORTION_WIDTH;
    float width = 100*PROPORTION_WIDTH;//(WIDTH - (65*4*PROPORTION_WIDTH))/3;
    UIView *AllView = [[UIView alloc] initWithFrame:CGRectMake(0, 20*PROPORTION_WIDTH, WIDTH, 40*PROPORTION_WIDTH)];
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(leftWidth, 0, width, 40*PROPORTION_WIDTH)];
    //        [button1 setTitle:@"待付款" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button1.frame), 0, width, 40*PROPORTION_WIDTH)];
    //        [button2 setTitle:@"待发货" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button2.frame), 0, width, 40*PROPORTION_WIDTH)];
    //        [button3 setTitle:@"待收货" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20*PROPORTION_WIDTH, button1.bounds.size.width, 20*PROPORTION_WIDTH)];
    label1.text = @"待付款";
    [button1 addSubview:label1];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20*PROPORTION_WIDTH, button1.bounds.size.width, 20*PROPORTION_WIDTH)];
    label2.text = @"待发货";
    [button2 addSubview:label2];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20*PROPORTION_WIDTH, button1.bounds.size.width, 20*PROPORTION_WIDTH)];
    label3.text = @"待收货";
    [button3 addSubview:label3];
    label1.backgroundColor = [UIColor whiteColor];
    label2.backgroundColor = [UIColor whiteColor];
    label3.backgroundColor = [UIColor whiteColor];
    label1.textColor = label2.textColor = label3.textColor = [self colorWithHexString:@"#555555"];
    label1.font = label2.font = label3.font = [UIFont systemFontOfSize:14];
    label1.textAlignment = label2.textAlignment = label3.textAlignment = NSTextAlignmentCenter;
    label1.backgroundColor = label2.backgroundColor = label3.backgroundColor = [self colorWithHexString:@"f7f7f7"];
    
    [AllView addSubview:button1];
    [AllView addSubview:button2];
    [AllView addSubview:button3];
    
    //添加图片
    UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(37*PROPORTION_WIDTH, -5*PROPORTION_WIDTH, 28*PROPORTION_WIDTH, 28*PROPORTION_WIDTH)];
    imageV1.image = [UIImage imageNamed:@"payment_icon"];
    [button1 addSubview:imageV1];
    UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(37*PROPORTION_WIDTH, -5*PROPORTION_WIDTH, 28*PROPORTION_WIDTH, 28*PROPORTION_WIDTH)];
    imageV2.image = [UIImage imageNamed:@"Ship_icon"];
    [button2 addSubview:imageV2];
    UIImageView *imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(37*PROPORTION_WIDTH, -5*PROPORTION_WIDTH, 28*PROPORTION_WIDTH, 28*PROPORTION_WIDTH)];
    imageV3.image = [UIImage imageNamed:@"Receiving_icon"];
    [button3 addSubview:imageV3];
    
    
    [imageV1 addSubview:self.labelNum1];
    [imageV2 addSubview:self.labelNum2];
    [imageV3 addSubview:self.labelNum3];
    self.imageV1 = imageV1;
    self.imageV2 = imageV2;
    self.imageV3 = imageV3;
    
    button1.tag = 110;
    button2.tag = 111;
    button3.tag = 112;
    
    [button1 addTarget:self action:@selector(buyMeg:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(buyMeg:) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(buyMeg:) forControlEvents:UIControlEventTouchUpInside];
    [self.labelView addSubview:AllView];
}

-(void)configCellWith:(MineModel *)modle{
        self.icon_bg.image = [UIImage imageNamed:modle.image];
//        float leftWidth = (WIDTH - (100*3*PROPORTION_WIDTH))/2;//65*PROPORTION_WIDTH;
//        float width = 100*PROPORTION_WIDTH;//(WIDTH - (65*4*PROPORTION_WIDTH))/3;
//        UIView *AllView = [[UIView alloc] initWithFrame:CGRectMake(0, 20*PROPORTION_WIDTH, WIDTH, 40*PROPORTION_WIDTH)];
//        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(leftWidth, 0, width, 40*PROPORTION_WIDTH)];
////        [button1 setTitle:@"待付款" forState:UIControlStateNormal];
//        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button1.frame), 0, width, 40*PROPORTION_WIDTH)];
////        [button2 setTitle:@"待发货" forState:UIControlStateNormal];
//        [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button2.frame), 0, width, 40*PROPORTION_WIDTH)];
////        [button3 setTitle:@"待收货" forState:UIControlStateNormal];
//        [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
//        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20*PROPORTION_WIDTH, button1.bounds.size.width, 20*PROPORTION_WIDTH)];
//        label1.text = @"待付款";
//        [button1 addSubview:label1];
//        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20*PROPORTION_WIDTH, button1.bounds.size.width, 20*PROPORTION_WIDTH)];
//        label2.text = @"待发货";
//        [button2 addSubview:label2];
//        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20*PROPORTION_WIDTH, button1.bounds.size.width, 20*PROPORTION_WIDTH)];
//        label3.text = @"待收货";
//        [button3 addSubview:label3];
//        label1.backgroundColor = [UIColor whiteColor];
//        label2.backgroundColor = [UIColor whiteColor];
//        label3.backgroundColor = [UIColor whiteColor];
//        label1.textColor = label2.textColor = label3.textColor = [self colorWithHexString:@"#555555"];
//        label1.font = label2.font = label3.font = [UIFont systemFontOfSize:14];
//        label1.textAlignment = label2.textAlignment = label3.textAlignment = NSTextAlignmentCenter;
//    label1.backgroundColor = label2.backgroundColor = label3.backgroundColor = [self colorWithHexString:@"f7f7f7"];
//    
//        [AllView addSubview:button1];
//        [AllView addSubview:button2];
//        [AllView addSubview:button3];
//    
//    //添加图片
//        UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(37*PROPORTION_WIDTH, -5*PROPORTION_WIDTH, 28*PROPORTION_WIDTH, 28*PROPORTION_WIDTH)];
//        imageV1.image = [UIImage imageNamed:@"payment_icon"];
//        [button1 addSubview:imageV1];
//        UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(37*PROPORTION_WIDTH, -5*PROPORTION_WIDTH, 28*PROPORTION_WIDTH, 28*PROPORTION_WIDTH)];
//        imageV2.image = [UIImage imageNamed:@"Ship_icon"];
//        [button2 addSubview:imageV2];
//        UIImageView *imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(37*PROPORTION_WIDTH, -5*PROPORTION_WIDTH, 28*PROPORTION_WIDTH, 28*PROPORTION_WIDTH)];
//        imageV3.image = [UIImage imageNamed:@"Receiving_icon"];
//        [button3 addSubview:imageV3];
    
        //背景数字
    if ([self.stringWithNumber1 isEqualToString:@"0"]) {
        self.labelNum1.hidden = YES;
    }else{
        self.labelNum1.hidden = NO;
        self.labelNum1.text = self.stringWithNumber1;
    }
    
    if ([self.stringWithNumber2 isEqualToString:@"0"]) {
        self.labelNum2.hidden = YES;
    }else{
        self.labelNum2.hidden = NO;
        self.labelNum2.text = self.stringWithNumber2;
    }
    
    if ([self.stringWithNumber3 isEqualToString:@"0"]) {
        self.labelNum3.hidden = YES;
    }else{
        self.labelNum3.hidden = NO;
        self.labelNum3.text = self.stringWithNumber3;
    }
    
    
    
    
//        button1.tag = 110;
//        button2.tag = 111;
//        button3.tag = 112;
//
//        [button1 addTarget:self action:@selector(buyMeg:) forControlEvents:UIControlEventTouchUpInside];
//        [button2 addTarget:self action:@selector(buyMeg:) forControlEvents:UIControlEventTouchUpInside];
//        [button3 addTarget:self action:@selector(buyMeg:) forControlEvents:UIControlEventTouchUpInside];
    //布局
//    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
//    float a = WIDTH/2-50;
//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 60, 30)];
//    label1.text = @"待付款";
//    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20+a, 5, 60, 30)];
//    label2.text = @"待发货";
//    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(20+2*a, 5, 60, 30)];
//    label3.text = @"待收货";
//    [lable addSubview:label1];
//    [lable addSubview:label2];
//    [lable addSubview:label3];
    //添加下面的分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79*PROPORTION_WIDTH, WIDTH, 1*PROPORTION_WIDTH)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.labelView addSubview:lineView];
    
//    [self.labelView addSubview:AllView];
}


//点击Button触发的事件
-(void)buyMeg:(UIButton *)button{
    if (button.tag == 110) {
        self.dfkBlock(@"待付款");
    }else if (button.tag == 111){
        self.dfhBlock(@"待发货");
    }else{
        self.dshBlock(@"待收货");
    }
}
#pragma mark --- 懒加载 ---
-(UILabel *)labelNum1{
    if (!_labelNum1) {
        _labelNum1 = [[UILabel alloc] initWithFrame:CGRectMake(14, -5, 16, 16)];
        _labelNum1.layer.borderWidth  = 1;
        _labelNum1.layer.borderColor = [[self colorWithHexString:@"#FD681F"] CGColor];
        _labelNum1.layer.cornerRadius = 8;
        _labelNum1.layer.masksToBounds = YES;
        _labelNum1.font = [UIFont systemFontOfSize:10];
        _labelNum1.textAlignment = NSTextAlignmentCenter;
        _labelNum1.backgroundColor = [self colorWithHexString:@"#FD681F"];
        _labelNum1.textColor = [UIColor whiteColor];
    }
    return _labelNum1;
}
-(UILabel *)labelNum2{
    if (!_labelNum2) {
        _labelNum2 = [[UILabel alloc] initWithFrame:CGRectMake(14, -5, 16, 16)];
        _labelNum2.layer.borderWidth  = 1;
        _labelNum2.layer.borderColor = [[self colorWithHexString:@"#FD681F"] CGColor];
        _labelNum2.layer.cornerRadius = 8;
        _labelNum2.layer.masksToBounds = YES;
        _labelNum2.font = [UIFont systemFontOfSize:10];
        _labelNum2.textAlignment = NSTextAlignmentCenter;
        _labelNum2.backgroundColor = [self colorWithHexString:@"#FD681F"];
        _labelNum2.textColor = [UIColor whiteColor];
    }
    return _labelNum2;
}
-(UILabel *)labelNum3{
    if (!_labelNum3) {
        _labelNum3 = [[UILabel alloc] initWithFrame:CGRectMake(14, -5, 16, 16)];
        _labelNum3.layer.borderWidth  = 1;
        _labelNum3.layer.borderColor = [[self colorWithHexString:@"#FD681F"] CGColor];
        _labelNum3.layer.cornerRadius = 8;
        _labelNum3.layer.masksToBounds = YES;
        _labelNum3.font = [UIFont systemFontOfSize:10];
        _labelNum3.textAlignment = NSTextAlignmentCenter;
        _labelNum3.backgroundColor = [self colorWithHexString:@"#FD681F"];
        _labelNum3.textColor = [UIColor whiteColor];
    }
    return _labelNum3;
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
-(void)setFrame:(CGRect)frame{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    [super setFrame:frame];
}


@end

