//
//  NewsEmptyCell.m
//  AccumulationFund
//
//  Created by mac on 15/12/11.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "NewsEmptyCell.h"
#import "DataSourceCenter.h"
#import "FundReferences.h"

@implementation NewsEmptyCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.layer.masksToBounds = false;
        self.clipsToBounds = false;
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false;
        self.cellHeightCons = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
        [self.contentView addConstraint:self.cellHeightCons];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width]];
    }
    return self;
}


- (void)startLoadInformation {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            onceToken = 0;
            if (!self.selected) {
                self.statusLabel.text = @"    网速不给力哦    \n    点击刷新    ";
                self.backView.backgroundColor = [UIColor clearColor];
                [self.activeIndicator stopAnimating];
                self.selected = false;
            }

        });
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:@"allNewsDidLoadNotification" object:nil];
        [self start];
    });
}

- (void)start {
    self.statusLabel.text = @"";
    [self.activeIndicator startAnimating];
    self.backView.backgroundColor = BackgroundColor;
    [[DataSourceCenter sharedDataSourceCenter] newsInformationStartLoading];
}

- (void)back {
    self.selected = true;
}

@end
