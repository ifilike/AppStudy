//
//  LTableViewCell.m
//  tableview
//
//  Created by mac on 14-9-8.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "LTableViewCell.h"
#import "FriendsModel.h"

@implementation LTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        _count = 1;
        [self creat];
//        [self creatTotalMoney];
    }
    return self;
}

- (void)creat{
    if (m_checkImageView == nil)
    {
        m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_normal_icon"]];
        m_checkImageView.frame = CGRectMake(15*PROPORTION_WIDTH, 65*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, 20*PROPORTION_WIDTH);
        [self addSubview:m_checkImageView];
    }
    
    
    //添加view
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0*PROPORTION_WIDTH, 0, WIDTH - 65*PROPORTION_WIDTH, 190*PROPORTION_WIDTH)];
    
    //图片
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(50*PROPORTION_WIDTH, 25*PROPORTION_WIDTH, 100*PROPORTION_WIDTH, 100*PROPORTION_WIDTH)];
    //名称
    self.detialLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImage.frame)+10*PROPORTION_WIDTH, 35*PROPORTION_WIDTH, self.titleView.frame.size.width - (CGRectGetMaxX(self.iconImage.frame)-45*PROPORTION_WIDTH), 45*PROPORTION_WIDTH)];
    self.detialLabel.numberOfLines = 2;
    
    //规格
    self.standardLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImage.frame)+10*PROPORTION_WIDTH, CGRectGetMaxY(self.detialLabel.frame)+5*PROPORTION_WIDTH, self.titleView.frame.size.width - (CGRectGetMaxX(self.iconImage.frame)+10*PROPORTION_WIDTH), 10*PROPORTION_WIDTH)];
    //价格
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImage.frame)+10*PROPORTION_WIDTH, CGRectGetMaxY(self.standardLabel.frame)+3*PROPORTION_WIDTH, 100*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
    
    //数量
    
    self.addProductView = [[UIView alloc] initWithFrame:CGRectMake(self.titleView.frame.size.width - 110, 35, 100, 30)];
    
    self.productCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImage.frame)+10*PROPORTION_WIDTH +100*PROPORTION_WIDTH, CGRectGetMaxY(self.standardLabel.frame)+3*PROPORTION_WIDTH, 100*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
    self.productCount.textAlignment = NSTextAlignmentRight;
    //    [self.addProductView addSubview:self.productCount];
    //编辑
    self.editingView = [[UIView alloc] init];
    self.editingView = [self addProductViewWithView];
    //self.editingView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"组-9"]];
    self.editingView.hidden = YES;
    //    [self.addProductView addSubview:self.editingView];
    
    
    self.iconImage.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    //    self.detialLabel.backgroundColor = [UIColor cyanColor];
    //    self.standardLabel.backgroundColor = [UIColor orangeColor];
    //    self.priceLabel.backgroundColor = [UIColor purpleColor];
    //    self.addProductView.backgroundColor = [UIColor redColor];
    //    self.productCount.backgroundColor = [UIColor yellowColor];
    
    //    [self.titleView addSubview:self.addProductView];
    [self.titleView addSubview:self.iconImage];
    [self.titleView addSubview:self.detialLabel];
    [self.titleView addSubview:self.standardLabel];
    [self.titleView addSubview:self.priceLabel];
    [self.titleView addSubview:self.productCount];
    [self.titleView addSubview:self.editingView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.width - 1, self.titleView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    //    [self.titleView addSubview:lineView];
    
    [self.contentView addSubview:self.titleView];
    //布局
    self.detialLabel.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    self.detialLabel.textColor = [self colorWithHexString:@"#555555"];
    
    self.standardLabel.font = [UIFont systemFontOfSize:10*PROPORTION_WIDTH];
    self.standardLabel.textColor = [self colorWithHexString:@"#999999"];
    
    self.priceLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    self.priceLabel.textColor = [self colorWithHexString:@"#FD681F"];
    
    self.productCount.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    self.productCount.textColor = [self colorWithHexString:@"#FD681F"];
    self.price = [[UILabel alloc] init];//初始化
}
- (void)configCellWithFriendsModel:(FriendsModel *)model{
    
    self.price.text = model.product_price;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.product_img]];
    self.detialLabel.text = [NSString stringWithFormat:@"%@",model.product_name];
    self.standardLabel.text = [NSString stringWithFormat:@" %@",model.product_standard];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.product_price];
    self.productCount.text = [NSString stringWithFormat:@"X %@",model.product_num];
    _count = [model.product_num intValue];
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)_count];
   
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.detialLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5*PROPORTION_WIDTH];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, 1)];
    self.detialLabel.attributedText = attributedString;
    [self.detialLabel sizeToFit];
//    self.detialLabel.text = [NSString stringWithFormat:@"%@",model.product_name];
//    [self creatCount];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addView) name:@"333" object:nil];
}



-(void)creatCount{

    UIView *addV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [addV addSubview:self.productCount];
    addV.backgroundColor = [UIColor whiteColor];
    [self.addProductView addSubview: addV];

}

