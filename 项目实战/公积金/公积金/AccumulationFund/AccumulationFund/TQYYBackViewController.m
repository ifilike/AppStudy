//
//  TQYYBackViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "TQYYBackViewController.h"
#import "FundReferences.h"

@interface TQYYBackViewController ()

@end

@implementation TQYYBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    [self.view addSubview:self.backView];
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        
        _backView.backgroundColor = [UIColor whiteColor];
        if (mySystemVersion >= 7.0 ) {
            _backView.frame = CGRectMake(k_margin_vertical, k_margin_vertical + 64, self.view.frame.size.width - k_margin_vertical * 2, self.view.frame.size.height - k_margin_vertical * 2 - 64);
        } else {
            _backView.frame = CGRectMake(k_margin_vertical, k_margin_vertical, self.view.frame.size.width - k_margin_vertical * 2, self.view.frame.size.height - k_margin_vertical * 2);
        }
        
    }
    return _backView;
}

@end
