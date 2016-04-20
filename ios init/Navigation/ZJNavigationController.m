//
//  ZJNavigationController.m
//  loveinvest
//
//  Created by babbage on 16/3/21.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ZJNavigationController.h"

@interface ZJNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation ZJNavigationController

-(void)viewDidLoad{
    [super viewDidLoad];
    //手势的代理方法
    self.interactivePopGestureRecognizer.delegate = self;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        UIButton * backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [backButton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:(UIControlStateNormal)];
        [backButton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:(UIControlStateHighlighted)];
        backButton.frame = CGRectMake(0, 0, 15, 15);
        [backButton addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
       
    }
   
    
    [super pushViewController:viewController animated:animated];
}
-(void)back{
//    [self popToRootViewControllerAnimated:YES];
    [self popViewControllerAnimated:YES];
}
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    BOOL ok = YES; // 默认为支持右滑反回
////    if ([self.topViewController isKindOfClass:[ZJNavigationController class]]) {
////        if ([self.topViewController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
////            ZJNavigationController * vc = (ZJNavigationController *)self.topViewController;
////            ok = [vc gestureRecognizerShouldBegin];
////        }
////    }
//    
//    return ok;
//}
//-(BOOL)gestureRecognizerShouldBegin{
//    [self popToRootViewControllerAnimated:YES];
//    return YES;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
