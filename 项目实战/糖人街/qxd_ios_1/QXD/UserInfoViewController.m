//
//  UserInfoViewController.m
//  QXD
//
//  Created by zhujie on 平成27-11-12.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "UserInfoViewController.h"
//#import "ThierdLoadFMDBManger.h"
//#import "ThierdLoadFMDBModel.h"
#import "UMSocial.h"
#import "UserID.h"
//#import "LoadViewController.h"
//#import "UMSocialScreenShoter.h"

#import "FriendsViewController.h"
#import "CommentNavigationView.h"
#import "WithUnderLienTextFieldView.h"
#import "RegisterViewController.h"
#import "Singleton.h"


@interface UserInfoViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *changeLoad;

@property (nonatomic,strong) UITextField *telePhone;
@property(nonatomic,strong) UITextField *passWord;
@property(nonatomic,strong) UIView *totalView;
@property(nonatomic,strong) NSString *telephomeString;
@property(nonatomic,strong) NSString *yanzhangmaString;

@property(nonatomic,strong) UIButton * loadingBut;
@property(nonatomic,strong) UIButton * findPassWord;
@property(nonatomic,strong) UIButton * registerBut;

@property(nonatomic,strong) CommentNavigationView * loadNavigationView;
@property(nonatomic,strong) WithUnderLienTextFieldView * userNameView;
@property(nonatomic,strong) WithUnderLienTextFieldView * passWordView;


@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //    UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    //    imagV.image = [UIImage imageNamed:@"loadBgImg"];
    //    [self.view addSubview:imagV];
    //    [self searchDataWithLoad];
    // [self creatLeft];
    
    
    
    //页面手势  收回键盘
    UITapGestureRecognizer * tap1=[[UITapGestureRecognizer alloc] init];
    [tap1 addTarget:self action:@selector(hiddenKeyboard)];
    [self.view addGestureRecognizer:tap1];
    [self setupUI];
    
    
    //改需求后由横变竖  再次改需求不需要了
    // [self creatRight];
    // [self phoneNumberRegister];
    
}
//-(void)creatLeft{
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [button setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
//
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = left;
//    self.title = @"登录";
//}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    if ([Singleton defaultSingleton].registerIs==NO) {
        NSLog(@"没有注册成功");
    }else{
        NSLog(@"注册成功了");
        _userNameView.textField.text=[Singleton defaultSingleton].registerNum;
        _passWordView.textField.text=[Singleton defaultSingleton].registerPassWord;
    
    }
    
    
    
}
-(void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
    UserID *user = [UserID shareInState];
    NSArray *array = [user redFromUserListAllData];
    if (array.count == 0) {
        //        [self.navigationController popViewControllerAnimated:NO];
    }
}

//当没有或者点击按钮切换账号时候调用的方法 主要是登录第三方
-(void)ChangeLoadWithBtn{
    
}
#pragma mark -- 点击事件 --
//设置只能输入11位
- (void)shoujihaoTextfiled:(UITextField *)textField
{
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
}

//收回键盘
- (void)hiddenKeyboard{
    
    
    [_userNameView.textField resignFirstResponder];
    [_passWordView.textField resignFirstResponder];

    
    
}

//手机号登录
- (void)phoneNumberLoading{
    NSLog(@"手机号登陆");
    NSString * number=_userNameView.textField.text;
    NSString * passWord=_passWordView.textField.text;
    if (number.length!=11) {
        NSLog(@"输入手机号错误");
        [self PromptInformationWithMessage:@"请输入11位手机号"];
    }else{
    
        if (passWord.length==0) {
            NSLog(@"请输入密码");
            [self PromptInformationWithMessage:@"请输入密码"];

            
        }else{
            [self loadRequestWithNumber:number passWord:passWord];
        
        }
        
        
        
    }
    
    
    
    
    
    
    
}