#pragma mark --- 添加➕➖按钮 ---
-(UIView *)addProductViewWithView{
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(0, 120*PROPORTION_WIDTH, 200*PROPORTION_WIDTH, 70*PROPORTION_WIDTH)];
    addView.userInteractionEnabled = YES;
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(50*PROPORTION_WIDTH, 23*PROPORTION_WIDTH, 94*PROPORTION_WIDTH, 28*PROPORTION_WIDTH)];
    UIImageView *leftLabel = [[UIImageView alloc] initWithFrame:CGRectMake(9*PROPORTION_WIDTH, 13*PROPORTION_WIDTH, 10*PROPORTION_WIDTH, 2*PROPORTION_WIDTH)];
    UIImageView *rightLabel = [[UIImageView alloc] initWithFrame:CGRectMake(76*PROPORTION_WIDTH, 9*PROPORTION_WIDTH, 10*PROPORTION_WIDTH, 10*PROPORTION_WIDTH)];
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(28*PROPORTION_WIDTH, 0, 38*PROPORTION_WIDTH, 28*PROPORTION_WIDTH)];
    //布局
    [totalLabel addSubview:self.countLabel];
    [totalLabel addSubview:leftLabel];
    [totalLabel addSubview:rightLabel];
    [leftLabel setImage:[UIImage imageNamed:@"减号_不可点击"]];
    [rightLabel setImage:[UIImage imageNamed:@"矩形-1-拷贝-2"]];
    totalLabel.layer.borderWidth = 1;
    totalLabel.layer.cornerRadius = 5;
    totalLabel.layer.masksToBounds = YES;
    totalLabel.layer.borderColor = [[self colorWithHexString:@"#CCCCCC"] CGColor];
    //画线
    UIView *lineVl = [[UIView alloc] initWithFrame:CGRectMake(27*PROPORTION_WIDTH, 1*PROPORTION_WIDTH, 1*PROPORTION_WIDTH, 26*PROPORTION_WIDTH)];
    UIView *lineVr = [[UIView alloc] initWithFrame:CGRectMake(66*PROPORTION_WIDTH, 1*PROPORTION_WIDTH, 1*PROPORTION_WIDTH, 26*PROPORTION_WIDTH)];
    lineVl.backgroundColor = [self colorWithHexString:@"#CCCCCC"];
    lineVr.backgroundColor = [self colorWithHexString:@"#CCCCCC"];
    [totalLabel addSubview:lineVr];
    [totalLabel addSubview:lineVl];
    self.countLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    self.countLabel.textColor = [self colorWithHexString:@"#333333"];
    
    
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100*PROPORTION_WIDTH, 80*PROPORTION_WIDTH)];
    UIButton *disBtn = [[UIButton alloc] initWithFrame:CGRectMake(100*PROPORTION_WIDTH, 0, 100*PROPORTION_WIDTH, 80*PROPORTION_WIDTH)];
   

    self.countLabel.textAlignment = NSTextAlignmentCenter;
    
    [addView addSubview:addBtn];
    [addView addSubview:disBtn];
    
    [addView addSubview:totalLabel];
    [addBtn addTarget:self action:@selector(discount) forControlEvents:UIControlEventTouchUpInside];
    [disBtn addTarget:self action:@selector(addcount) forControlEvents:UIControlEventTouchUpInside];
    return addView;
}
#pragma mark --- ➕ ---
-(void)addcount{
    _count ++;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:UpdataCartNum parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *str = [NSString stringWithFormat:@"%ld",(long)_count];
        [formData appendPartWithFormData:[str dataUsingEncoding:NSUTF8StringEncoding] name:@"product_num"];
        [formData appendPartWithFormData:[self.product_num_string dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
        self.BlockReload();
        }else{
            NSLog(@"数据格式不对");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error:%@",error);
    }];
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)_count];
    
    self.productCount.text = [NSString stringWithFormat:@"X%@",self.countLabel.text];
    
//    [self creatTotalMoney];
//    self.BlockReload();
}
#pragma mark --- ➖ ---
-(void)discount{
    if (_count == 1) {
        return;
    }
    _count --;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:UpdataCartNum parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *str = [NSString stringWithFormat:@"%ld",(long)_count];
        [formData appendPartWithFormData:[str dataUsingEncoding:NSUTF8StringEncoding] name:@"product_num"];
        [formData appendPartWithFormData:[self.product_num_string dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
        self.BlockReload();
        }else{
            NSLog(@"数据格式不对");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)_count];
    
    self.productCount.text = [NSString stringWithFormat:@"X%@",self.countLabel.text];
    
    
//    [self creatTotalMoney];
//    self.BlockReload();
}
-(void)creatTotalMoney{
    float product = [self.price.text floatValue];
    float totalMoney = _count * product;
    self.moneyTotal(totalMoney);
}


- (void)setChecked:(BOOL)checked{
    if (checked)
    {
        m_checkImageView.image = [UIImage imageNamed:@"select_selected_icon"];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    else
    {
        m_checkImageView.image = [UIImage imageNamed:@"select_normal_icon"];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    m_checked = checked;
    
    
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
- (void)awakeFromNib
{
    // Initialization code
}


//-(void)addView{
//    [self.addProductView addSubview:[self addProductViewWithView]];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
