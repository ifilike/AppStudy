//
//  BuyViewController.m
//  QXD
//
//  Created by WZP on 15/11/16.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "BuyViewController.h"
#import "NaviagtionBarShareView.h"
#import "WithLabelImageScrollView.h"


@interface BuyViewController ()

@end

@implementation BuyViewController

#define HEIGHT [[UIScreen mainScreen] bounds].size.height

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    NaviagtionBarShareView * shareBar=[[NaviagtionBarShareView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
//    
//    [shareBar.cancellBut addTarget:self action:@selector(cancell) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:shareBar];
    //设置控制器的属性,滚动视图的子视图位置不会受到navigationbar的影响;
//    self.automaticallyAdjustsScrollViewInsets=NO;
//    self.scrollView.bounces=NO;
//    self.scrollView.backgroundColor=[UIColor cyanColor];
//
    
    
  
   // UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 400)];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}
//返回上一页
- (void)cancell{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
