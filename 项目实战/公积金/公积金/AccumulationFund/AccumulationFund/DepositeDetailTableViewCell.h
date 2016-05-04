//
//  DepositeDetailTableViewCell.h
//  AccumulationFund
//
//  Created by mac on 15/11/20.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DepositeDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *dict;
@property (nonatomic,strong)UIImageView *dotImage;  //小图片
@property (nonatomic,strong)UILabel *dateLabel;     //日期
@property (nonatomic,strong)UILabel *typeLabel;     //摘要
@property (nonatomic,strong)UILabel *moneyLabel;    //金额
@property (nonatomic,strong)UILabel *balanceLabel;  //余额


@end
