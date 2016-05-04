//
//  RegisterViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/23.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIViewController+KeyboardShowOrHide.h"
#import "FundReferences.h"
#import "GJJAPI.h"
#import "SVProgressHUD.h"
#import "MainViewController.h"

@interface RegisterViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidthCons;


@property (weak, nonatomic) IBOutlet UIButton *registerButton;



@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *gjjAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *IdentityCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *cellphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifiableCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *makeSurePasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *readButton;

@property (strong, nonatomic) NSMutableArray * textFields;

@property (weak, nonatomic) IBOutlet UIButton *protocolDetail;

@property (weak, nonatomic) IBOutlet UIButton *phoneVerify;

@end

@implementation RegisterViewController

- (NSMutableArray *)textFields {
    if (_textFields == nil) {
        _textFields = [NSMutableArray array];
    }
    return _textFields;
}


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

    self.btnWidthCons.constant = [UIScreen mainScreen].bounds.size.width * 0.75;
    self.leadingCons.constant = [UIScreen mainScreen].bounds.size.width * 0.0625;
    self.trailingCons.constant = [UIScreen mainScreen].bounds.size.width * 0.0625;
    
    self.nameTextField.delegate = self;
    self.gjjAccountTextField.delegate = self;
    self.IdentityCardTextField.delegate = self;
    self.cellphoneTextField.delegate = self;
    self.verifiableCodeTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.makeSurePasswordTextField.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self keyboardDidAppear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self keyboardDidDisappear];
}

- (IBAction)phoneVerifyClick:(UIButton *)sender {
    [SVProgressHUD showErrorWithStatus:@"暂时不可用" maskType:SVProgressHUDMaskTypeBlack];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 100005) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [SVProgressHUD showInfoWithStatus:@"6-20位字符，建议由字母、数字和符号两种以上组合" maskType:SVProgressHUDMaskTypeBlack];
        });
    }
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag < 100006) {
        UIView * v = [self.view viewWithTag:(textField.tag + 1)];
        [v becomeFirstResponder];
    } else {
        if (_readButton.selected) {
            [textField resignFirstResponder];
            [self.registerButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        } else {
            [textField resignFirstResponder];
            [self showProtocolAlertDidRead:false];
        }
    }
    return true;
}


- (IBAction)protocolButtonClick:(UIButton *)sender {
    [self showProtocolAlertDidRead:_readButton.selected];
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


- (IBAction)registerButtonClick:(UIButton *)sender {
    
    if (self.nameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (![self isChinese:self.nameTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"用户名必须为中文实名" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (self.gjjAccountTextField.text.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"请确认您的公积金账号" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (self.IdentityCardTextField.text.length != 15 && self.IdentityCardTextField.text.length != 18) {
        [SVProgressHUD showErrorWithStatus:@"请检查您的身份证号" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (self.cellphoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"您的手机号码输入错误" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
//    if (self.verifiableCodeTextField.text.length == 0) {
//        [SVProgressHUD showErrorWithStatus:@"请输入验证码" maskType:SVProgressHUDMaskTypeBlack];
//        return;
//    }
    if (!(self.passwordTextField.text.length >= 6 && self.passwordTextField.text.length <= 20)) {
        [SVProgressHUD showErrorWithStatus:@"您的密码不符合要求" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.makeSurePasswordTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不相符" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if (!_readButton.selected) {
        [self showProtocolAlertDidRead:false];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"注册中" maskType:SVProgressHUDMaskTypeBlack];
    [GJJAPI register_身份证:self.IdentityCardTextField.text 用户姓名:self.nameTextField.text 密码:self.passwordTextField.text 公积金账号:self.gjjAccountTextField.text 手机:self.cellphoneTextField.text completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            [SVProgressHUD showErrorWithStatus:@"未知错误" maskType:SVProgressHUDMaskTypeBlack];
            return;
        }
        
        if ([result isKindOfClass:[NSDictionary class]] && ![result[@"ret"] isKindOfClass:[NSNull class]] && [result[@"ret"] isEqualToString:@"0"]) {
            [self dismissViewControllerAnimated:false completion:^{
                if ([self.delegate respondsToSelector:@selector(registerDidSuccessWithName:cellphone:password:)]) {
                    [self.delegate registerDidSuccessWithName:self.nameTextField.text cellphone:self.cellphoneTextField.text password:self.passwordTextField.text];
                }
            }];
        } else if ([result isKindOfClass:[NSDictionary class]] && ![result[@"msg"] isKindOfClass:[NSNull class]]) {
            [SVProgressHUD showErrorWithStatus:result[@"msg"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}


- (IBAction)gougou:(UIButton *)sender {
    if (_protocolDetail.selected) {
        sender.selected = !sender.selected;
        return;
    }
    if (!sender.selected) {
        [self showProtocolAlertDidRead:sender.selected];
    }
}

#pragma mark - ShowProtocolAlert 显示协议内容

- (void)showProtocolAlertDidRead:(BOOL)didRead {
    if (didRead) {
        [self presentViewController:[self protocolAlertWithDidRead:didRead] animated:true completion:nil];
    } else {
        [self presentViewController:[self protocolAlertWithDidRead:didRead] animated:true completion:^{
            [self didReadProtocol];
        }];
    }
}

- (UIAlertController *)protocolAlertWithDidRead:(BOOL)didRead {
    UIAlertController * protocolAlert = [UIAlertController alertControllerWithTitle:@"网上服务条款" message:@"1.请确认遵守;\n2.请确认遵守2;\n1.请确认遵守;\n2.请确认遵守2;\n1.请确认遵守;\n2.请确认遵守2;\n1.请确认遵守;\n2.请确认遵守2;\n1.请确认遵守;\n2.请确认遵守2;\n1.请确认遵守;\n2.请确认遵守2;\n" preferredStyle:UIAlertControllerStyleAlert];
    if (!didRead) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            _readButton.selected = false;
        }];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"接受协议" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _readButton.selected = true;
        }];
        [protocolAlert addAction:cancelAction];
        [protocolAlert addAction:sureAction];
    } else {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [protocolAlert addAction:okAction];
    }
    return protocolAlert;
}

- (void)didReadProtocol {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.protocolDetail.selected = true;
    });
}



- (IBAction)goToRegisterViewController:(UIBarButtonItem *)sender {
    [self.view endEditing:true];
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
