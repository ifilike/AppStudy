//
//  BuyNowTableViewCell.m
//  QXD
//
//  Created by wzp on 16/1/19.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "BuyNowTableViewCell.h"
#import "BuyNowProductView.h"
#import "ZTProductListModel.h"

@implementation BuyNowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         _buyNowView=[[BuyNowProductView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 15*PROPORTION_WIDTH, 345*PROPORTION_WIDTH, 120*PROPORTION_WIDTH)];
        _buyNowView.buyBut.tag=55;
//        _buyNowView.backgroundColor=[UIColor redColor];
        [self addSubview:_buyNowView];
        
    }

    return self;
}





- (void)setZTProductListModel:(ZTProductListModel*)model tag:(NSInteger)tag{

    [_buyNowView setZTProductListModel:model tag:tag];

}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
