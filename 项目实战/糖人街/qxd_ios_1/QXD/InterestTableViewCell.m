//
//  InterestTableViewCell.m
//  QXD
//
//  Created by WZP on 15/11/22.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "InterestTableViewCell.h"
#import "SubGoodsView.h"
#import "InterestSubView.h"
#import "InterestProductModel.h"


@implementation InterestTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setModel1:(InterestProductModel*)model1 model2:(InterestProductModel*)model2{

    self.subButttonArr=[NSMutableArray arrayWithCapacity:1];
    InterestSubView * subGoodsView=[[InterestSubView alloc] initWithFrame:CGRectMake(20*PROPORTION_WIDTH, 0, 158*PROPORTION_WIDTH, 236*PROPORTION_WIDTH)];
    subGoodsView.tag=1;
    [subGoodsView setModel:model1];
    [self addSubview:subGoodsView];
    [_subButttonArr addObject:subGoodsView];
    if (model2!=nil) {
        InterestSubView * subGoodsView2=[[InterestSubView alloc] initWithFrame:CGRectMake(197*PROPORTION_WIDTH, 0, 158*PROPORTION_WIDTH, 236*PROPORTION_WIDTH)];
        subGoodsView2.tag=2;
        [subGoodsView2 setModel:model2];
        [self addSubview:subGoodsView2];
        [_subButttonArr addObject:subGoodsView2];
    }
 
}
//- (void)setLittleTypeModel1:(ProductListModel*)model1 model2:(ProductListModel*)model2{
//    
//    SubGoodsView * subGoodsView=[[SubGoodsView alloc] initWithFrame:CGRectMake(5, 5, WIDTH/2-10, self.bounds.size.height-5)];
//    [subGoodsView setModel:model1];
//    [self addSubview:subGoodsView];
//    
//    
//    SubGoodsView * subGoodsView2=[[SubGoodsView alloc] initWithFrame:CGRectMake(WIDTH/2+5, 5, WIDTH/2-10, self.bounds.size.height-5)];
//    [subGoodsView2 setModel:model2];
//    [self addSubview:subGoodsView2];
//    
//}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
