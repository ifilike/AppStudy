//
//  VipTableViewCell.m
//  QXD
//
//  Created by zhujie on 平成27-12-04.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "VipTableViewCell.h"
#import "VipModle.h"

@implementation VipTableViewCell

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
    
    self.iconImag = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImag.frame)+10, 20, 150, 30)];

    self.vipImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+10, 20, 30, 30)];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 80, 20, 40, 30)];
    
    //颜色
//    self.iconImag.backgroundColor = [UIColor redColor];
//    self.nameLabel.backgroundColor = [UIColor cyanColor];
//    self.vipImg.backgroundColor = [UIColor yellowColor];
//    self.detailLabel.backgroundColor = [UIColor orangeColor];
    
    [self addSubview:self.iconImag];
    [self addSubview:self.nameLabel];
    [self addSubview:self.vipImg];
    [self addSubview:self.detailLabel];
}
-(void)configCellWithModle:(VipModle *)model{
    [self.iconImag sd_setImageWithURL:[NSURL URLWithString:model.iconImg]];
    self.nameLabel.text = model.nameLabel;
//    [self.vipImg sd_setImageWithURL:[NSURL URLWithString:model.vipImg]];
    if ([model.detailLabel isEqualToString:@"1"]) {
        self.detailLabel.text = @"主卡";
    }else{self.detailLabel.text = @"副卡";}
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
