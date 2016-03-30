//
//  ZJTabBarViewController.m
//  loveinvest
//
//  Created by babbage on 16/3/16.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ZJTabBarViewController.h"
#import "ZJTabBar.h"
//#import "HomeViewController.h"
#import "ZJNavigationController.h"

#import "HomePageViewController.h"
#import "ProjectViewController.h"
#import "PublicWelfareViewController.h"
#import "CommunicationViewController.h"
#import "MineViewController.h"



@interface ZJTabBarViewController ()<ZJTabBarDelegate>
/**
 *  自定义的tabbar
 */
@property (nonatomic, weak) ZJTabBar *customTabBar;
@end

@implementation ZJTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化tabbar
    [self setupTabbar];
    
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

/**
 *  初始化tabbar
 */
- (void)setupTabbar
{
    ZJTabBar *customTabBar = [[ZJTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(ZJTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to
{
    if (self.selectedIndex == to && to == 0 ) {//双击刷新制定页面的列表
        UINavigationController *nav = self.viewControllers[0];
        HomePageViewController *homeVC = nav.viewControllers[0];
//        [homeVC refrshUI];
    }
    self.selectedIndex = to;
}

/**
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers
{
    // 1.首页
    HomePageViewController *home = [[HomePageViewController alloc] init];
//    home.tabBarItem.badgeValue = @"N";
    [self setupChildViewController:home title:@"首页" imageName:@"shouye1" selectedImageName:@"80"];
    
    // 2.项目
    ProjectViewController *project = [[ProjectViewController alloc] init];
//    project.tabBarItem.badgeValue = @"8";
    [self setupChildViewController:project title:@"项目" imageName:@"xiangmu1" selectedImageName:@"xiangmu2"];
    
    // 3.公益
    PublicWelfareViewController *publicWelfare = [[PublicWelfareViewController alloc] init];
//    publicWelfare.tabBarItem.badgeValue = @"19";
    [self setupChildViewController:publicWelfare title:@"公益" imageName:@"gongyi1" selectedImageName:@"gongyi2"];
    
    // 4.交流
    CommunicationViewController *communication = [[CommunicationViewController alloc] init];
//    communication.tabBarItem.badgeValue = @"99";
    [self setupChildViewController:communication title:@"交流" imageName:@"jiaoliu1" selectedImageName:@"jiaoliu2"];
    // 5.我的
    MineViewController *mine = [[MineViewController alloc] init];
//    mine.tabBarItem.badgeValue = @"93";
    [self setupChildViewController:mine title:@"我的" imageName:@"wode1" selectedImageName:@"wode2"];
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (iOS7) {
        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = selectedImage;
    }
    
    // 2.包装一个导航控制器
    ZJNavigationController *nav = [[ZJNavigationController alloc] initWithRootViewController:childVc];
    //设置状态栏的字体大小颜色
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"head.jpg"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName,nil];
    [nav.navigationBar setTitleTextAttributes:attributes];
    [self addChildViewController:nav];
    
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
    
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
