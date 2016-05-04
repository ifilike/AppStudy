//
//  RefundQueryTableViewCell.h
//  AccumulationFund
//
//  Created by mac on 15/11/19.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefundQueryTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *dict;
@property (nonatomic,strong)UIImageView *dotImage;  //小圆点

@property (nonatomic,strong)UILabel *stageLabel;    //多少期
@property (nonatomic,strong)UILabel *refundTypeLabel;  //还款类型
@property (nonatomic,strong)UILabel *refundMoney;   //还款金额
@property (nonatomic,strong)UILabel *loanUserDraw;  //借款人支取
@property (nonatomic,strong)UILabel *loanOtherDraw; //配偶支取
@property (nonatomic,strong)UILabel *repayCard; //还款卡(卡号)
@property (nonatomic,strong)UILabel *moneyOnce; //每次还款
@property (nonatomic,strong)UILabel *repayTime;  //还款日期

@end
