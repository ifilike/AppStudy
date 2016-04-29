//
//  RegisterViewController.m
//  QXD
//
//  Created by wzp on 16/2/17.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "RegisterViewController.h"
#import "CommentNavigationView.h"
#import "WithUnderLienTextFieldView.h"
#import "Singleton.h"
#import "AgreementViewController.h"

@interface RegisterViewController ()


@property(nonatomic,strong)CommentNavigationView * navigationView;
@property(nonatomic,strong) WithUnderLienTextFieldView * phoneNumberView;
@property(nonatomic,strong) WithUnderLienTextFieldView * testCodeView;
@property(nonatomic,strong) WithUnderLienTextFieldView * passWordView;
@property(nonatomic,strong) WithUnderLienTextFieldView * repeatPassWordView;

@property(nonatomic,strong) UIButton * getTestCodeBut;//获取按钮
@property(nonatomic,assign) int codeTime;         //计时60秒
@property(nonatomic,strong) NSString * testCode;//获取到的验证码
@property(nonatomic,strong) UIButton * allowAgreementBut;//同意协议按钮
@property(nonatomic,strong) UIButton * finishedBut; //完成注册按钮

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer * tap1=[[UITapGestureRecognizer alloc] init];
    [tap1 addTarget:self action:@selector(hiddenKeyboard)];
    [self.view addGestureRecognizer:tap1];
    
    
    
    [self setUpUI];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    self.tabBarController.tabBar.hidden=NO;
}
#pragma mark -- 界面 --
- (void)setUpUI{

    self.view.backgroundColor=[UIColor whiteColor];
    //导航栏
    self.navigationView=[[CommentNavigationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64) withName:@"手机号注册"];
    _navigationView.backgroundColor=[UIColor whiteColor];
    [_navigationView.cancellBut addTarget:self action:@selector(goBackToLastViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navigationView];
    
    //输入手机号
    self.phoneNumberView=[[WithUnderLienTextFieldView alloc] initWithFrame:CGRectMake(38*PROPORTION_WIDTH, 38*PROPORTION_WIDTH+64, WIDTH-76*PROPORTION_WIDTH, 35*PROPORTION_WIDTH) withPlaceholder:@"请输入您的手机号"];
    _phoneNumberView.textField.keyboardType=UIKeyboardTypeNumberPad;
    
    //设置只能输入11位
    [_phoneNumberView.textField addTarget:self action:@selector(shoujihaoTextfiled:) forControlEvents:UIControlEventEditingChanged];

    [self.view addSubview:_phoneNumberView];
    
    //输入验证码
    self.testCodeView=[[WithUnderLienTextFieldView alloc] initWithFrame:CGRectMake(38*PROPORTION_WIDTH, 106*PROPORTION_WIDTH+64, WIDTH-76*PROPORTION_WIDTH, 35*PROPORTION_WIDTH) withPlaceholder:@"输入短信验证码"];
    _testCodeView.textField.keyboardType=UIKeyboardTypeNumberPad;

    [self.view addSubview:_testCodeView];
    
    //获取验证码按钮
    self.getTestCodeBut=[[UIButton alloc] initWithFrame:CGRectMake(WIDTH-148*PROPORTION_WIDTH, 106*PROPORTION_WIDTH+64, 110*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    [_getTestCodeBut addTarget:self action:@selector(gettestCode) forControlEvents:UIControlEventTouchUpInside];
    _getTestCodeBut.titleLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    _getTestCodeBut.layer.borderWidth=1;
    _getTestCodeBut.layer.cornerRadius=5;
    _getTestCodeBut.tag=8;
    _getTestCodeBut.layer.borderColor=[self colorWithHexString:@"#FD681F"].CGColor;
    [_getTestCodeBut setTitle:@"获取验证码" forState:0];
    [_getTestCodeBut setTitleColor:[self colorWithHexString:@"#FD681F"] forState:0];
    [self.view addSubview:_getTestCodeBut];

    //输入密码
    self.passWordView=[[WithUnderLienTextFieldView alloc] initWithFrame:CGRectMake(38*PROPORTION_WIDTH, 156*PROPORTION_WIDTH+64, WIDTH-76*PROPORTION_WIDTH, 35*PROPORTION_WIDTH) withPlaceholder:@"输入密码"];
    _passWordView.textField.secureTextEntry=YES;//密码以圆点显示

    [self.view addSubview:_passWordView];
    
    //再次输入密码
    self.repeatPassWordView=[[WithUnderLienTextFieldView alloc] initWithFrame:CGRectMake(38*PROPORTION_WIDTH, 206*PROPORTION_WIDTH+64, WIDTH-76*PROPORTION_WIDTH, 35*PROPORTION_WIDTH) withPlaceholder:@"重复输入密码"];
    _repeatPassWordView.textField.secureTextEntry=YES;//密码以圆点显示

    [self.view addSubview:_repeatPassWordView];
    
    //是否同意注册协议按钮
    self.allowAgreementBut=[[UIButton alloc] initWithFrame:CGRectMake(30*PROPORTION_WIDTH, 246*PROPORTION_WIDTH+64, 42*PROPORTION_WIDTH, 42*PROPORTION_WIDTH)];
    _allowAgreementBut.tag=11;
    [_allowAgreementBut setImage:[UIImage imageNamed:@"select_selected_icon"] forState:0];
    [_allowAgreementBut addTarget:self action:@selector(agreeYesOrNo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_allowAgreementBut];
    
    //提示
    UILabel * allowLabel=[[UILabel alloc] initWithFrame:CGRectMake(75*PROPORTION_WIDTH, 246*PROPORTION_WIDTH+64, 110*PROPORTION_WIDTH, 42*PROPORTION_WIDTH)];
    allowLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    allowLabel.textColor=[self colorWithHexString:@"#555555"];
    allowLabel.text=@"我已阅读并接受";
    [self.view addSubview:allowLabel];
    
    //协议
    UIButton * agreenmetBut=[[UIButton alloc] initWithFrame:CGRectMake(185*PROPORTION_WIDTH, 246*PROPORTION_WIDTH+64, 130*PROPORTION_WIDTH, 42*PROPORTION_WIDTH)];
    agreenmetBut.titleLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    [agreenmetBut setTitle:@"糖人街用户注册协议" forState:0];
    [agreenmetBut addTarget:self action:@selector(toAgreementViewController) forControlEvents:UIControlEventTouchUpInside];
    [agreenmetBut setTitleColor:[self colorWithHexString:@"#FD681F"] forState:0];
    [self.view addSubview:agreenmetBut];
    
    //完成注册
    self.finishedBut=[[UIButton alloc] initWithFrame:CGRectMake(50*PROPORTION_WIDTH, 315*PROPORTION_WIDTH+64, WIDTH-100*PROPORTION_WIDTH, 55*PROPORTION_WIDTH)];
    _finishedBut.backgroundColor=[self colorWithHexString:@"#FD681F"];
    [_finishedBut setTitle:@"完成" forState:0];
    [_finishedBut setTitleColor:[self colorWithHexString:@"#FFFFFF"] forState:0];
    [_finishedBut addTarget:self action:@selector(finishedRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_finishedBut];
    
    
    
    
}
- (void)shoujihaoTextfiled:(UITextField *)textField
{
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
}
#pragma mark -- 网络请求 --
- (void)getTestCodeRequestWithNumber:(NSString*)phoneNumber{
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSString * kk=@"http://www.qiuxinde.com/mobile/index/validate";
    //参数字典
    NSDictionary * Dic=[NSDictionary dictionaryWithObject:phoneNumber forKey:@"phoneNum"];
    [manager GET:kk parameters:Dic progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString * code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            
            self.testCode=[responseObject objectForKey:@"model"];
            
            NSLog(@"获取到的验证码是:%@",_testCode);
            
            
            
            
        }else{
            NSLog(@"请求失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
}

- (void)finishedRegisterWithPhoneNumber:(NSString*)number passWord:(NSString*)passWord{
    NSString * registerUrl=@"http://www.qiuxinde.com/mobile/customer/register";
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    [manager POST:registerUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFormData:[number dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
        [formData appendPartWithFormData:[passWord dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSLog(@"注册成功");
            
            [Singleton defaultSingleton].registerNum=number;
            [Singleton defaultSingleton].registerPassWord=passWord;
            [Singleton defaultSingleton].registerIs=YES;
            [self goBackToLastViewController];
            
        }else{
            
            NSDictionary * model=[responseObject objectForKey:@"model"];
            NSString * message=[model objectForKey:@"message"];
            NSLog(@"%@",message);
            //弹窗提示信息
            [self PromptInformationWithMessage:message];
            NSLog(@"注册失败");
        }
        
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];

}

- (void)PromptInformationWithMessage:(NSString*)message{

        UIAlertController * control=[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
        [control addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"OK");
            
        }]];
    
//        [control addAction:[UIAlertAction actionWithTitle:@"不登陆" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"不登陆");
//        }]];
        [self presentViewController:control animated:YES completion:nil];


}


#pragma mark -- 点击事件 --
//隐藏键盘

- (void)hiddenKeyboard{

    
    [_phoneNumberView.textField resignFirstResponder];
    [_testCodeView.textField resignFirstResponder];
    [_passWordView.textField resignFirstResponder];
    [_repeatPassWordView.textField resignFirstResponder];


}
//返回上一页
- (void)goBackToLastViewController{

    [self.navigationController popViewControllerAnimated:YES];

}
//注册协议页面
- (void)toAgreementViewController{
    AgreementViewController * controller=[[AgreementViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];



}
//获取验证码
- (void)gettestCode{
    NSString * phoneNumber=_phoneNumberView.textField.text;
    NSLog(@"%@",phoneNumber);
    if (phoneNumber.length==11) {
        [self getTestCodeRequestWithNumber:phoneNumber];
        self.codeTime=60;
        [self calculationTime];
    }else{
        [self PromptInformationWithMessage:@"请输入正确的手机号 "];

    }
}

//循环计时
- (void)calculationTime{

    _codeTime=_codeTime-1;
    
    NSString * time=[NSString stringWithFormat:@"%d",self.codeTime];
    NSString * title=[NSString stringWithFormat:@"%@%@",time,@"秒后重新获取"];

    [_getTestCodeBut setTitle:title forState:0];
    if (_codeTime!=0) {
        [self performSelector:@selector(calculationTime) withObject:nil afterDelay:1.0];
        _getTestCodeBut.userInteractionEnabled=NO;
    }else if(_codeTime==0){
        [_getTestCodeBut setTitle:@"获取验证码" forState:0];
        _getTestCodeBut.userInteractionEnabled=YES;

    }
    
}

- (void)agreeYesOrNo{
    if (_allowAgreementBut.tag==11) {
        [_allowAgreementBut setImage:[UIImage imageNamed:@"select_normal_icon"] forState:0];
        _allowAgreementBut.tag=22;
        _finishedBut.userInteractionEnabled=NO;
    }else{
        [_allowAgreementBut setImage:[UIImage imageNamed:@"select_selected_icon"] forState:0];
        _allowAgreementBut.tag=11;
        _finishedBut.userInteractionEnabled=YES;

    }
    
    

}
//完成注册
- (void)finishedRegister{

    //手机号
    NSString * number=self.phoneNumberView.textField.text;
    //验证码
    NSString * testCode=self.testCodeView.textField.text;
    //密码
    NSString * passWord=self.passWordView.textField.text;
    //重复密码
    NSString * repeatPassWord=self.repeatPassWordView.textField.text;
    
    if (testCode==nil) {
        NSLog(@"请输入验证码");
        [self PromptInformationWithMessage:@"请输入验证码"];

    }else{
        if ([testCode isEqualToString:_testCode]) {
            NSLog(@"验证码正确");
            
            if (passWord.length==0) {
                [self PromptInformationWithMessage:@"请输入密码"];
                [_passWordView.textField becomeFirstResponder];
            }else{
                if (repeatPassWord.length==0) {
                    [self PromptInformationWithMessage:@"请再次输入密码"];
                    [_repeatPassWordView.textField becomeFirstResponder];
                }else{
                    if ([passWord isEqualToString:repeatPassWord]) {
                        NSLog(@"完成注册");
                        
                        [self finishedRegisterWithPhoneNumber:number passWord:passWord];
                        
                        
                    }else{
                        NSLog(@"两次密码输入不一致");
                        [self PromptInformationWithMessage:@"两次密码输入不一致"];
                        
                    }
                }
                
            }
            
            
        }else{
            NSLog(@"验证码输入错误");
            [self PromptInformationWithMessage:@"验证码输入错误"];
        }
    }
    
    
    
    

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
