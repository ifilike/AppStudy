//
//  WJWebViewController.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/4.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "WJWebViewController.h"
#import "MBProgressHUD+MJ.h"
#import "WJSysTool.h"

@interface WJWebViewController ()<UIWebViewDelegate>
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation WJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] init];
    [self.view addSubview:webView];
    float h = self.view.height - 64 ;
    if (self.isMainWeb) {
        h -= self.tabBarController.tabBar.height;
    }
    webView.frame = CGRectMake(0, 0, self.view.width, h);
    //webView.height -= self.tabBarController.tabBar.height;
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    // 设置属性：
    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    self.webView = webView;
//    webView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]  init];
    activityIndicatorView.width = 100;
    activityIndicatorView.height = 100;
    float centerX = [UIScreen mainScreen].bounds.size.width * 0.5;
    float centerY = [UIScreen mainScreen].bounds.size.height * 0.5;
    activityIndicatorView.center = CGPointMake(centerX, centerY);
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray];
    [self.view addSubview : activityIndicatorView];
    self.activityIndicatorView = activityIndicatorView;

    
    NSURL* url = [NSURL URLWithString: self.strUrl];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [webView loadRequest:request];//加载
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //[MBProgressHUD showMessage:@"加载网页"];
    [self.activityIndicatorView startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [MBProgressHUD hideHUD];
    [self.activityIndicatorView stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [MBProgressHUD hideHUD];
    [self.activityIndicatorView stopAnimating];
    [WJSysTool ShowMessage:nil :@"加载网页错误，请检查网络是否可用！"];
//    [MBProgressHUD showError:@"加载网页错误，请检查网络是否可用！"];
//    WJLog(@"Fail:error:%@, WebView:%@",error, webView.request.URL);
//    [MBProgressHUD showError: [NSString stringWithFormat: @"加载数据出错：%@", error]];
}

@end
