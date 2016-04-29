//
//  BuyAllTableViewCell.m
//  QXD
//
//  Created by zhujie on 平成27-12-25.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "BuyAllTableViewCell.h"
#import "ProductModel.h"

@implementation BuyAllTableViewCell

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
    self.iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImg.frame) +10,10, WIDTH - 200, 20)];
    self.countAndMoneyView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH - 110, 20, 100, 50)];
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 50, 20)];
    self.serviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 80, 25)];
    
    [self.countAndMoneyView addSubview:self.countLabel];
    [self.countAndMoneyView addSubview:self.moneyLabel];
    [self.countAndMoneyView addSubview:self.serviceBtn];
    
//    self.iconImg.backgroundColor = [UIColor cyanColor];
//    self.nameLabel.backgroundColor = [UIColor yellowColor];
//    self.contentView.backgroundColor = [UIColor orangeColor];
//    self.countLabel.backgroundColor = [UIColor blueColor];
//    self.moneyLabel.backgroundColor = [UIColor yellowColor];
//    self.serviceBtn.backgroundColor = [UIColor redColor];
    self.moneyLabel.textAlignment = NSTextAlignmentRight;
    self.countLabel.font = [UIFont systemFontOfSize:13];
    self.moneyLabel.font = [UIFont systemFontOfSize:13];
    self.serviceBtn.layer.borderWidth = 1;
    self.serviceBtn.layer.cornerRadius = 5;
    self.serviceBtn.layer.masksToBounds = YES;
    [self.serviceBtn setTitle:@"审核售后" forState:UIControlStateNormal];
    [self.serviceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    [self.contentView addSubview:self.iconImg];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.countAndMoneyView];
}

-(void)configCellWithProduct:(ProductModel *)model WithStatue:(NSString *)statue{
    if (![statue isEqualToString:@"ypj"]) {
        self.serviceBtn.hidden = YES;
    }
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.product_img]];
    self.nameLabel.text = model.product_name;
    self.countLabel.text = [NSString stringWithFormat:@"X%@",model.product_num];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",model.product_price];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
