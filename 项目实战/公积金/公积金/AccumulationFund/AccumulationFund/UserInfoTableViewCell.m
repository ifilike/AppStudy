//
//  UserInfoTableViewCell.m
//  AccumulationFund
//
//  Created by mac on 15/11/19.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "UserInfoTableViewCell.h"
#import "FundReferences.h"
#import "UIColor+Hex.h"
#import "UIView+CG.h"

@implementation UserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.rightLabel];    }
    return self;
}

//左边的Label
- (UILabel *)leftLabel {
    if (_leftLabel == nil) {
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(k_screen_width / 17, self.height / 2 - 10, k_screen_width / 2 - k_screen_width / 17, 20)];
        _leftLabel.textColor = [UIColor blackColor];
        _leftLabel.font = YFont(16);
        
    }
    return _leftLabel;
}

//右边的Label
- (UILabel *)rightLabel {
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftLabel.frame) -30 , CGRectGetMinY(_leftLabel.frame), _leftLabel.width  + 30, _leftLabel.height)];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.font = YFont(15);
        _rightLabel.textColor = [UIColor grayColor];
        //_rightLabel.backgroundColor = [UIColor greenColor];
        
    }
    return _rightLabel;
}




- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"ececec"].CGColor);
    CGContextStrokeRect(context, CGRectMake(20, rect.size.height , rect.size.width - 40, 1));
}

@end
