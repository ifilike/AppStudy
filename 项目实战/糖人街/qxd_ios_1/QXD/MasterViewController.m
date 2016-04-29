//
//  MasterViewController.m
//  QXD
//
//  Created by zhujie on 平成28-01-06.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import "MasterViewController.h"
#import "UserID.h"
#import "UserIDModle.h"
#import "WXPayViewController.h"

@interface MasterViewController ()<UITextViewDelegate>
@property (strong, nonatomic) UITextView *yourSelf;
@property (strong, nonatomic) UITextField *youTelephone;

@property(nonatomic,strong) UserIDModle *userIDModel;//用户信息 上传
@property (assign,nonatomic) BOOL isEdit;
//- (IBAction)Send:(id)sender;
@property(nonatomic,strong) UIView *phoneV;
@property(nonatomic,strong) UIButton *SenBtn;//申请button；
@property(nonatomic,strong) UIView *lineV;//申请button下的下划线
@property(nonatomic,assign) BOOL isSen;//判断是否可以申请
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *lin = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, 1)];
    lin.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lin];
    [self creatNav];
     self.yourSelf = [[UITextView alloc] initWithFrame:CGRectMake(17*PROPORTION_WIDTH, (64+20)*PROPORTION_WIDTH, SCREEN_W - 50*PROPORTION_WIDTH, 145*PROPORTION_WIDTH)];
    self.yourSelf.delegate = self;
    [self.view addSubview:self.yourSelf];
    [self creatTextView];
    [self creatTextField];
    [self creatBtn];
}

#pragma mark --- 创建导航栏 ---
-(void)creatNav{
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
    [left setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(abc) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UILabel *titileV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titileV.text = @"申请严选师";
    titileV.textAlignment = NSTextAlignmentCenter;
    titileV.font = [UIFont systemFontOfSize:17];
    titileV.textColor = [self colorWithHexString:@"#555555"];
    
    self.navigationItem.titleView = titileV;
}
-(void)abc{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- 创建按钮 ---
-(void)creatBtn{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W*0.5 - 50*PROPORTION_WIDTH ,CGRectGetMaxY(self.phoneV.frame) + 28*PROPORTION_WIDTH, 100*PROPORTION_WIDTH, 21*PROPORTION_WIDTH)];
    [btn setTitle:@"立即申请" forState:UIControlStateNormal];
    [btn setTitleColor:[self colorWithHexString:@"#BBBBBB"] forState:UIControlStateNormal];
    self.isSen = NO;
    btn.font = [UIFont systemFontOfSize:21*PROPORTION_WIDTH];
    self.SenBtn = btn;
    self.lineV = [[UIView alloc] initWithFrame:CGRectMake(10*PROPORTION_WIDTH, 29*PROPORTION_WIDTH, 80*PROPORTION_WIDTH, 1)];
    self.lineV.backgroundColor = [self colorWithHexString:@"#BBBBBB"];
    [self.SenBtn addSubview:self.lineV];
                                                          
    
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)click {
//    if (self.youTelephone.text.length == 0 || self.yourSelf.text.length == 0 || [self.yourSelf.text isEqualToString:@"例如：我是程序员，我喜欢XX产品"]) {
//        return;
//    }
    if (!self.isSen || [self.SenBtn.titleLabel.text isEqualToString:@"申请成功"]) {
//        [self.SenBtn setTitle:@"请完善" forState:UIControlStateNormal];
        return;
    }
    [self.SenBtn setTitle:@"申请中..." forState:UIControlStateNormal];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:Experience parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:[self.userIDModel.ID dataUsingEncoding:NSUTF8StringEncoding] name:@"customer_id"];
        [formData appendPartWithFormData:[self.yourSelf.text dataUsingEncoding:NSUTF8StringEncoding] name:@"content"];
        [formData appendPartWithFormData:[self.youTelephone.text dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"0"]) {
                [self.SenBtn setTitle:@"申请成功" forState:UIControlStateNormal];
                [self performSelector:@selector(pushTo) withObject:self afterDelay:1];
            }
        }else{
            NSLog(@"失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
}
-(void)pushTo{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 手机 ---
-(void)creatTextField{
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(17*PROPORTION_WIDTH,CGRectGetMaxY(self.yourSelf.frame) + 20*PROPORTION_WIDTH, SCREEN_W - 50*PROPORTION_WIDTH, 50*PROPORTION_WIDTH)];
    //画线条
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, phoneView.frame.size.width, 0.5)];
    line1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [phoneView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 49*PROPORTION_WIDTH, phoneView.frame.size.width, 0.5)];
    line2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [phoneView addSubview:line2];
    
    UILabel *phoneLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 18*PROPORTION_WIDTH, 70*PROPORTION_WIDTH, 14*PROPORTION_WIDTH)];
    phoneLable.text = @"联系方式:";
    phoneLable.textColor = [self colorWithHexString:@"#999999"];
    phoneLable.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];

    self.youTelephone = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLable.frame)+10*PROPORTION_WIDTH, 18*PROPORTION_WIDTH, phoneView.frame.size.width - (CGRectGetMaxX(phoneLable.frame)+10*PROPORTION_WIDTH), 14*PROPORTION_WIDTH)];
    self.youTelephone.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    self.youTelephone.placeholder = @"如手机号";
    self.youTelephone.keyboardType = UIKeyboardTypeNumberPad;
    [self.youTelephone addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    
    self.phoneV = phoneView;
    [phoneView addSubview:self.youTelephone];
    [phoneView addSubview:phoneLable];
    [self.view addSubview:phoneView];
}
-(void)textFieldChanged{
//    [self.SenBtn setTitle:@"立即申请" forState:UIControlStateNormal];
    if (self.yourSelf.text.length != 0&& ![self.yourSelf.text isEqualToString: @"自我介绍，如我是设计师"] &&self.youTelephone.text.length == 11 ) {
        [self.SenBtn setTitleColor:[self colorWithHexString:@"#FD681F"] forState:UIControlStateNormal];
        self.lineV.backgroundColor = [self colorWithHexString:@"#FD681F"];
        self.isSen = YES;
    }else{
        [self.SenBtn setTitleColor:[self colorWithHexString:@"#BBBBBB"] forState:UIControlStateNormal];
        self.lineV.backgroundColor = [self colorWithHexString:@"#BBBBBB"];
        self.isSen = NO;
    }
    
}


