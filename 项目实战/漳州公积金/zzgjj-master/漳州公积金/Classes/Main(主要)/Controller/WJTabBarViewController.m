//
//  WJTabBarViewController.m
//  漳州公积金
//  自定义底部菜单
//

#import "WJTabBarViewController.h"
#import "WJHomeViewController.h"
#import "WJServicesViewController.h"
#import "WJMineViewController.h"
#import "WJSettingsViewController.h"
#import "WJNavigationController.h"
#import "WJTabBar.h"
#import "WJSysTool.h"

@interface WJTabBarViewController () //<WJTabBarDelegate, UITabBarControllerDelegate>
@property (nonatomic, weak) WJHomeViewController *home;
@property (nonatomic, weak) WJServicesViewController *services;
@property (nonatomic, weak) WJSettingsViewController *settings;
@property (nonatomic, weak) WJMineViewController *mine;
@property (nonatomic, weak) UIViewController *lastSelectedViewContoller;
@end

@implementation WJTabBarViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.tabBar.backgroundImage  = [UIImage resizedImage:@"tabbar_compose_button"];
    //self.tabBar.backgroundColor = [UIColor blueColor];
    // 添加所有的子控制器
    [self addAllChildVcs];
    
    // 创建自定义tabbar
    [self addCustomTabBar];
    
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UINavigationController *)viewController
//{
//    UIViewController *vc = [viewController.viewControllers firstObject];
//    if ([vc isKindOfClass:[WJHomeViewController class]]) {
//        if (self.lastSelectedViewContoller == vc) {
//            [self.home refresh:YES];
//        } else {
//            [self.home refresh:NO];
//        }
//    }
//    
//    self.lastSelectedViewContoller = vc;
//}
/**
 *  创建自定义tabbar
 */
- (void)addCustomTabBar
{
    // 创建自定义tabbar
    WJTabBar *customTabBar = [[WJTabBar alloc] init];
    //customTabBar.tabBarDelegate = self;
    //customTabBar.backgroundImage  = [UIImage resizedImage:@"tabbar_compose_button"];
    //[customTabBar setBackgroundColor:[UIColor blueColor]];
    // 更换系统自带的tabbar
    [self setValue:customTabBar forKeyPath:@"tabBar"];
}

/**
 *  添加所有的子控制器
 */
- (void)addAllChildVcs
{
    WJHomeViewController *home = [[WJHomeViewController alloc] init];
    [self addOneChlildVc:home title:@"首页" imageName:@"ic_tab_home_normal" selectedImageName:@"ic_tab_home_press"];
    self.home = home;
    self.lastSelectedViewContoller = home;
    
    WJServicesViewController *services = [[WJServicesViewController alloc] init];
    [self addOneChlildVc:services title:@"便民服务" imageName:@"ic_tab_server_normal" selectedImageName:@"ic_tab_server_press"];
    self.services = services;
    
    WJMineViewController *mine = [[WJMineViewController alloc] init];
    mine.strUrl = WJUrlGJJ;
    mine.bMainWeb = YES;
    [self addOneChlildVc:mine title:@"个人中心" imageName:@"ic_tab_account_normal" selectedImageName:@"ic_tab_account_press"];
    self.mine= mine;
    
    WJSettingsViewController *settings = [[WJSettingsViewController alloc] init];
    [self addOneChlildVc:settings title:@"设置" imageName:@"ic_tab_setting_normal" selectedImageName:@"ic_tab_setting_press"];
    self.settings = settings;
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 设置标题
    childVc.title = title;
    
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageWithName:imageName];
    float fontSize = 12;
    if ([WJSysTool deviceModel] == DeviceModeliPhone6Plus) {
        fontSize = 14;
    }
    // 设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    //textAttrs[UITextAttributeTextColor] = [UIColor blackColor];
    textAttrs[NSForegroundColorAttributeName] =WJColor(108,196,244); // [UIColor blackColor];
    //textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:10];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:fontSize];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    selectedTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:fontSize];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    if (iOS7) {
        // 声明这张图片用原图(别渲染)
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    
    // 添加为tabbar控制器的子控制器
    WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

- (void)viewWillLayoutSubviews{
//    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
//    tabFrame.size.height = 80;
//    tabFrame.origin.y = self.view.frame.size.height - 80;
    
//    self.tabBar.frame = tabFrame;
    float toolBarH = self.tabBar.height;
    if ([WJSysTool deviceModel] == DeviceModeliPhone6) {
        toolBarH = 55;
    }
    else if ([WJSysTool deviceModel] == DeviceModeliPhone6Plus) {
        toolBarH = 60;
    }
//    else if([WJSysTool getDeviceModel] == DeviceModeliPhone6Plus )
//    {
//        toolBarH = 50;
//    }
    self.tabBar.height = toolBarH;
    self.tabBar.y = self.view.height - self.tabBar.height;
}
@end