//
//  AboutMeTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成27-11-16.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineModel.h"

@interface AboutMeTableViewCell : UITableViewCell

@property(nonatomic,assign)float widht;

@property(nonatomic,strong) UIImageView *icon_bg;
@property(nonatomic,strong) UIView *labelView;
@property(nonatomic,strong) NSString *stringWithNumber1;//待付款的数量
@property(nonatomic,strong) NSString *stringWithNumber2;//待发货的数量
@property(nonatomic,strong) NSString *stringWithNumber3;//待收货的数量
@property(nonatomic,strong) UILabel *labelNum1;
@property(nonatomic,strong) UILabel *labelNum2;
@property(nonatomic,strong) UILabel *labelNum3;
@property(nonatomic,strong) UIImageView *imageV1;
@property(nonatomic,strong) UIImageView *imageV2;
@property(nonatomic,strong) UIImageView *imageV3;


@property(nonatomic,strong) void(^dfkBlock)(NSString *);
@property(nonatomic,strong) void(^dfhBlock)(NSString *);
@property(nonatomic,strong) void(^dshBlock)(NSString *);

-(void)configCellWith:(MineModel *)modle;

@end
