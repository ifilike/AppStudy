//
//  LoginViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/21.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "LoginViewController.h"
#import "FundReferences.h"
#import "UIViewController+KeyboardShowOrHide.h"
#import "GJJAPI.h"
#import "SVProgressHUD.h"
#import "UserAccountInfo.h"
#import "AccountInfoCenter.h"
#import "AboutViewController.h"
#import "MainViewController.h"
#import "AboutNavController.h"
#import "RegisterViewController.h"
#import "ConvenientTools.h"

@interface LoginViewController () <UITextFieldDelegate, RegisterDidSuccessDelegate>
//60
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons1;
//60
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons2;
//60
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons3;
//60
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat I6PStdHeight;
    if ([UIScreen mainScreen].bounds.size.width == 375) {
        I6PStdHeight = 40;
    } else if ([UIScreen mainScreen].bounds.size.width > 375) {
        I6PStdHeight = 60;
    } else if ([UIScreen mainScreen].bounds.size.width < 375) {
        I6PStdHeight = 30;
    }
    self.heightCons1.constant = I6PStdHeight;
    self.heightCons2.constant = I6PStdHeight;
    self.heightCons3.constant = I6PStdHeight * 1.5;
    self.heightCons4.constant = I6PStdHeight;
    self.widthCons.constant = [UIScreen mainScreen].bounds.size.width * 0.75;
    
    self.label1.delegate = self;
    self.label2.delegate = self;
    self.label3.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self keyboardDidAppear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self keyboardDidDisappear];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag < 100002) {
        UIView * v = [self.view viewWithTag:(textField.tag + 1)];
        NSLog(@"%@", v);
        [v becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        if (self.loginButton.enabled) {
            [self.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
    return true;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

- (BOOL)isChinese:(NSString *)str {
    for(int i=0; i< [str length];i++) {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            continue;
        } else {
            return NO;
        }
    }
    return YES;
}

- (IBAction)loginButtonClick:(UIButton *)sender {
    if (self.label1.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的用户名" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (![self isChinese:self.label1.text]) {
        [SVProgressHUD showErrorWithStatus:@"请使用实名用户名" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (self.label2.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请检查您的手机号码" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (self.label3.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"密码不可为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }

    [SVProgressHUD showWithStatus:@"登录中" maskType:SVProgressHUDMaskTypeBlack];
    [GJJAPI login_用户姓名:self.label1.text 密码:self.label3.text 手机:self.label2.text completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            [SVProgressHUD showErrorWithStatus:@"网络错误" maskType:SVProgressHUDMaskTypeBlack];
            return;
        }
        if ([result isKindOfClass:[NSDictionary class]] && ![result[@"ret"] isKindOfClass:[NSNull class]] && [result[@"ret"] isEqualToString:@"0"]) {
            
            [SVProgressHUD showSuccessWithStatus:@"登录成功" maskType:SVProgressHUDMaskTypeBlack];
            UserAccountInfo *instance = [UserAccountInfo sharedUserAccountInfo];
            instance.username = self.label1.text;
            instance.cellphone = self.label2.text;
            instance.password = self.label3.text;
            instance.account = [result[@"data"] lastObject][@"zgzh"];
            instance.staffNumber = [result[@"data"] lastObject][@"zgbh"];
            
            if (![instance archive]) {
                NSLog(@"userAccountInfo 归档错误");
            }
            
            [[AccountInfoCenter sharedAccountInfoCenter] accountInformationrStartLoading];
            [[ConvenientTools sharedConvenientTools] convenientToolsInformationrStartLoading];
            if ([self.navigationController.viewControllers.firstObject isKindOfClass:[LoginViewController class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootViewControllerNotification" object:nil userInfo:@{@"clasName" : @"MainViewController"}];
            } else {
                
                UIResponder *responder = self.nextResponder;
                while (responder != nil) {
                    if ([responder isKindOfClass:[MainViewController class]]) {
                        break;
                    }
                    responder = responder.nextResponder;
                }
                if (responder != nil) {
                    MainViewController *mainVC = (MainViewController *)responder;
                    AboutNavController *aboutNav = (AboutNavController *)mainVC.viewControllers.lastObject;
                    AboutViewController *aboutVC = (AboutViewController *)aboutNav.viewControllers.firstObject;
                    [aboutVC.profileTableView reloadData];
                }

                [self.navigationController popViewControllerAnimated:true];
            }
        } else if ([result isKindOfClass:[NSDictionary class]] && ![result[@"msg"] isKindOfClass:[NSNull class]]) {
            [SVProgressHUD showErrorWithStatus:result[@"msg"] maskType:SVProgressHUDMaskTypeBlack];
        } else {
            [SVProgressHUD showErrorWithStatus:@"未知错误" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}


- (IBAction)forgetButtonClick:(UIButton *)sender {
    [SVProgressHUD showErrorWithStatus:@"找回密码暂时不可用" maskType:SVProgressHUDMaskTypeBlack];
}

// 注册
- (IBAction)registerButtonClick:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Register" bundle:[NSBundle mainBundle]];
    UINavigationController *registerNav = [sb instantiateInitialViewController];
    ((RegisterViewController *)registerNav.viewControllers.firstObject).delegate = self;
    [self presentViewController:registerNav animated:true completion:nil];
}

- (void)registerDidSuccessWithName:(NSString *)name cellphone:(NSString *)cellphone password:(NSString *)password {
    self.label1.text = name;
    self.label2.text = cellphone;
    self.label3.text = password;
    [self.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}


@end