- (void)loadRequestWithNumber:(NSString*)number passWord:(NSString*)passWord{

    NSString * registerUrl=@"http://www.qiuxinde.com/mobile/customer/login";
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    [manager POST:registerUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFormData:[number dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
        [formData appendPartWithFormData:[passWord dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSDictionary *dict = [responseObject objectForKey:@"model"];
            NSLog(@"%@",dict);
            //存储id
            UserID *user = [UserID shareInState];
            [user insertIntoUserListWith:[dict objectForKey:@"binding_num"] Birthday:nil Create_time:[dict objectForKey:@"create_time"] Head_protrait:nil Id:[dict objectForKey:@"id"] Is_binding:[dict objectForKey:@"is_binding"] Is_vip:[dict objectForKey:@"is_vip"] NickName:[dict objectForKey:@"nickName"] Sex:nil Vip_id:nil Vip_owner:[dict objectForKey:@"vip_owner"] Vip_time_limit:[dict objectForKey:@"vip_time_limit"] Vip_discount:[dict objectForKey:@"vip_discont"] LoadType:@"sj" Third_id:nil QQ_id:nil WB_id:nil WX_id:nil password:@""];
            
            //self.blockWithUser();
            [self.navigationController popViewControllerAnimated:NO];
            
            NSLog(@"登陆成功");
        }else{
            NSDictionary * model=[responseObject objectForKey:@"model"];
            NSString * message=[model objectForKey:@"message"];
            [self PromptInformationWithMessage:message];
            
            NSLog(@"登陆失败");
        }
        
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];


}

//注册用户
- (void)registerAUser{
    RegisterViewController * registerViewController=[[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerViewController animated:YES];
    
    
}

//微信登录
-(void)wxLogin{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
            
            [self.icon sd_setImageWithURL:[NSURL URLWithString:snsAccount.iconURL] placeholderImage:nil];
            self.nameLabel.text = snsAccount.userName;
            
            if (self.nameLabel.text.length > 0) {
                [self.navigationController popViewControllerAnimated:NO];
            }
            //            NSLog(@"%@",response);
            //            NSString *getder = [NSString stringWithFormat:@"%@",[[response.data objectForKey:@"sina"] objectForKey:@"gender"]];
            //            NSString *birthday = [NSString stringWithFormat:@"%@",[[response.data objectForKey:@"sina"] objectForKey:@"birthday"]];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager POST:UserLoad parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSString *userName = [NSString stringWithFormat:@"%@",snsAccount.userName];
                [formData appendPartWithFormData:[snsAccount.usid dataUsingEncoding:NSUTF8StringEncoding] name:@"wx_id"];
                [formData appendPartWithFormData:[userName dataUsingEncoding:NSUTF8StringEncoding] name:@"nickName"];
                [formData appendPartWithFormData:[snsAccount.iconURL dataUsingEncoding:NSUTF8StringEncoding] name:@"head_portrait"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                    NSLog(@"成功");
                    NSDictionary *dict = [responseObject objectForKey:@"model"];
                    
                    //存储id
                    UserID *user = [UserID shareInState];
                    //                NSLog(@"All:%@",responseObject);
                    //                NSLog(@"dict:%@",dict);
                    //                NSLog(@"name:%@",[dict objectForKey:@"nickName"]);
                    
                    [user insertIntoUserListWith:[dict objectForKey:@"binding_num"] Birthday:[dict objectForKey:@"birthday"] Create_time:[dict objectForKey:@"create_time"] Head_protrait:[dict objectForKey:@"head_portrait"] Id:[dict objectForKey:@"id"] Is_binding:[dict objectForKey:@"is_binding"] Is_vip:[dict objectForKey:@"is_vip"] NickName:[dict objectForKey:@"nickName"] Sex:[dict objectForKey:@"sex"] Vip_id:[dict objectForKey:@"vip_id"] Vip_owner:[dict objectForKey:@"vip_owner"] Vip_time_limit:[dict objectForKey:@"vip_time_limit"] Vip_discount:[dict objectForKey:@"vip_discont"]LoadType:@"wx" Third_id:snsAccount.usid QQ_id:nil WB_id:nil WX_id:snsAccount.usid  password:@""];
                    
                    if (self.nameLabel.text.length > 0) {
                        //                [self.navigationController popViewControllerAnimated:NO];
                        if ([self.VC isEqualToString:@"MineViewController"]) {
                            NSLog(@"YES");
                            self.blockWithUser();
                        }
                        if ([self.VC isEqualToString:@"ShopCar"]) {
                            NSLog(@"YES");
                            self.blockWithShopCart();
                        }
                        if ([self.VC isEqualToString:@"abcd"]) {
                            //                        [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                    }
                    FriendsViewController *friend = [[FriendsViewController alloc] init];
                    [friend creatDataSourceAgien];
                }else{
                    NSLog(@"数据格式不对");
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error: %@", error);
            }];
        }
    });
}

//微博登陆
-(void)wbLogin{
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //获取微博用户名、uid、token、等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            NSLog(@"------usid----%@",snsAccount.iconURL);
            [self.icon sd_setImageWithURL:[NSURL URLWithString:snsAccount.iconURL] placeholderImage:nil];
            self.nameLabel.text = snsAccount.userName;
            
            NSLog(@"%@",response);
            //            NSLog(@"----%@--",[[response.data objectForKey:@"sina"] objectForKey:@"gender"]);
            //            NSString *getder = [NSString stringWithFormat:@"%@",[[response.data objectForKey:@"sina"] objectForKey:@"gender"]];
            //            NSString *birthday = [NSString stringWithFormat:@"%@",[[response.data objectForKey:@"sina"] objectForKey:@"birthday"]];
            //            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            ////            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            //
            //            [manager POST:UserLoad parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //                NSString *userName = [NSString stringWithFormat:@"%@",snsAccount.userName];
            //                [formData appendPartWithFormData:[snsAccount.usid dataUsingEncoding:NSUTF8StringEncoding] name:@"wb_id"];
            //                [formData appendPartWithFormData:[userName dataUsingEncoding:NSUTF8StringEncoding] name:@"nickName"];
            //                [formData appendPartWithFormData:[snsAccount.iconURL dataUsingEncoding:NSUTF8StringEncoding] name:@"head_portrait"];
            //                [formData appendPartWithFormData:[getder dataUsingEncoding:NSUTF8StringEncoding] name:@"sex"];
            //                [formData appendPartWithFormData:[birthday dataUsingEncoding:NSUTF8StringEncoding] name:@"birthday"];
            
            
            NSLog(@"----%@--",[[response.data objectForKey:@"sina"] objectForKey:@"gender"]);
            //            NSString *getder = [NSString stringWithFormat:@"%@",[[response.data objectForKey:@"sina"] objectForKey:@"gender"]];
            //            NSString *birthday = [NSString stringWithFormat:@"%@",[[response.data objectForKey:@"sina"] objectForKey:@"birthday"]];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager POST:UserLoad parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSString *userName = [NSString stringWithFormat:@"%@",snsAccount.userName];
                [formData appendPartWithFormData:[snsAccount.usid dataUsingEncoding:NSUTF8StringEncoding] name:@"wb_id"];
                [formData appendPartWithFormData:[userName dataUsingEncoding:NSUTF8StringEncoding] name:@"nickName"];
                [formData appendPartWithFormData:[snsAccount.iconURL dataUsingEncoding:NSUTF8StringEncoding] name:@"head_portrait"];
                //                [formData appendPartWithFormData:[getder dataUsingEncoding:NSUTF8StringEncoding] name:@"sex"];
                //                [formData appendPartWithFormData:[birthday dataUsingEncoding:NSUTF8StringEncoding] name:@"birthday"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                    NSLog(@"成功");
                    
                    NSDictionary *dict = [responseObject objectForKey:@"model"];
                    
                    //存储id
                    UserID *user = [UserID shareInState];
                    //                NSLog(@"All:%@",responseObject);
                    //                NSLog(@"dict:%@",dict);
                    //                NSLog(@"name:%@",[dict objectForKey:@"nickName"]);
                    
                    [user insertIntoUserListWith:[dict objectForKey:@"binding_num"] Birthday:[dict objectForKey:@"birthday"] Create_time:[dict objectForKey:@"create_time"] Head_protrait:[dict objectForKey:@"head_portrait"] Id:[dict objectForKey:@"id"] Is_binding:[dict objectForKey:@"is_binding"] Is_vip:[dict objectForKey:@"is_vip"] NickName:[dict objectForKey:@"nickName"] Sex:[dict objectForKey:@"sex"] Vip_id:[dict objectForKey:@"vip_id"] Vip_owner:[dict objectForKey:@"vip_owner"] Vip_time_limit:[dict objectForKey:@"vip_time_limit"] Vip_discount:[dict objectForKey:@"vip_discont"]LoadType:@"wb" Third_id:snsAccount.usid QQ_id:nil WB_id:snsAccount.usid WX_id:nil password:@""];
                    
                    if (self.nameLabel.text.length > 0) {
                        [self.navigationController popViewControllerAnimated:NO];
                        if ([self.VC isEqualToString:@"MineViewController"]) {
                            NSLog(@"YES");
                            self.blockWithUser();
                        }
                        if ([self.VC isEqualToString:@"ShopCar"]) {
                            NSLog(@"YES");
                            self.blockWithShopCart();
                        }
                    }
                    FriendsViewController *friend = [[FriendsViewController alloc] init];
                    [friend creatDataSourceAgien];
                }else{
                    NSLog(@"数据格式不对");
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error: %@", error);
            }];
        }
    });
}
//qq登录
-(void)qqLogin{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            [self.icon sd_setImageWithURL:[NSURL URLWithString:snsAccount.iconURL] placeholderImage:nil];
            self.nameLabel.text = snsAccount.userName;
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSLog(@"%@",UserLoad);
            [manager POST:UserLoad parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSString *userName = [NSString stringWithFormat:@"%@",snsAccount.userName];
                NSLog(@"%@",userName);
                [formData appendPartWithFormData:[snsAccount.usid dataUsingEncoding:NSUTF8StringEncoding] name:@"qq_id"];
                [formData appendPartWithFormData:[userName dataUsingEncoding:NSUTF8StringEncoding] name:@"nickName"];
                [formData appendPartWithFormData:[snsAccount.iconURL dataUsingEncoding:NSUTF8StringEncoding] name:@"head_portrait"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                    NSLog(@"成功");
                    NSDictionary *dict = [responseObject objectForKey:@"model"];
                    
                    //存储id
                    UserID *user = [UserID shareInState];
                    //                NSLog(@"All:%@",responseObject);
                    //                NSLog(@"dict:%@",dict);
                    //                NSLog(@"name:%@",[dict objectForKey:@"nickName"]);
                    
                    [user insertIntoUserListWith:[dict objectForKey:@"binding_num"] Birthday:[dict objectForKey:@"birthday"] Create_time:[dict objectForKey:@"create_time"] Head_protrait:[dict objectForKey:@"head_portrait"] Id:[dict objectForKey:@"id"] Is_binding:[dict objectForKey:@"is_binding"] Is_vip:[dict objectForKey:@"is_vip"] NickName:[dict objectForKey:@"nickName"] Sex:[dict objectForKey:@"sex"] Vip_id:[dict objectForKey:@"vip_id"] Vip_owner:[dict objectForKey:@"vip_owner"] Vip_time_limit:[dict objectForKey:@"vip_time_limit"] Vip_discount:[dict objectForKey:@"vip_discont"] LoadType:@"qq" Third_id:snsAccount.usid QQ_id:snsAccount.usid WB_id:nil WX_id:nil password:@""];
                    
                    if (self.nameLabel.text.length > 0) {
                        //                [self.navigationController popViewControllerAnimated:NO];
                        if ([self.VC isEqualToString:@"MineViewController"]) {
                            NSLog(@"YES");
                            self.blockWithUser();
                            [self.navigationController popViewControllerAnimated:NO];
                        }
                        if ([self.VC isEqualToString:@"ShopCar"]) {
                            NSLog(@"YES");
                            self.blockWithShopCart();
                            [self.navigationController popViewControllerAnimated:NO];
                        }
                        if ([self.VC isEqualToString:@"abcd"]) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        if ([self.VC isEqualToString:@"details"]) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                    FriendsViewController *friend = [[FriendsViewController alloc] init];
                    [friend creatDataSourceAgien];
                }else{
                    NSLog(@"数据格式不对");
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error: %@", error);
            }];
        }
    });
    
}
#pragma mark -- 获取验证码按钮点击事件 ---
-(void)getPassWord{
    NSLog(@"___________________");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *senderdx = [NSString stringWithFormat:@"%@%@",SenerDX,self.telePhone.text];
    [manager POST:senderdx parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
            self.yanzhangmaString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            self.telephomeString = self.telePhone.text;
            NSLog(@"%@",self.yanzhangmaString);
        }else{
            NSLog(@"失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
}
-(void)bangDing{
    if ([self.telephomeString isEqualToString:self.telePhone.text] &&[self.yanzhangmaString isEqualToString:self.passWord.text]) {
        
    }
}

#pragma mark -- 整体UI搭建 --
-(void)creatRight{
    //手机登录
    UIView *alerV = [[UIView alloc] initWithFrame:CGRectMake(10, 70, SCREEN_W - 20, 50)];
    
    
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(alerV.frame), SCREEN_W - 20, 50)];
    
    
    UIView *passWordView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(phoneView.frame), SCREEN_W - 20, 50)];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(10, 20+CGRectGetMaxY(passWordView.frame), SCREEN_W - 20, 40)];
    //提示绑定手机
    UILabel *alerLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 5,(alerV.frame.size.width - 130), 40)];
    alerLabel.numberOfLines = 2;
    alerLabel.text  = @"为了您的帐号安全，请您及时绑定手机";
    alerLabel.font = [UIFont systemFontOfSize:16];
    alerLabel.textAlignment = NSTextAlignmentCenter;
    [alerV addSubview:alerLabel];
    //手机号
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(10, 0, phoneView.frame.size.width - 20, 1)];
    UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(10, 49, phoneView.frame.size.width - 20, 1)];
    UIView *nextLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W/4, 5, 1, 40)];
    topLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    downLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    nextLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [phoneView addSubview:topLine];
    [phoneView addSubview:downLine];
    [phoneView addSubview:nextLine];
    UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_W/4 - 20, 30)];
    num.text = @"+86";
    num.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    num.textAlignment = NSTextAlignmentCenter;
    [phoneView addSubview:num];
    //手机号码
    self.telePhone = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_W/4 +20, 10, SCREEN_W/4 *3 -50, 30)];
    
    self.telePhone.placeholder = @"请输入您的手机号";
    [phoneView addSubview:self.telePhone];
    
    //验证码
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W/3 *2 - 30 , 5, 1, 40)];
    rightLine.backgroundColor  = [UIColor colorWithWhite:0.7 alpha:1];
    UIView *lastLine = [[UIView alloc] initWithFrame:CGRectMake(10 , 49, passWordView.frame.size.width - 20, 1)];
    lastLine.backgroundColor  = [UIColor colorWithWhite:0.7 alpha:1];
    
    UIButton *getPassword = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W/3 *2 -10, 10, SCREEN_W/3 -30, 30)];
    [getPassword addTarget:self action:@selector(getPassWord) forControlEvents:UIControlEventTouchUpInside];
    UILabel *getPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, getPassword.frame.size.width, getPassword.frame.size.height)];
    
    getPasswordLabel.text = @"获取验证码";
    getPasswordLabel.textAlignment = NSTextAlignmentCenter;
    getPasswordLabel.font = [UIFont systemFontOfSize:14];
    [getPassword addSubview:getPasswordLabel];
    
    self.passWord = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_W/3 *2 - 60, 30)];
    self.passWord.placeholder = @"输入短信验证码";
    
    [passWordView addSubview:getPassword];
    [passWordView addSubview:rightLine];
    [passWordView addSubview:lastLine];
    [passWordView addSubview:self.passWord];
    
    //立即绑定按钮
    UIButton *bangDinBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, redView.frame.size.width - 200, 40)];
    [bangDinBtn setTitle:@"立即绑定" forState:UIControlStateNormal];
    [bangDinBtn addTarget:self action:@selector(bangDing) forControlEvents:UIControlEventTouchUpInside];
    bangDinBtn.backgroundColor = [UIColor orangeColor];
    [redView addSubview:bangDinBtn];
    
    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    totalView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    self.totalView = totalView;
    [self.view addSubview:totalView];
    [totalView addSubview:alerV];
    [totalView addSubview:phoneView];
    [totalView addSubview:passWordView];
    [totalView addSubview:redView];
    
    //其他登录
    
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_W - 150)/4, CGRectGetMaxY(redView.frame) + 20, (SCREEN_W - 150)/4 *2 +150, 40)];
    [self.view addSubview:leftV];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, leftV.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [leftV addSubview:lineView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftV.frame.size.width /2 - 50, 0, 100, 40)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"其他登录";
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    [leftV addSubview:label];
    
    
    UIButton *QQbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *WXbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *WBbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    QQbtn.frame = CGRectMake((SCREEN_W - 150)/4,CGRectGetMaxY(leftV.frame) +10, 50, 50);
    WXbtn.frame = CGRectMake((SCREEN_W - 150)/4 *2 +50, CGRectGetMaxY(leftV.frame) +10, 50, 50);
    WBbtn.frame = CGRectMake((SCREEN_W - 150)/4 *3 +100, CGRectGetMaxY(leftV.frame) +10, 50, 50);
    
    [QQbtn setImage:[UIImage imageNamed:@"qq.jpg"] forState:UIControlStateNormal];
    [WBbtn setImage:[UIImage imageNamed:@"wb.jpg"] forState:UIControlStateNormal];
    [WXbtn setImage:[UIImage imageNamed:@"wx.jpg"] forState:UIControlStateNormal];
    [QQbtn setImage:[UIImage imageNamed:@"qq.jpg"] forState:UIControlStateHighlighted];
    [WBbtn setImage:[UIImage imageNamed:@"wb.jpg"] forState:UIControlStateHighlighted];
    [WXbtn setImage:[UIImage imageNamed:@"wx.jpg"] forState:UIControlStateHighlighted];
    
    [QQbtn addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
    [WBbtn addTarget:self action:@selector(wbLogin) forControlEvents:UIControlEventTouchUpInside];
    [WXbtn addTarget:self action:@selector(wxLogin) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:QQbtn];
    [self.view addSubview:WBbtn];
    [self.view addSubview:WXbtn];
    
    self.telePhone.delegate = self;
    self.passWord.delegate = self;
}

