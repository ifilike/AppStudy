//
//  ResiveLoginKeyVC.m
//  ERenYiPu
//
//  Created by babbage on 15/11/16.
//  Copyright © 2015年 babbage. All rights reserved.
//

#import "ResiveLoginKeyVC.h"
#import "UIView+CG.h"
#import "FundReferences.h"
#import "UIColor+Hex.h"
#import "SVProgressHUD.h"
#import "GJJAPI.h"
#import "UserAccountInfo.h"
@interface ResiveLoginKeyVC ()
@property(nonatomic,strong)UITextField *currentKeyField;//当前登录密码
@property(nonatomic,strong)UITextField *NewKeyField;//新的登录密码
@property(nonatomic,strong)UITextField *seckeyField;//确认新的登录密码
@end

@implementation ResiveLoginKeyVC

- (UITextField *)currentKeyField{

    if (!_currentKeyField) {
        
        _currentKeyField = [[UITextField alloc]initWithFrame:CGRectMake(k_screen_width/15, 0, k_screen_width - k_screen_width/7.5, k_screen_width/7)];
        _currentKeyField.placeholder = @"当前登录密码";
        _currentKeyField.backgroundColor = [UIColor clearColor];        _currentKeyField.font = YFont(k_screen_width/20);
    }
    return _currentKeyField;
}
- (UITextField *)NewKeyField{

    if (!_NewKeyField) {
        _NewKeyField = [[UITextField alloc]initWithFrame:CGRectMake(self.currentKeyField.x, self.currentKeyField.y, self.currentKeyField.width, self.currentKeyField.height)];
        _NewKeyField.placeholder = @"请输入新的登录密码";
        _NewKeyField.font = self.currentKeyField.font;
        _NewKeyField.backgroundColor = [UIColor clearColor];
        _NewKeyField.secureTextEntry = YES;
    }
    return _NewKeyField;
}

- (UITextField *)seckeyField{

    if (!_seckeyField) {
        _seckeyField = [[UITextField alloc]initWithFrame:CGRectMake(self.currentKeyField.x, self.currentKeyField.y, self.currentKeyField.width, self.currentKeyField.height)];
        _seckeyField.placeholder = @"请确认新的登录密码";
        _seckeyField.font = YFont(k_screen_width/20);
        _seckeyField.backgroundColor = [UIColor clearColor];
        _seckeyField.secureTextEntry = YES;
    }
    return _seckeyField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改登录密码";
    self.view.backgroundColor = [UIColor colorWithHexString:@"ececec"];
    [self createUI];
}

- (void)createUI{

    for (int i = 0; i<3; i++) {
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, (k_screen_width/7+k_screen_width/30)*i+64, k_screen_width, k_screen_width/7);
        [self.view addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        switch (i) {
            case 0:
                [view addSubview:self.currentKeyField];
                break;
                case 1:
                [view addSubview:self.NewKeyField];
                break;
                case 2:
                [view addSubview:self.seckeyField];
                break;
            default:
                break;
        }
    }
    //确认按钮
    UIButton *backCount = [[UIButton alloc]initWithFrame:CGRectMake(k_screen_width/14, k_screen_width/2+k_screen_width/3, k_screen_width-k_screen_width/7, k_screen_width/8-k_screen_width/100)];
    backCount.backgroundColor = BarColor;
    [backCount setTitle:@"完 成" forState:(UIControlStateNormal)];
    [backCount setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
   // [backCount setTitleColor:[UIColor colorWithHexString:@"acacac"] forState:(UIControlStateHighlighted)];
    backCount.titleLabel.font = YBFont(k_screen_width/18);
    [backCount addTarget:self action:@selector(resiveOver:) forControlEvents:(UIControlEventTouchUpInside)];
    backCount.layer.cornerRadius = k_screen_width/80;
    [self.view addSubview:backCount];
}
//完成
-(void)resiveOver:(UIButton *)sender{

    if (self.currentKeyField.text.length<1) {
        [SVProgressHUD showErrorWithStatus:@"当前登录密码不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }else if(self.NewKeyField.text.length<1){
        [SVProgressHUD showErrorWithStatus:@"新的登录密码不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }else if(![self.NewKeyField.text isEqualToString:self.seckeyField.text]){
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致，请重新输入" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    [self.view endEditing:YES];
    
    [GJJAPI passwordModification_用户姓名:[UserAccountInfo sharedUserAccountInfo].username 旧密码:self.currentKeyField.text 手机:[UserAccountInfo sharedUserAccountInfo].cellphone 新密码:self.NewKeyField.text completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]] && [result[@"ret"] isEqualToString:@"0"]) {
            [UserAccountInfo sharedUserAccountInfo].password = self.NewKeyField.text;
            BOOL success = [[UserAccountInfo sharedUserAccountInfo] archive];
            if (!success) {
                NSAssert(0, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"归档出错\"\n", self.class, NSStringFromSelector(_cmd), self);
            }
            [SVProgressHUD showSuccessWithStatus:@"修改成功" maskType:SVProgressHUDMaskTypeBlack];
            [self.navigationController popViewControllerAnimated:true];
        }
    }];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
