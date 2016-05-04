//
//  WJSettingsViewController.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/4.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "WJSettingsViewController.h"
#import "WJCommonGroup.h"
#import "WJCommonArrowItem.h"
#import "WJCommonLabelItem.h"
#import "WJUpdateTool.h"
#import "WJSysTool.h"

typedef enum {
    WJSettingsAlertViewTypeLogout // 退出程序
} WJSettingsAlertViewType;

@interface WJSettingsViewController ()<UIAlertViewDelegate>


@end

@implementation WJSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = WJRandomColor;
    [self setupGroups];
    [self setupFooter];
}
- (void)setupFooter
{
    // 1.创建按钮
    UIButton *logout = [[UIButton alloc] init];
    
    // 2.设置属性
    logout.titleLabel.font = [UIFont systemFontOfSize:14];
    [logout setTitle:@"退出程序" forState:UIControlStateNormal];
    [logout setTitleColor:WJColor(255, 10, 10) forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [logout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.设置尺寸(tableFooterView和tableHeaderView的宽度跟tableView的宽度一样)
    logout.height = 35;
    
    self.tableView.tableFooterView = logout;
}
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup0];
}

- (void)setupGroup0
{
    // 1.创建组
    WJCommonGroup *group = [WJCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    WJCommonLabelItem *version = [WJCommonLabelItem itemWithTitle:@"软件说明"];
    
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    version.text =[NSString stringWithFormat:@"版本号：%@", currentVersion] ;
    
//    WJCommonArrowItem *update = [WJCommonArrowItem itemWithTitle:@"软件升级"];
//    update.operation = ^{
//        [WJUpdateTool CheckUpdate : YES];
//    };
    group.items = @[version];//,update
}

/** 退出程序 */
-(void) logout
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要退出程序吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = WJSettingsAlertViewTypeLogout;
    [alertView show];

}

#pragma mark UIAlertView代理 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == WJSettingsAlertViewTypeLogout) {
        if (buttonIndex == 1) {
//            [self exitApplication];
            [WJSysTool exitApplication];
        }
    }
}

/*
- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //[UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:window cache:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    //self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
    
}
 */
@end
