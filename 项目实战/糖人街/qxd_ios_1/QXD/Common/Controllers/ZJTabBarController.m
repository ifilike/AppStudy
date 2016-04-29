//
//  ZJTabBarController.m
//  Copyright (c) 2015年 朱杰. All rights reserved.
//

#import "ZJTabBarController.h"
#import "ZJNavigationController.h"
#import "ZJBaseController.h"
#import "HomeViewController.h"
#import "ProductViewController.h"
#import "ShareViewController.h"
//#import "FriendsViewController.h"
#import "MineViewController.h"
#import "AppDelegate.h"


@interface ZJTabBarController ()

@end

@implementation ZJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpinit];
}
-(void)setUpinit{
    //首页
    HomeViewController *home = [[HomeViewController alloc] init];
    [self setTabBarWithController:home WithUnselectImage:@"home_normal.png" WithSelectImg:@"home_highlighting.png"];
    
    
    //发现
    ProductViewController *theme = [[ProductViewController alloc] init];
    [self setTabBarWithController:theme WithUnselectImage:@"discover_normal.png" WithSelectImg:@"discover_highlighting.png"];
    
    //购物车
    self.shop = [[FriendsViewController alloc] init];
    [self setTabBarWithController:self.shop WithUnselectImage:@"shopping_normal" WithSelectImg:@"shopping_highlighting"];
    
    
    //登录
    MineViewController *mine = [[MineViewController alloc] init];
    [self setTabBarWithController:mine WithUnselectImage:@"me_normal" WithSelectImg:@"me_highlighting"];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setTabBarWithController:(UIViewController *)vc WithUnselectImage:(NSString *)unSelectImg WithSelectImg:(NSString *)selectImg{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    UIImage *select = [UIImage imageNamed:selectImg];
    UIImage *unSelect = [UIImage imageNamed:unSelectImg];
    select = [select imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    unSelect = [unSelect imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = select;
    vc.tabBarItem.image = unSelect;
    UIEdgeInsets inset = UIEdgeInsetsMake(4, 0, -4, 0);
    [vc.tabBarItem setImageInsets:inset];
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