#pragma mark -- 整体UI --
-(void)setupUI{
    //  [self.changeLoad addTarget:self action:@selector(ChangeLoadWithBtn) forControlEvents:UIControlEventTouchUpInside];
    //    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,30, 50, 50)];
    //    [backBtn setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    //    [backBtn addTarget:self action:@selector(backWithBtn) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:backBtn];
    
    
    _loadNavigationView=[[CommentNavigationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64) withName:@"登录"];
    _loadNavigationView.backgroundColor=[UIColor whiteColor];
    [_loadNavigationView.cancellBut addTarget:self action:@selector(cancell) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_loadNavigationView];
    
    
    _userNameView=[[WithUnderLienTextFieldView alloc] initWithFrame:CGRectMake(38*PROPORTION_WIDTH, 38*PROPORTION_WIDTH+64, WIDTH-76*PROPORTION_WIDTH, 35*PROPORTION_WIDTH) withPlaceholder:@"请输入您的手机号"];
    _userNameView.textField.keyboardType=UIKeyboardTypeNumberPad;
    [_userNameView.textField addTarget:self action:@selector(shoujihaoTextfiled:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_userNameView];
    
    _passWordView=[[WithUnderLienTextFieldView alloc] initWithFrame:CGRectMake(38*PROPORTION_WIDTH, 106*PROPORTION_WIDTH+64, WIDTH-76*PROPORTION_WIDTH, 35*PROPORTION_WIDTH) withPlaceholder:@"输入密码"];
    _passWordView.textField.secureTextEntry=YES;//密码以圆点显示
    
    [self.view addSubview:_passWordView];
    
    self.loadingBut=[[UIButton alloc] initWithFrame:CGRectMake(50*PROPORTION_WIDTH, 118*PROPORTION_WIDTH+64+60*PROPORTION_WIDTH, WIDTH-100*PROPORTION_WIDTH, 55*PROPORTION_WIDTH)];
    _loadingBut.titleLabel.font=[UIFont systemFontOfSize:20*PROPORTION_WIDTH];
    [_loadingBut setTitle:@"登录" forState:0];
    [_loadingBut setTitleColor:[self colorWithHexString:@"#FFFFFF"] forState:0];
    _loadingBut.backgroundColor=[self colorWithHexString:@"#FD681F"];
    [_loadingBut addTarget:self action:@selector(phoneNumberLoading) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loadingBut];
    
    //  -- 放开两段注释找回密码 --
//    self.findPassWord=[[UIButton alloc] initWithFrame:CGRectMake(90*PROPORTION_WIDTH, 253*PROPORTION_WIDTH+64+30*PROPORTION_WIDTH, 80*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
//    _findPassWord.titleLabel.font=[UIFont systemFontOfSize:17*PROPORTION_WIDTH];
//    [_findPassWord setTitle:@"忘记密码" forState:0];
//    [_findPassWord setTitleColor:[self colorWithHexString:@"#555555"] forState:0];
//    [self.view addSubview:_findPassWord];

    
//    self.registerBut=[[UIButton alloc] initWithFrame:CGRectMake(WIDTH-170*PROPORTION_WIDTH, 253*PROPORTION_WIDTH+64+30*PROPORTION_WIDTH, 80*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
//    _registerBut.titleLabel.font=[UIFont systemFontOfSize:17*PROPORTION_WIDTH];
//    [_registerBut setTitle:@"快速注册" forState:0];
//    [_registerBut setTitleColor:[self colorWithHexString:@"#555555"] forState:0];
//    [_registerBut addTarget:self action:@selector(registerAUser) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_registerBut];
    
    //  -- 不用找回密码 --
    self.registerBut=[[UIButton alloc] initWithFrame:CGRectMake((WIDTH-80*PROPORTION_WIDTH)/2, 253*PROPORTION_WIDTH+64+10*PROPORTION_WIDTH, 80*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    _registerBut.titleLabel.font=[UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    [_registerBut setTitle:@"快速注册" forState:0];
    [_registerBut setTitleColor:[self colorWithHexString:@"#999999"] forState:0];
    [_registerBut addTarget:self action:@selector(registerAUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBut];
    
    
    UIView * leftLienView=[[UIView alloc] initWithFrame:CGRectMake(50*PROPORTION_WIDTH, 335*PROPORTION_WIDTH+64, (WIDTH-220*PROPORTION_WIDTH)/2-10*PROPORTION_WIDTH, 0.5)];
    leftLienView.backgroundColor=[self colorWithHexString:@"#DDDDDD"];
    UILabel * titleLabel=[[UILabel alloc] initWithFrame:CGRectMake((WIDTH-120*PROPORTION_WIDTH)/2, 320*PROPORTION_WIDTH+64, 120*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    titleLabel.textAlignment=1;
    titleLabel.font=[UIFont systemFontOfSize:16*PROPORTION_WIDTH];
    titleLabel.text=@"用社交账号登录";
    titleLabel.textColor=[self colorWithHexString:@"999999"];
    UIView * rightLienView=[[UIView alloc] initWithFrame:CGRectMake(WIDTH-50*PROPORTION_WIDTH-((WIDTH-220*PROPORTION_WIDTH)/2-10*PROPORTION_WIDTH), 335*PROPORTION_WIDTH+64, (WIDTH-220*PROPORTION_WIDTH)/2-10*PROPORTION_WIDTH, 0.5)];
    rightLienView.backgroundColor=[self colorWithHexString:@"#DDDDDD"];
    [self.view addSubview:titleLabel];
    [self.view addSubview:rightLienView];
    [self.view addSubview:leftLienView];
    
    
    
    
    
    
//    UIButton *qqViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,350*PROPORTION_WIDTH,50, 50)];
//    qqViewBtn.backgroundColor=[UIColor redColor];
//    
//    UIButton *wbViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,28*PROPORTION_WIDTH+CGRectGetMaxY(qqViewBtn.frame) , SCREEN_W, 25*PROPORTION_WIDTH)];
//    UIButton *wxViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,28*PROPORTION_WIDTH+CGRectGetMaxY(wbViewBtn.frame) , SCREEN_W, 25*PROPORTION_WIDTH)];
//    
    UIImageView *qqBtn = [[UIImageView alloc] initWithFrame:CGRectMake(50*PROPORTION_WIDTH,380*PROPORTION_WIDTH+64 , 50*PROPORTION_WIDTH, 50*PROPORTION_WIDTH)];
    qqBtn.userInteractionEnabled=YES;
    UITapGestureRecognizer * gestQQ=[[UITapGestureRecognizer alloc] init];
    [gestQQ addTarget:self action:@selector(qqLogin)];
    [qqBtn addGestureRecognizer:gestQQ];
    
    
    UIImageView *wbBtn = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH-50*PROPORTION_WIDTH)/2,380*PROPORTION_WIDTH+64 , 50*PROPORTION_WIDTH, 50*PROPORTION_WIDTH)];
    wbBtn.userInteractionEnabled=YES;
    UITapGestureRecognizer * gestWB=[[UITapGestureRecognizer alloc] init];
    [gestWB addTarget:self action:@selector(wbLogin)];
    [wbBtn addGestureRecognizer:gestWB];
    
    
    UIImageView *wxBtn = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-100*PROPORTION_WIDTH,380*PROPORTION_WIDTH+64, 50*PROPORTION_WIDTH, 50*PROPORTION_WIDTH)];
    wxBtn.userInteractionEnabled=YES;
    UITapGestureRecognizer * gestWX=[[UITapGestureRecognizer alloc] init];
    [gestWX addTarget:self action:@selector(wxLogin)];
    [wxBtn addGestureRecognizer:gestWX];
    
//
    [qqBtn setImage:[UIImage imageNamed:@"iconfont-qq"]];
    [wbBtn setImage:[UIImage imageNamed:@"iconfont-wb"]];
    [wxBtn setImage:[UIImage imageNamed:@"iconfont-wx"]];

    [self.view addSubview:qqBtn];
    [self.view addSubview:wbBtn];
    [self.view addSubview:wxBtn];

    
    UILabel *qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(50*PROPORTION_WIDTH, 430*PROPORTION_WIDTH+64, 50*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    qqLabel.textAlignment=1;
    qqLabel.font=[UIFont systemFontOfSize:16*PROPORTION_WIDTH];
    qqLabel.text=@"QQ";
    
    UILabel *wbLabel = [[UILabel alloc] initWithFrame:CGRectMake((WIDTH-50*PROPORTION_WIDTH)/2, 430*PROPORTION_WIDTH+64, 50*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    wbLabel.text=@"微博";
    wbLabel.font=[UIFont systemFontOfSize:16*PROPORTION_WIDTH];
    wbLabel.textAlignment=1;
    
    UILabel *wxLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-100*PROPORTION_WIDTH, 430*PROPORTION_WIDTH+64, 50*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    wxLabel.text=@"微信";
    wxLabel.textAlignment=1;
    wxLabel.font=[UIFont systemFontOfSize:16*PROPORTION_WIDTH];
    wxLabel.textColor=wbLabel.textColor=qqLabel.textColor=[self colorWithHexString:@"#CCCCCC"];
    
    [self.view addSubview:qqLabel];
    [self.view addSubview:wbLabel];
    [self.view addSubview:wxLabel];
    
    
    
    
//    qqLabel.text = @"使用QQ帐号登录";
//    wxLabel.text = @"使用微信账号登录";
//    wbLabel.text = @"使用微博账号登录";
//    qqLabel.font = [UIFont systemFontOfSize:14];
//    wxLabel.font = [UIFont systemFontOfSize:14];
//    wbLabel.font = [UIFont systemFontOfSize:14];
//    qqLabel.textColor = [self colorWithHexString:@"#555555"];
//    wbLabel.textColor = [self colorWithHexString:@"#555555"];
//    wxLabel.textColor = [self colorWithHexString:@"#555555"];
//    //    qqLabel.alpha = wbLabel.alpha = wxLabel.alpha = 0.75;
//    [qqViewBtn addSubview:qqLabel];
//    [wxViewBtn addSubview:wxLabel];
//    [wbViewBtn addSubview:wbLabel];
//    
//    [qqViewBtn addSubview:qqBtn];
//    [wbViewBtn addSubview:wbBtn];
//    [wxViewBtn addSubview:wxBtn];
//    
//
//    //    [qqBtn addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
//    //    [wbBtn addTarget:self action:@selector(wbLogin) forControlEvents:UIControlEventTouchUpInside];
//    //    [wxBtn addTarget:self action:@selector(wxLogin) forControlEvents:UIControlEventTouchUpInside];
//    [qqViewBtn addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
//    [wbViewBtn addTarget:self action:@selector(wbLogin) forControlEvents:UIControlEventTouchUpInside];
//    [wxViewBtn addTarget:self action:@selector(wxLogin) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:qqViewBtn];
//    [self.view addSubview:wbViewBtn];
//    [self.view addSubview:wxViewBtn];
    
}
//返回上一页
- (void)cancell{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark -- 懒加载 --
-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_W - 100)/2, 100, 100, 100)];
        
        _icon.layer.cornerRadius = 50;
        _icon.clipsToBounds = YES;
        
        //        [self.view addSubview:_icon];
        
    }
    return _icon;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_W - 100)/2, CGRectGetMaxY(self.icon.frame), 100, 30)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        //        [self.view addSubview:_nameLabel];
    }
    return _nameLabel;
}
-(UIButton *)changeLoad{
    if (!_changeLoad) {
        _changeLoad = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_W - 100)/2, CGRectGetMaxY(self.nameLabel.frame), 100, 30)];
        [_changeLoad setTitle:@"退出登录" forState:UIControlStateNormal];
        _changeLoad.layer.cornerRadius = 5;
        _changeLoad.layer.borderWidth = 1;
        _changeLoad.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [_changeLoad setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //        [self.view addSubview:_changeLoad];
    }
    return _changeLoad;
}
#pragma mark -- 提示信息 --
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
