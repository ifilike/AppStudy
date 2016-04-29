//
//  MemberPriceTableViewCell.m
//  QXD
//
//  Created by wzp on 15/12/1.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "MemberPriceTableViewCell.h"
#import "MemberModel.h"

@implementation MemberPriceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setModel:(MemberModel*)model{
    self.priceLab.text=[model.vip_present_price stringByAppendingString:@"元"];
    self.typeLabel.text=model.vip_descript;
    //是否特惠
    if ([model.is_special_offer isEqualToString:@"0"]) {
        _discountLab.hidden=YES;
    }
    //是哪种会员
    if ([model.vip_descript isEqualToString:@"一年"]) {
        _openBut.tag=12;
    }else if ([model.vip_descript isEqualToString:@"半年"]){
        _openBut.tag=11;
    }else if([model.vip_descript isEqualToString:@"一个月"]){
        _openBut.tag=10;
    }
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
