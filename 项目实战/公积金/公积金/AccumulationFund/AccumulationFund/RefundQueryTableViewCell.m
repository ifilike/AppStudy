//
//  RefundQueryTableViewCell.m
//  AccumulationFund
//
//  Created by mac on 15/11/19.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "RefundQueryTableViewCell.h"
#import "FundReferences.h"
#import "UIColor+Hex.h"
#import "UIView+CG.h"

@interface RefundQueryTableViewCell ()

@property (nonatomic,strong)UIImageView *backImageView;

@end

@implementation RefundQueryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = [UIColor colorWithHexString:@"ececec"];
    
    _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 10, k_screen_width - 40, 140)];
    _backImageView.image = [UIImage imageNamed:@"cell_background_white"];
    [self.contentView addSubview:_backImageView];
    
    [self addAll];
}

- (void)addAll
{
    //最左边的线条
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(22, 0, 2, 150)];
    lineView.backgroundColor = BarColor;
    [self.contentView addSubview:lineView];
    
    [self.contentView addSubview:self.dotImage];
    [_backImageView addSubview:self.stageLabel];
    [_backImageView addSubview:self.refundTypeLabel];
    
    //还款金额
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_stageLabel.frame), CGRectGetMaxY(_stageLabel.frame) + 5, _stageLabel.width, 20)];
    label1.textColor = [UIColor grayColor];
    label1.text = @"还款金额";
    label1.font = YFont(14);
    [_backImageView addSubview:label1];
    
    [_backImageView addSubview:self.refundMoney];
    
    //借款人支取
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(label1.frame), CGRectGetMaxY(label1.frame)  , label1.width, label1.height)];
    label2.text = @"借款人支取";
    label2.textColor = [UIColor grayColor];
    label2.font = YFont(14);
    [_backImageView addSubview:label2];
    
    [_backImageView addSubview:self.loanUserDraw];
    
    //配偶支取
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(label2.frame), CGRectGetMaxY(label2.frame)  , label2.width, label2.height)];
    label3.text = @"配偶支取";
    label3.textColor = [UIColor grayColor];
    label3.font = YFont(14);
    [_backImageView addSubview:label3];
    
    [_backImageView addSubview:self.loanOtherDraw];
    
    //还款卡
    
    [_backImageView addSubview:self.repayCard];
    
    //每次还多少钱
    
    [_backImageView addSubview:self.moneyOnce];
    
    //还款日期
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_repayCard.frame), CGRectGetMaxY(_repayCard.frame)  , _repayCard.width, _repayCard.height)];
    label4.text = @"还款日期";
    label4.textColor = [UIColor grayColor];
    label4.font = YFont(14);
    [_backImageView addSubview:label4];
    
    [_backImageView addSubview:self.repayTime];

}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.stageLabel.text = [NSString stringWithFormat:@"%@期   ", dict[@"hkqc"]];
    self.refundTypeLabel.text = [NSString stringWithFormat:@"   %@", dict[@"hkzt"]];
    self.refundMoney.text = [dict[@"hkje"] isKindOfClass:[NSNull class]] ? @"无" : dict[@"hkje"];
    self.loanUserDraw.text = [dict[@"jkrzq"] isKindOfClass:[NSNull class]] ? @"无" : dict[@"jkrzq"];
    self.loanOtherDraw.text = [dict[@"pozq"] isKindOfClass:[NSNull class]] ? @"无" : dict[@"pozq"];
    
    NSString *hkkh = [dict[@"hkkh"] isKindOfClass:[NSNull class]] ? @"无" : dict[@"hkkh"];
    if (hkkh.length > 4) {
        hkkh = [hkkh substringFromIndex:hkkh.length - 4];
    }
    self.repayCard.text = [NSString stringWithFormat:@"还款卡(*%@)", hkkh];
    self.moneyOnce.text = [dict[@"hkkke"] isKindOfClass:[NSNull class]] ? @"无" : dict[@"hkkke"];
    self.repayTime.text = [dict[@"hkrq"] isKindOfClass:[NSNull class]] ? @"无" : ([dict[@"hkrq"] length] > 10 ? [dict[@"hkrq"] substringToIndex:10] : dict[@"hkrq"]);
}

