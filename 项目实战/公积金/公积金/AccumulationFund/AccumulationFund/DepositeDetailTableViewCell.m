//
//  DepositeDetailTableViewCell.m
//  AccumulationFund
//
//  Created by mac on 15/11/20.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "DepositeDetailTableViewCell.h"
#import "FundReferences.h"
#import "UIColor+Hex.h"
#import "UIView+CG.h"

@interface DepositeDetailTableViewCell ()
{
    UIImageView *_backImageView;
}
@end

@implementation DepositeDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"ececec"];

        [self createUI];
    }
    return self;
}

- (void)createUI {
    _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(k_screen_width / 4 - 30, 5, k_screen_width / 2 + 70, k_screen_width / 5 * 2 - 36)];
    _backImageView.image = [UIImage imageNamed:@"cell_background_white"];
    [self.contentView addSubview:_backImageView];
    [self.contentView addSubview:self.dotImage];
    
    //加线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_dotImage.frame) + 5, - k_screen_width / 2, 2, k_screen_width / 3 * 4 )];
    line.backgroundColor = BarColor;
    [self.contentView addSubview:line];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(35, 10, _backImageView.width / 2 - 25, 20)];
    label1.textColor = BarColor;
    label1.font = YBFont(13);
    label1.text = @"日期";
    
    [_backImageView addSubview:label1];
    [_backImageView addSubview:self.dateLabel];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(label1.frame), CGRectGetMaxY(label1.frame) + 5, label1.width, label1.height)];
    label2.textColor = BarColor;
    label2.font = YBFont(13);
    label2.text = @"摘要";
    
    [_backImageView addSubview:label2];
    [_backImageView addSubview:self.typeLabel];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(label2.frame), CGRectGetMaxY(label2.frame) + 5, label1.width, label1.height)];
    label3.textColor = BarColor;
    label3.font = YBFont(13);
    label3.text = @"金额";
    
    [_backImageView addSubview:label3];
    [_backImageView addSubview:self.moneyLabel];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(label3.frame), CGRectGetMaxY(label3.frame) + 5, label1.width, label1.height)];
    label4.textColor = BarColor;
    label4.font = YBFont(13);
    label4.text = @"余额";
    
    [_backImageView addSubview:label4];
    [_backImageView addSubview:self.balanceLabel];
}

- (UIImageView *)dotImage {
    if (_dotImage == nil) {
        CGFloat height = 14.5;
        if ([UIScreen mainScreen].bounds.size.width > 375) {
            height = 20.5;
        }
        if ([UIScreen mainScreen].bounds.size.width < 375) {
            height = 13.5;
        }
        _dotImage = [[UIImageView alloc]initWithFrame:CGRectMake(k_screen_width / 8, CGRectGetMinY(_backImageView.frame) + height , 12, 12)];
        _dotImage.layer.cornerRadius = 6;
        _dotImage.backgroundColor = BarColor;
        
    }
    return _dotImage;
}

- (UILabel *)dateLabel {
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(_backImageView.width / 2 + 10, 10, _backImageView.width / 2, 20)];
        _dateLabel.textColor = [UIColor lightGrayColor];
        _dateLabel.font = YFont(13);
        _dateLabel.text = @"2015/9/15";
        
    }
    return _dateLabel;
}

- (UILabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_dateLabel.frame), CGRectGetMaxY(_dateLabel.frame) + 5, _dateLabel.width, _dateLabel.height)];
        _typeLabel.textColor = [UIColor lightGrayColor];
        _typeLabel.font = YFont(13);
        _typeLabel.text = @"汇缴";
    }
    return _typeLabel;
}

- (UILabel *)moneyLabel {
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_typeLabel.frame), CGRectGetMaxY(_typeLabel.frame) + 5, _typeLabel.width, _typeLabel.height)];
        _moneyLabel.textColor = [UIColor lightGrayColor];
        _moneyLabel.font = YFont(13);
        _moneyLabel.text = @"1200.00";
    }
    return _moneyLabel;
}

- (UILabel *)balanceLabel {
    if (_balanceLabel == nil) {
        _balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_moneyLabel.frame), CGRectGetMaxY(_moneyLabel.frame) + 5, _moneyLabel.width, _moneyLabel.height)];
        _balanceLabel.textColor = [UIColor lightGrayColor];
        _balanceLabel.font = YFont(13);
        _balanceLabel.text = @"14400.44";
    }
    return _balanceLabel;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.dateLabel.text = [_dict[@"rq"] isKindOfClass:[NSNull class]] ? @"无" : [_dict[@"rq"] substringToIndex:10];
    self.typeLabel.text = [_dict[@"zy"] isKindOfClass:[NSNull class]] ? @"无" : _dict[@"zy"];
    self.moneyLabel.text = [_dict[@"je"] isKindOfClass:[NSNull class]] ?  @"无" : _dict[@"je"];
    self.balanceLabel.text = [_dict[@"ye"] isKindOfClass:[NSNull class]] ? @"无" : _dict[@"ye"];
    
    
    
}

@end
