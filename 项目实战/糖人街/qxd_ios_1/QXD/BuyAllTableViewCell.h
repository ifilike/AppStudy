//
//  BuyAllTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成27-12-25.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductModel;

@interface BuyAllTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *iconImg;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIView *countAndMoneyView;
@property(nonatomic,strong) UILabel *countLabel;
@property(nonatomic,strong) UILabel *moneyLabel;
@property(nonatomic,strong) UIButton *serviceBtn;

-(void)configCellWithProduct:(ProductModel *)model WithStatue:(NSString *)statue;

@end
