//
//  ViewController.m
//  Alipay
//
//  Created by babbage on 16/4/11.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ViewController.h"
#import "AlipayViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self payForProduct];
   
}
-(void)payForProduct{
    Product *product = [[Product alloc] initWithTitle:@"商品标题" Detail:@"商品描述" price:0.01 orderId:nil];
    AlipayViewController *pay = [[AlipayViewController alloc] init];
    [pay payForProduct:product];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
