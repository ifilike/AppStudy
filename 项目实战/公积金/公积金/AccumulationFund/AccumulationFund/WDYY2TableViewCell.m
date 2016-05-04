//
//  WDYY2TableViewCell.m
//  AccumulationFund
//
//  Created by mac on 15/11/21.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "WDYY2TableViewCell.h"
#import "FundReferences.h"

@interface WDYY2TableViewCell ()

@property (strong, nonatomic) UIView * circleView;

@property (strong, nonatomic) NSLayoutConstraint *circleViewCenterCons;

@end

@implementation WDYY2TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.backgroundImageView];
        [self.contentView addSubview:self.infoLabel];
        [self.contentView addSubview:self.circleView];
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false;
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.circleView.translatesAutoresizingMaskIntoConstraints = false;
        
        NSMutableArray * constraints = [NSMutableArray array];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:k_margin_vertical]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-k_margin_vertical]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:k_screen_width * 0.25 + k_margin_horizontal]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeWidth   relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:k_screen_width * 0.6 - 2 * k_margin_horizontal]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.infoLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:k_margin_horizontal]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.infoLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant: -k_margin_vertical]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.infoLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant: k_margin_vertical]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.infoLabel attribute:NSLayoutAttributeLeading multiplier:1.0 constant: -k_margin_vertical - 25]];
        
        self.circleViewCenterCons = [NSLayoutConstraint constraintWithItem:self.circleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:k_screen_width * 0.125];
        [constraints addObject:self.circleViewCenterCons];
        
        
        CGFloat height = 20;
        if ([UIScreen mainScreen].bounds.size.width < 400) {
            height = 12.5;
        }
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.circleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:height]];
        [self.circleView addConstraint:[NSLayoutConstraint constraintWithItem:self.circleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:15]];
        [self.circleView addConstraint:[NSLayoutConstraint constraintWithItem:self.circleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:15]];
        
        [self.contentView addConstraints:constraints];
    }
    return self;
}

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:@"cell_background_white"];
    }
    return _backgroundImageView;
}

- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.numberOfLines = 0;
        _infoLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    }
    return _infoLabel;
}

- (UIView *)circleView {
    if (_circleView == nil) {
        _circleView = [[UIView alloc] init];
        _circleView.backgroundColor = BarColor;
        _circleView.layer.cornerRadius = 7.5;
    }
    return _circleView;
}

@end
