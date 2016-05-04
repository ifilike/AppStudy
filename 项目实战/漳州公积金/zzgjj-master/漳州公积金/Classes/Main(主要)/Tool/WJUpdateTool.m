//
//  WJUpdateTool.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/5.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "WJUpdateTool.h"
#import "WJBaseTool.h"
#import "WJVersion.h"
#import "WJHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "WJSysTool.h"
#import "AFNetworking.h"
#import "NSString+Xml.h"

typedef enum {
    WJUpdateToolAlertViewTypeUpdateMust, // 必须升级才能继续使用系统
    WJUpdateToolAlertViewTypeUpdateNormal // 正常升级
} WJUpdateToolAlertViewType;
@interface WJUpdateTool()<UIAlertViewDelegate>

@end

@implementation WJUpdateTool
/*
 检查是否需要升级
 */
+(void)CheckUpdate
{
    [self CheckUpdate:false];  //false表示不用提示
}

/**
 *  检查是否需要升级
 *
 *  @param prompt 是否弹出提示框
 */
+(void)CheckUpdate:(BOOL) prompt
{
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]  init];
    activityIndicatorView.width = 100;
    activityIndicatorView.height = 100;
    float centerX = [UIScreen mainScreen].bounds.size.width * 0.5;
    float centerY = [UIScreen mainScreen].bounds.size.height * 0.5;
    activityIndicatorView.center = CGPointMake(centerX, centerY);
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray];
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    [view addSubview : activityIndicatorView];
    
    if (prompt) {
//        [MBProgressHUD showMessage:@""];
        [activityIndicatorView startAnimating];
    }
    // 2.发送GET请求
    [mgr GET:@"http://2015.zzgjj.gov.cn/download/update.xml" parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObj) {
         if (prompt) {
//             [MBProgressHUD hideHUD];
             [activityIndicatorView stopAnimating];
         }
         WJLog(@"success:转换前：%@",responseObj);
         NSData *resultData = responseObj;
         NSString *result =  [[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
         WJLog(@"success:转换后：%@",result);
         // 返回的字典
         NSString *maxVersion = [result stringByXmlNoteContentWithElementName:@"iosMaxVersion"];  //最新版本号
         NSString *minVersion = [result stringByXmlNoteContentWithElementName:@"iosMinVersion"];  //强制升级的版本号
         //NSString *updateUrl = @"itms-services://?action=download-manifest&url=http://git.oschina.net/fengwujie/zzgjj/raw/master/manifest.plist";
         NSString *updateUrl = [result stringByXmlNoteContentWithElementName:@"iosUpdateUrl"];  //升级路径
         // 获得当前打开软件的版本号
         NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
         NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
         WJLog(@"%@",currentVersion);
         if ([currentVersion intValue] < [minVersion intValue]) {
             //提示升级，如果不升级的话，则退出系统
             [self showUpdatealert:updateUrl alertViewType:WJUpdateToolAlertViewTypeUpdateMust message:@"当前版本过低，必须更新才能使用，是否更新？"];
         }
         else if([maxVersion intValue] > [currentVersion intValue])
         {
             //提示是否升级，不升级的话仍然可以使用
             [self showUpdatealert:updateUrl alertViewType:WJUpdateToolAlertViewTypeUpdateNormal message:@"检测到新版本，是否更新？"];
         }
         else
         {
             //不需要升级
             if (prompt) {
                 // 提示已经是最新版本
//                 [MBProgressHUD showSuccess:@"当前版本已经是最新版本！"];
                 [WJSysTool ShowMessage:nil :@"当前版本已经是最新版本！"];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         WJLog(@"检查升级：访问网络出错：%@", error);
         if (prompt) {
//             [MBProgressHUD hideHUD];
//             [MBProgressHUD showError:@"检查升级出错，请检查网络是否可用！"];
             [activityIndicatorView stopAnimating];
             [WJSysTool ShowMessage:nil :@"检查升级出错，请检查网络是否可用！"];
         }
     }];

    
    /*
    // 获取数据库里面存储的版本号
    NSString *strURL = @"http://2015.zzgjj.gov.cn/download/update.xml";
    
    [WJHttpTool get:strURL params:nil success:^(id responseObj) {
        // 返回的字典
        NSString *maxVersion = responseObj[@"maxVersion"];  //最新版本号
        NSString *minVersion = responseObj[@"minVersion"];  //强制升级的版本号
        NSString *updateUrl = responseObj[@"updateUrl"];  //升级路径
        // 获得当前打开软件的版本号
        NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
        WJLog(@"%@",currentVersion);
        if ([currentVersion intValue] < [minVersion intValue]) {
            //提示升级，如果不升级的话，则退出系统
            [self showUpdatealert:updateUrl alertViewType:WJUpdateToolAlertViewTypeUpdateMust message:@"当前版本过低，必须更新才能使用，是否更新？"];
        }
        else if([maxVersion intValue] > [currentVersion intValue])
        {
            //提示是否升级，不升级的话仍然可以使用
            [self showUpdatealert:updateUrl alertViewType:WJUpdateToolAlertViewTypeUpdateNormal message:@"检测到新版本，是否更新？"];
        }
        else
        {
            //不需要升级
            if (prompt) {
                // 提示已经是最新版本
                [MBProgressHUD showSuccess:@"当前版本已经是最新版本！"];
            }
        }
    } failure:^(NSError *error) {
        WJLog(@"检查升级：访问网络出错：%@", error);
    }];
     */
}
/**
 *  提示升级
 *
 *  @param updateUrl           升级服务器网址
 *  @param alertViewTypeUpdate 升级类型：必须升级才能继续使用、正常升级提示
 *  @param message             提示内容
 */
+(void)showUpdatealert:(NSString *)updateUrl alertViewType:(WJUpdateToolAlertViewType) alertViewType message:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"升级提示" message:message delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alertView.delegate = self;
    alertView.tag = alertViewType;  //升级类型
    alertView.accessibilityValue=updateUrl;  //升级网址
    [alertView show];
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == WJUpdateToolAlertViewTypeUpdateMust) {
        if (buttonIndex == 0) {
            // 直接退出程序
            [WJSysTool exitApplication];
        }
        else if(buttonIndex == 1)
        {
            //升级
            [self updateWithUrl:alertView.accessibilityValue];
        }
    }
    else if(alertView.tag == WJUpdateToolAlertViewTypeUpdateNormal)
    {
        if (buttonIndex == 1) {
            // 升级
            [self updateWithUrl:alertView.accessibilityValue];
        }
    }
}
/**
 *  升级程序
 *
 *  @param updateUrl 服务器网址
 */
+(void)updateWithUrl:(NSString *)updateUrl
{
    NSString *url = [[NSString alloc] initWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&amp;url=%@", updateUrl]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
