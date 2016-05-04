//
//  WDYYCollectionView.m
//  AccumulationFund
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "WDYYCollectionView.h"
#import "FundReferences.h"
#import "WDYYColletionViewBackgroundView.h"


@interface WDYYCollectionView ()

@property (strong, nonatomic) NSLayoutConstraint * heightCons;

@end

@implementation WDYYCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self != nil) {
        UIView * centerXLine = [[UIView alloc] init];
        [self addSubview:centerXLine];
        centerXLine.backgroundColor = BarColor;
        centerXLine.translatesAutoresizingMaskIntoConstraints = false;
        
        [centerXLine addConstraint:[NSLayoutConstraint constraintWithItem:centerXLine attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:3]];
        self.heightCons = [NSLayoutConstraint constraintWithItem:centerXLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
        [centerXLine addConstraint:self.heightCons];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:centerXLine attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:centerXLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:-k_screen_height]];
        UIView * circleView = [[UIView alloc] init];
        circleView.backgroundColor = [UIColor orangeColor];
        circleView.layer.cornerRadius = 7.5;
        [centerXLine addSubview:circleView];
        circleView.translatesAutoresizingMaskIntoConstraints= false;
        [centerXLine addConstraint:[NSLayoutConstraint constraintWithItem:circleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:centerXLine attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [circleView addConstraint:[NSLayoutConstraint constraintWithItem:circleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:15]];
        [circleView addConstraint:[NSLayoutConstraint constraintWithItem:circleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:15]];
        [centerXLine addConstraint:[NSLayoutConstraint constraintWithItem:circleView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:centerXLine attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.heightCons.constant = self.contentSize.height - 20 + k_screen_height + 40;
}

@end