#pragma mark --- textView简单模仿textField placehold ---
-(void)creatTextView{
//    self.yourSelf.layer.borderWidth = 1;
//    self.yourSelf.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1] CGColor];
//    self.yourSelf.layer.cornerRadius = 4;
//    self.yourSelf.layer.masksToBounds = YES;
    [self boolOfText];
}
-(void)boolOfText{
    if (self.yourSelf.text.length == 0) {
        self.yourSelf.text = @"自我介绍，如我是设计师";
        self.yourSelf.textColor = [self colorWithHexString:@"#999999"];
        self.yourSelf.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        self.isEdit = NO;
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (!self.isEdit) {
        self.yourSelf.text = @"";
        self.isEdit = YES;
    }else {
        [self boolOfText];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    [self boolOfText];
}
-(void)textViewDidChange:(UITextView *)textView{
    self.yourSelf.textColor = [self colorWithHexString:@"#555555"];
//   [self.SenBtn setTitle:@"立即申请" forState:UIControlStateNormal];
    if (self.youTelephone.text.length == 11 &&self.yourSelf.text.length !=0) {
        [self.SenBtn setTitleColor:[self colorWithHexString:@"#FD681F"] forState:UIControlStateNormal];
        self.lineV.backgroundColor = [self colorWithHexString:@"#FD681F"];
        self.isSen = YES;
    }else{
        [self.SenBtn setTitleColor:[self colorWithHexString:@"#BBBBBB"] forState:UIControlStateNormal];
        self.lineV.backgroundColor = [self colorWithHexString:@"#BBBBBB"];
        self.isSen = NO;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---- 懒加载 ---
-(UserIDModle *)userIDModel{
    if (!_userIDModel) {
        UserID *user = [UserID shareInState];
        _userIDModel = [[user redFromUserListAllData] lastObject];
    }
    return _userIDModel;
}
#pragma mark --- 空白 ---
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    if (self.yourSelf.text.length == 0 || self.youTelephone.text.length == 0 ) {
//        
//    }else{
//        [self.SenBtn setTitleColor:[self colorWithHexString:@"#FD681F"] forState:UIControlStateNormal];
//    }
    
    [self.view endEditing:YES];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
