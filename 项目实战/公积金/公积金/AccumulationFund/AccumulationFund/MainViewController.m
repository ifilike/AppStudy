//
//  MainViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "MainViewController.h"
#import "NewsNavController.h"
#import "AccountNavController.h"
#import "ToolsNavController.h"
#import "AboutNavController.h"
#import "NewsViewController.h"
#import "AccountViewController.h"
#import "ToolsViewController.h"
#import "AboutViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NewsViewController * newsVC = [[NewsViewController alloc] init];
    NewsNavController * newsNC = [[NewsNavController alloc] initWithRootViewController:newsVC];
    
    AccountViewController * accountVC = [[AccountViewController alloc] init];
    AccountNavController * accountNC = [[AccountNavController alloc] initWithRootViewController:accountVC];
    
    ToolsViewController * toolsVC = [[ToolsViewController alloc] init];
    ToolsNavController * toolsNC = [[ToolsNavController alloc] initWithRootViewController:toolsVC];
    
    AboutViewController * aboutVC = [[AboutViewController alloc] init];
    AboutNavController * aboutNC = [[AboutNavController alloc] initWithRootViewController:aboutVC];
    
    newsNC.tabBarItem.title = @"新闻动态";
    accountNC.tabBarItem.title = @"账户查询";
    toolsNC.tabBarItem.title = @"便民工具";
    aboutNC.tabBarItem.title = @"关于我们";
    
    
    newsNC.tabBarItem.image = [[UIImage imageNamed:@"首页_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    newsNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"首页_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    accountNC.tabBarItem.image = [[UIImage imageNamed:@"账户查询_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    accountNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"账户查询_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    toolsNC.tabBarItem.image = [[UIImage imageNamed:@"便民工具_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    toolsNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"便民工具_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    aboutNC.tabBarItem.image = [[UIImage imageNamed:@"关于我们_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    aboutNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"关于我们_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    newsVC.navigationItem.title = @"首页";
    accountVC.navigationItem.title = @"账户查询";
    toolsVC.navigationItem.title = @"便民工具";
    aboutVC.navigationItem.title = @"关于我们";
    
    self.viewControllers = @[newsNC, accountNC, toolsNC, aboutNC];
    

}



@end
