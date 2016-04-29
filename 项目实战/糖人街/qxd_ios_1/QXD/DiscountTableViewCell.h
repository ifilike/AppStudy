//
//  DiscountTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成27-12-17.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiscountModle;

@interface DiscountTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UILabel *moneyLabel;
@property(nonatomic,strong) UILabel *useLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *limitTimeLabel;

-(void)configCellWithModle:(DiscountModle *)model;
@end
