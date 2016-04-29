//
//  PayTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成27-12-08.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTableViewCell : UITableViewCell
@property(nonatomic,strong) UIImageView *iconImg;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIButton *selectButton;

@property(nonatomic,strong) void(^SelectPay)(UIButton *);
-(void)configCellWithString:(NSString *)string WithPayType:(NSString *)payType;
@end
