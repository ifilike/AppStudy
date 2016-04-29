//
//  AppDelegate.m
//  QXD
//
//  Created by ZhangRui on 15/11/9.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "AppDelegate.h"
#import "ZJTabBarController.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import <AlipaySDK/AlipaySDK.h>
#import "GuideViewController.h"
#import "WXApi.h"
#import "CalucateViewController.h"




@interface AppDelegate ()
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) ZJTabBarController *zjTaBar;
@property (nonatomic,assign) NSInteger totalShoppingNum;//购物车总数
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:2.0];
    [UIView animateWithDuration:1 animations:^{
        [_window makeKeyAndVisible];
    }];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        self.window.rootViewController = [[GuideViewController alloc] init];
    }else{
        [self creatMainViewController];
    }
    
    //配置Appkey，设置发送策略和填写渠道id三部分
    [MobClick startWithAppkey:UMAppKey reportPolicy:BATCH channelId:@"QXD"];
    //有梦分享
    [UMSocialData setAppKey:UMAppKey];

    //开启新浪sso
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
//    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://www.umeng.com/social"];
    //微信
    [UMSocialWechatHandler setWXAppId:@"wx6331e9f3100a2435" appSecret:@"1f4d84cf1aa2892e0940788bd5bcf928" url:@"www.qiuxinde.com"];
    //设置分享到QQ互联的appId和appKey
   // [UMSocialQQHandler setQQWithAppId:@"101230512" appKey:@"204066e47db9b12230871ffc504a7650" url:@"http://www.qiuxinde.com"];
    
     [UMSocialQQHandler setQQWithAppId:@"1105067230" appKey:@"OQsatf1wKTkqF5VW" url:@"http://www.qiuxinde.com"];
    
    /****************       注册微信支付信息    *****************/
    [WXApi registerApp:WX_AppID];
    
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    //让程序只支持竖屏,播放视频的时候除外
    
    if ([NSStringFromClass([[[window subviews]lastObject] class]) isEqualToString:@"UITransitionView"]) {
        return UIInterfaceOrientationMaskAll;
        //优酷 土豆  乐视  已经测试可以
    }
    return UIInterfaceOrientationMaskPortrait;
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [WXApi handleOpenURL:url delegate:self];
//}

//#pragma mark - WXApiDelegate
//-(void)onResp:(BaseResp *)resp {
//    if ([resp isKindOfClass:[PayResp class]]) {
//       
//       
//    }
//}
//- (void)onReq:(BaseReq *)req {
//    
//}

-(void)creatMainViewController{
//    ZJTabBarController *tabBarVC = [[ZJTabBarController alloc] init];
//    self.window.rootViewController = tabBarVC;//tabBar------>不能控制？ uitabbarcontroller
    self.window.rootViewController = self.zjTaBar;
}
-(void)creatNumberWithcontroller:(NSInteger)number{
    self.numLabel.backgroundColor = [self colorWithHexString:@"#FD681F"];
    self.numLabel.layer.cornerRadius = 8*PROPORTION_WIDTH;
    self.numLabel.layer.masksToBounds = YES;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",number];
    NSLog(@"%@",self.numLabel.text);
    self.numLabel.font = [UIFont boldSystemFontOfSize:11*PROPORTION_WIDTH];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.textColor = [UIColor whiteColor];
    if (number >10) {
        self.numLabel.font = [UIFont boldSystemFontOfSize:9*PROPORTION_WIDTH];
        if (number >99) {
            self.numLabel.font = [UIFont boldSystemFontOfSize:8*PROPORTION_WIDTH];
            self.numLabel.text = @"99";
            //            UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(253, 0, 8, 8)];
            //            addLabel.text = @"+";
            //            addLabel.font = [UIFont boldSystemFontOfSize:11*PROPORTION_WIDTH];
            //            addLabel.textColor = [self colorWithHexString:@"#FD681F"];
            //            [_shop.tabBarController.tabBar addSubview:addLabel];
        }
    }
    if (number == 0) {
        self.numLabel.hidden = YES;
    }else{
        self.numLabel.hidden = NO;
    }
    
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSString *new = [change objectForKey:@"new"];
    NSInteger abc = [new integerValue];
    if ([keyPath isEqualToString:@"numberWithShopping"]) {
        [self creatNumberWithcontroller:abc];
    }
    self.totalShoppingNum = abc;
    NSLog(@"_______________%ld",self.totalShoppingNum);
}

-(UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(240*PROPORTION_WIDTH, 3*PROPORTION_WIDTH, 16*PROPORTION_WIDTH, 16*PROPORTION_WIDTH)];
        [self.zjTaBar.tabBar addSubview:_numLabel];
        
    
    }
    return _numLabel;
}
-(ZJTabBarController *)zjTaBar{
    if (!_zjTaBar) {
        _zjTaBar = [[ZJTabBarController alloc] init];
    }
    return _zjTaBar;
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
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return  [UMSocialSnsService handleOpenURL:url];
//}
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation
//{
//    return  [UMSocialSnsService handleOpenURL:url];
//}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        if ([url.host isEqualToString:@"pay"]) {
            CalucateViewController *pay = [[CalucateViewController alloc] init];
            return [WXApi handleOpenURL:url delegate:pay];
        }
        
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                
        }];
            
        }
    }
   
    return result;
}

#pragma mark --- 懒加载 ---
-(NSInteger)totalShoppingNum{
    if (!_totalShoppingNum) {
        _totalShoppingNum = 0;
    }
    return _totalShoppingNum;
}
-(NSInteger)totalCountWithShopping{
    return self.totalShoppingNum;
}

#pragma mark --- 颜色 ---
- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


@end
