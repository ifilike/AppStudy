//
//  WDYYCollectionViewCell.m
//  AccumulationFund
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "WDYYCollectionViewCell.h"
#import "FundReferences.h"

@interface WDYYCollectionViewCell ()

@property (strong, nonatomic) UIView * circleView;

@property (strong, nonatomic) NSLayoutConstraint *backgroundLeadingCons;
@property (strong, nonatomic) NSLayoutConstraint *circleViewCenterCons;

@end

@implementation WDYYCollectionViewCell

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.center.x > k_screen_width * 0.5) {
        _backgroundImageView.image = [UIImage imageNamed:@"cell_background_white"];
        self.backgroundLeadingCons.constant = -5;
        self.circleViewCenterCons.constant = -30;
    } else {
        _backgroundImageView.image = [UIImage imageNamed:@"cell_background_white_mirror"];
        self.backgroundLeadingCons.constant = 0;
        self.circleViewCenterCons.constant = self.frame.size.width + 15;
    }
    
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.contentView.backgroundColor = BackgroundColor;
        
        [self.contentView addSubview:self.backgroundImageView];
        [self.contentView addSubview:self.infoLabel];
        [self.contentView addSubview:self.circleView];
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false;
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.circleView.translatesAutoresizingMaskIntoConstraints = false;
        
        NSMutableArray * constraints = [NSMutableArray array];
      
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(k_screen_width - 85) * 0.5 + 5]];
        

        self.backgroundLeadingCons = [NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-20];
        
        [constraints addObject:self.backgroundLeadingCons];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:(k_screen_width - 45 - 40) * 0.5]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:k_margin_horizontal]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-k_margin_horizontal]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:12]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-12]];

        self.circleViewCenterCons = [NSLayoutConstraint constraintWithItem:self.circleView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        [constraints addObject:self.circleViewCenterCons];
        
        CGFloat height = 20;
        if ([UIScreen mainScreen].bounds.size.width < 400) {
            height = 12.5;
        }
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.circleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:height]];
        [self.circleView addConstraint:[NSLayoutConstraint constraintWithItem:self.circleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:15]];
        [self.circleView addConstraint:[NSLayoutConstraint constraintWithItem:self.circleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:15]];

        
        
        [self addConstraints:constraints];
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
        _infoLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
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
