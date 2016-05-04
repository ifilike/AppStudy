//
//  AppDelegate.m
//  AccumulationFund
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "AppDelegate.h"

#import <BugHD/BugHD.h>
#import <CoreLocation/CoreLocation.h>
#import "MainViewController.h"
#import "NewFeatureViewController.h"
#import "FundReferences.h"
#import "DataSourceCenter.h"
#import "AccountInfoCenter.h"
#import "UserAccountInfo.h"
#import "LoginViewController.h"
#import "ConvenientTools.h"
//#import "BMKMapView"
@interface AppDelegate ()

@property (strong, nonatomic) NewFeatureViewController * firstLaunchVC;
@property (strong, nonatomic) UINavigationController *loginVC;
@property (strong, nonatomic) UITabBarController * mainVC;
@property (strong, nonatomic) CLLocationManager *locm;

@end

@implementation AppDelegate

- (void)loadDataQuick {
    // 加载新闻界面数据
    [[DataSourceCenter sharedDataSourceCenter] newsInformationStartLoading];
    
    if ([UserAccountInfo sharedUserAccountInfo].account.length > 0) {
        // 加载贷款查询界面数据
        [[AccountInfoCenter sharedAccountInfoCenter] accountInformationrStartLoading];
        // 加载便民工具界面数据
        [[ConvenientTools sharedConvenientTools] convenientToolsInformationrStartLoading];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self loadDataQuick];
    [self setAppearanceColor];
    
#pragma mark - 第三方
    [BugHD handleCrashWithKey:@"02801209e94880d99e6d016b83e875ba"];
    _mapManager = [[BMKMapManager alloc] init];
    [_mapManager start:@"cvv5sHCT0GnYBDpdGjH1KlMB" generalDelegate:nil];
    BOOL ret = [_mapManager start:@"cvv5sHCT0GnYBDpdGjH1KlMB" generalDelegate:nil];
    if (!ret) {
        NSLog(@"--------------------------------百度地图Key验证失败");
    }
    
    if (mySystemVersion >= 8.0) {
        [self.locm requestWhenInUseAuthorization];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [self isFirstLaunchApp] ? self.firstLaunchVC : [self getRootViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootViewController:) name:@"changeRootViewControllerNotification" object:nil];
    
    return YES;
}

- (void)setAppearanceColor {
    [UINavigationBar appearance].barTintColor = BarColor;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100) forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].backItem.leftItemsSupplementBackButton = false;
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [UITabBar appearance].barTintColor = BarColor;
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:71/255.0 green:143/255.0 blue:154/255.0 alpha:1]} forState:UIControlStateSelected];
}

- (CLLocationManager *)locm {
    if (_locm == nil) {
        _locm = [[CLLocationManager alloc] init];
    }
    return _locm;
}

- (UINavigationController *)loginVC {
    if (_loginVC == nil) {
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
        UINavigationController * navc = [sb instantiateViewControllerWithIdentifier:@"loginNavigation"];
        _loginVC = navc;
    }
    return _loginVC;
}

- (UITabBarController *)mainVC {
    if (_mainVC == nil) {
        _mainVC = [[MainViewController alloc] init];
    }
    return _mainVC;
}

- (NewFeatureViewController *)firstLaunchVC {
    if (_firstLaunchVC == nil) {
        _firstLaunchVC = [[NewFeatureViewController alloc] init];
    }
    return _firstLaunchVC;
}

- (UIViewController *)getRootViewController {
    if ([UserAccountInfo sharedUserAccountInfo].account.length > 0) {
        return self.mainVC;
    } else {
        return self.loginVC;
    }
}

- (BOOL)isFirstLaunchApp {
    double currentVersion = [[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"] doubleValue];
//    NSLog(@"当前版本 %@", @(currentVersion));
    double sandboxVersion = [[NSUserDefaults standardUserDefaults] doubleForKey:@"sandboxVersionKey"];
//    NSLog(@"之前版本 %@", @(sandboxVersion));
    BOOL result = currentVersion > sandboxVersion;
    if (result) {
        [[NSUserDefaults standardUserDefaults] setDouble:currentVersion forKey:@"sandboxVersionKey"];
    }
    return true;
}

- (void)changeRootViewController:(NSNotification *)notification {
    NSString *className = notification.userInfo[@"className"];
    if ([className isEqualToString:@"MainViewController"]) {
        [UIApplication sharedApplication].keyWindow.rootViewController = self.mainVC;
    }
    if ([className isEqualToString:@"LoginViewController"]) {
        [UIApplication sharedApplication].keyWindow.rootViewController = self.loginVC;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //[BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[BMKMapView willBackGround];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
