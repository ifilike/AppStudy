//
//  NewFeatureCell.m
//  AccumulationFund
//
//  Created by SL🐰鱼子酱 on 15/11/14.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "NewFeatureCell.h"
#import "NewFeatureViewController.h"


@interface NewFeatureCell ()
@property (strong, nonatomic) UIImageView * bgView;
@property (strong, nonatomic) UIButton * startButton;

@end


@implementation NewFeatureCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self addSubview:self.bgView];
        [self addSubview:self.startButton];
        
    }
    return self;
}

- (void)setImageIndex:(NSInteger)imageIndex {
    _imageIndex = imageIndex;
    self.bgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new_feature%li", imageIndex + 1]];
}




- (UIImageView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _bgView;
}

- (UIButton *)startButton {
    if (_startButton == nil) {
        _startButton = [[UIButton alloc] init];
        _startButton.bounds = CGRectMake(0, 0, 200, 50);
        _startButton.center = self.center;
        [_startButton addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_startButton setTitle:@"开始" forState:UIControlStateNormal];
    }
    return _startButton;
}

- (void)showStartButton {
    self.startButton.transform = CGAffineTransformMakeScale(0, 0);
    self.startButton.hidden = false;
    self.startButton.userInteractionEnabled = false;
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.startButton.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.startButton.userInteractionEnabled = true;
    }];
}

- (void)startButtonClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootViewControllerNotification" object:nil userInfo:@{@"className" : @"MainViewController"}];
}

@end
