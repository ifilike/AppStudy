//
//  ViewController.m
//  WXPay
//
//  Created by babbage on 16/4/11.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ViewController.h"
#import "WXPayViewController.h"

@interface ViewController ()

@property (nonatomic,strong)WXPayViewController *pay;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor cyanColor];
    
    self.pay = [[WXPayViewController alloc] init];
    [self.pay WXPayWithBody:nil totalMoney:@"11" orderId:nil];//这个orderId可以自己生成也可以后台
}

- (void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]addObserver:self.pay selector:@selector(WXPaySucceed) name:@"WXPaySucceed" object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXPaySucceed" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
