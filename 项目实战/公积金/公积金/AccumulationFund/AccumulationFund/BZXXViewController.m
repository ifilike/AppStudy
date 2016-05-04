//
//  BZXXViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "BZXXViewController.h"

@interface BZXXViewController ()

@property (strong, nonatomic) UIImageView * iconView;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * textLabel;
@property (strong, nonatomic) UIScrollView * scrollView;

@end

@implementation BZXXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];

    [self.scrollView addSubview:self.iconView];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.textLabel];
    
    self.iconView.translatesAutoresizingMaskIntoConstraints = false;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.textLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    
    NSMutableArray * constraints = [NSMutableArray array];
    NSDictionary * subviews = @{
                                @"icon" : self.iconView,
                                @"title" : self.titleLabel,
                                @"text" : self.textLabel,
                                @"scroll" : self.scrollView,
                                };
    
    NSDictionary * metrics = @{
                               };
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[icon]-[title]-[text]-|" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:subviews]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.iconView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.iconView.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.iconView.image = [UIImage imageNamed:@""];
    self.titleLabel.text = @"住房公积金";
    self.textLabel.text = @"阿萨德就挨打了考试大\n格尔嘎啊恶搞\n大上大大苏打";
    
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    }
    return _scrollView;
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
    }
    return _textLabel;
}

@end
