//
//  CouponTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成27-12-07.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiscountModle;

@interface CouponTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIButton *SelectBtn;

@property(nonatomic,strong) NSString *money;
@property(nonatomic,strong) NSString *youfei;
@property(nonatomic,strong) NSString *youhuijuanID;

@property(nonatomic,strong) void(^SelectBtnWithCoupon)(UIButton *);
@property(nonatomic,strong) void(^moneyBlock)(NSString *);
@property(nonatomic,strong) void(^youfeiBlock)(NSString *);
@property(nonatomic,strong) void(^youhuijuanBlock)(NSString *);
-(void)configWithDisModle:(DiscountModle *)modle;
-(void)configWithDis:(DiscountModle *)modle;
@property(nonatomic,strong) void(^SelectWithSelect)(UIButton *);

//新增功能点击缩回去
@property(nonatomic,strong) void(^dismisss)(NSString *title);
@end
