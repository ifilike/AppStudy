//
//  CalucateTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成27-12-07.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendsModel;

@interface CalucateTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *iconImg;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *detailLabel;
@property(nonatomic,strong) UILabel *priceLabel;
@property(nonatomic,strong) UILabel *priceNumbelLabel;


-(void)configCellWithShopCarModel:(FriendsModel *)modle;
@end
