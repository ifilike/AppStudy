//
//  LoanScheduleTableViewCell.m
//  AccumulationFund
//
//  Created by mac on 15/11/20.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "LoanScheduleTableViewCell.h"
#import "FundReferences.h"
#import "UIColor+Hex.h"
#import "UIView+CG.h"

@interface LoanScheduleTableViewCell ()
{
    UIImageView *_backImageView;
}
@end

@implementation LoanScheduleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    //背景图
    _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 10, k_screen_width - 55, 45)];
    _backImageView.image = [UIImage imageNamed:@"cell_background_gray"];
    [self.contentView addSubview:_backImageView];
    
    //加线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(22, 0, 2, k_screen_width / 6)];
    line.backgroundColor = BarColor;
    [self.contentView addSubview:line];
    
    [self.contentView addSubview:self.dotImage];
    
    [_backImageView addSubview:self.contentL];
    
}

- (UIImageView *)dotImage
{
    if (_dotImage == nil) {
        _dotImage = [[UIImageView alloc]initWithFrame:CGRectMake(18, CGRectGetMinY(_backImageView.frame) + _backImageView.height / 5, 10, 10)];
        _dotImage.backgroundColor = BarColor;
        _dotImage.layer.cornerRadius = 5;
        
    }
    return _dotImage;
}

- (UIView *)contentL
{
    if (_contentL == nil) {
        _contentL = [[UILabel alloc]initWithFrame:CGRectMake(35, _backImageView.height / 2 - 10 , _backImageView.width - 50, 20)];
        _contentL.textColor = [UIColor darkGrayColor];
        _contentL.font = YFont(15);
        _contentL.text = @"贷款初审2015-12-12  办理完成";
    }
    return _contentL;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
