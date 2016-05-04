//
//  YSSMViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "YSSMViewController.h"

@interface YSSMViewController ()

@property (strong, nonatomic) UITextView * mainTextView;

@end

@implementation YSSMViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.view addSubview:self.mainTextView];

}

- (UITextView *)mainTextView {
    if (_mainTextView == nil) {
        _mainTextView = [[UITextView alloc] initWithFrame:self.view.frame];
        
        NSAttributedString * headerStr = [[NSAttributedString alloc] initWithString:@"隐私声明"];
#warning TODO
        _mainTextView.text = @"四大行卡SD卡大会的开始就阿訇多久阿克苏电话卡机阿克苏的哈可接受的";
    }
    return _mainTextView;
}

@end
