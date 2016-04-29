//
//  OrderDetailTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成27-11-22.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderDetailModel;

@interface OrderDetailTableViewCell : UITableViewCell
@property(nonatomic,strong) UIImageView *detailImageView;
@property(nonatomic,strong) UILabel *detailLabel;
@property(nonatomic,strong) UILabel *detailDetailLabel;
@property(nonatomic,strong) UILabel *detailTotalCountLabel;
@property(nonatomic,strong) UILabel *detailMoneyCountLabel;

@property(nonatomic,strong) UIView *doV;//下划线根据有无申请售后来决定

@property(nonatomic,strong) UIButton *serviceBtn;

-(void)configCellWithModel:(OrderDetailModel *)orderDetailModel;

-(void)configCellWithModel:(OrderDetailModel *)orderDetailModel WithStatue:(NSString *)string;
@property(nonatomic,strong) void(^getDataBlock)(UIButton *button);

@end
