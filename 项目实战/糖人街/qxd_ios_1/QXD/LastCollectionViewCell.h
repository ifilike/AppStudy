//
//  LastCollectionViewCell.h
//  QXD
//
//  Created by zhujie on 平成27-11-23.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LastCollectionModel.h"

@interface LastCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,strong) UIImageView *imageView;

@property(nonatomic,strong) UIView *detailView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *detailLabel;
@property(nonatomic,strong) UIView *priceView;
@property(nonatomic,strong) UILabel *todayPriceLabel;
@property(nonatomic,strong) UILabel *yestodayPriceLabel;

-(void)configCollectionCellWithModel:(LastCollectionModel *)lastCollectionModel;

@end