- (UIImageView *)dotImage
{
    if (_dotImage == nil) {
        CGFloat height = 14.5;
        if ([UIScreen mainScreen].bounds.size.width > 375) {
            height = 20.5;
        }
        if ([UIScreen mainScreen].bounds.size.width < 375) {
            height = 13.5;
        }
        _dotImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_backImageView.frame) - 13, CGRectGetMinY(_backImageView.frame) + height, 12, 12)];
        _dotImage.layer.cornerRadius = 6;
        _dotImage.image = [UIImage imageNamed:@""];
        _dotImage.backgroundColor = BarColor;
    }
    return _dotImage;
}

- (UILabel *)stageLabel
{
    if (_stageLabel == nil) {
        _stageLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_backImageView.frame) + 20, CGRectGetMinY(_backImageView.frame) , _backImageView.width  / 3 + 15, 20)];
        _stageLabel.font = YFont(16);
        _stageLabel.textColor = [UIColor darkGrayColor];
        _stageLabel.textAlignment = NSTextAlignmentRight;
    }
    return _stageLabel;
}

- (UILabel *)refundTypeLabel
{
    if (_refundTypeLabel == nil) {
        _refundTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_stageLabel.frame) + 10, CGRectGetMinY(_stageLabel.frame), _stageLabel.width, _stageLabel.height)];
        _refundTypeLabel.font = YFont(16);
        _refundTypeLabel.textColor = [UIColor darkGrayColor];        
    }
    return _refundTypeLabel;
}

- (UILabel *)refundMoney
{
    if (_refundMoney == nil) {
        _refundMoney = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_stageLabel.frame), CGRectGetMaxY(_stageLabel.frame) + 5, _stageLabel.width, 20)];
        _refundMoney.font = YFont(14);
        _refundMoney.textColor = [UIColor grayColor];
        _refundMoney.textAlignment = NSTextAlignmentRight;
    }
    return _refundMoney;
}

- (UILabel *)loanUserDraw
{
    if (_loanUserDraw == nil) {
        _loanUserDraw = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_refundMoney.frame), CGRectGetMaxY(_refundMoney.frame), _refundMoney.width, _refundMoney.height)];
        _loanUserDraw.font = YFont(14);
        _loanUserDraw.textColor = [UIColor grayColor];
        _loanUserDraw.textAlignment = NSTextAlignmentRight;
    }
    return _loanUserDraw;
}

- (UILabel *)loanOtherDraw
{
    if (_loanOtherDraw == nil) {
        _loanOtherDraw = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_loanUserDraw.frame), CGRectGetMaxY(_loanUserDraw.frame), _loanUserDraw.width, _loanUserDraw.height)];
        _loanOtherDraw.font = YFont(14);
        _loanOtherDraw.textColor = [UIColor grayColor];
        _loanOtherDraw.textAlignment = NSTextAlignmentRight;
    }
    return _loanOtherDraw;
}

- (UILabel *)repayCard
{
    if (_repayCard == nil) {
        _repayCard = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_stageLabel.frame), CGRectGetMaxY(_loanOtherDraw.frame), _loanOtherDraw.width, _loanOtherDraw.height)];
        _repayCard.font = YFont(14);
        _repayCard.textColor = [UIColor grayColor];
    }
    return _repayCard;
}

- (UILabel *)moneyOnce
{
    if (_moneyOnce == nil) {
        _moneyOnce = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_loanOtherDraw.frame), CGRectGetMaxY(_loanOtherDraw.frame), _loanOtherDraw.width, _loanOtherDraw.height)];
        _moneyOnce.font = YFont(14);
        _moneyOnce.textColor = [UIColor grayColor];
        _moneyOnce.textAlignment = NSTextAlignmentRight;
    }
    return _moneyOnce;
}

- (UILabel *)repayTime
{
    if (_repayTime == nil) {
        _repayTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_moneyOnce.frame), CGRectGetMaxY(_moneyOnce.frame), _moneyOnce.width, _moneyOnce.height)];
        _repayTime.font = YFont(14);
        _repayTime.textColor = [UIColor grayColor];
        _repayTime.textAlignment = NSTextAlignmentRight;
    }
    return _repayTime;
}


@end
