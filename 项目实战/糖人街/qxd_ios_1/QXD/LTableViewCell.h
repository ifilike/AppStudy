//
//  LTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成27-11-22.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendsModel;

@interface LTableViewCell : UITableViewCell{
    BOOL			m_checked;
    UIImageView*	m_checkImageView;
    NSInteger _count;
}
@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,strong) UILabel *priceLabel;
@property(nonatomic,strong) UILabel *price;//算钱数 防止因为钱的符号 造成问题
@property(nonatomic,strong) UIImageView *iconImage;
@property(nonatomic,strong) UILabel *detialLabel;
@property(nonatomic,strong) UIView *addProductView;
@property(nonatomic,strong) UILabel *productCount;
@property(nonatomic,strong) UILabel *countLabel;
@property(nonatomic,strong) UIView *editingView;
@property(nonatomic,strong) UILabel *standardLabel;


@property(nonatomic,strong) NSString *product_num_string;
@property(nonatomic,strong) void(^moneyTotal)(float totalMoney);
@property(nonatomic,strong) void(^BlockReload)();
-(void)creatTotalMoney;


- (void)setChecked:(BOOL)checked;
- (void)configCellWithFriendsModel:(FriendsModel *)model;
@end
