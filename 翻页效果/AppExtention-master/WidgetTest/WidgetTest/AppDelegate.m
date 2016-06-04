//
//  AppDelegate.m
//  WidgetTest
//
//  Created by maqj on 15/9/14.
//  Copyright (c) 2015年 maqj. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.alpha = 0.8f;
//    
//    [self.window makeKeyAndVisible];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.center = self.window.center;
//    button.frame = CGRectMake(100.0f, 100.0f, 100.0f, 40.0f);
//    button.backgroundColor = [UIColor redColor];
//    [button setTitle:@"Fuck me" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [self.window addSubview:button];
    NSHashTable *t;
    [t hash];
    NSDictionary *d;
    
    UINavigationController *n;
    
    CAAnimation *ca;
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSLog(@"%s", __FUNCTION__);
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    NSLog(@"%s", __FUNCTION__);
    
    //异常退出
    [self exitApplication];
    
    return YES;
}
- (void)exitApplication {

    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:0.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    //exit(0);
    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSLog(@"%s", __FUNCTION__);

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
