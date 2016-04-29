//
//  TextViewController.m
//  QXD
//
//  Created by zhujie on 平成27-11-17.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "TextViewController.h"
//#import "SaveAddress.h"
//#import "TSLocateView.h"
#import "HZAreaPickerView.h"
#import "UserID.h"
#import "UserIDModle.h"
#import "AddressModel.h"

@interface TextViewController ()<UITextFieldDelegate,HZAreaPickerDelegate, HZAreaPickerDatasource>
@property(nonatomic,strong) UIView *addressView;

@property (nonatomic, strong) UITextField *name;
@property (nonatomic, strong) UITextField *numbel;
@property (nonatomic, strong) UITextField *address;
@property (nonatomic, strong) UITextField *detailAddress;
@property (nonatomic, strong) UIButton *moRenButtonSelect;
@property (nonatomic, assign) BOOL isAllAndSave;//填入信息 是否完整
@property (nonatomic, strong) UIButton *saveBtn;//保存按钮 全局方便提醒用户
@property (nonatomic, strong) UIView *totalView;

//@property(nonatomic,strong) UITextField *areaText;
@property(nonatomic,copy) NSString *areaValue;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;



@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setupNav];
    [self creatNav];
    [self creatAddAddress];
    [self creatUI];
//    [self creatCityChose];
    [self creatDataSource];
    
}

-(void)creatCityChose{
    UIButton *button = [[UIButton alloc] initWithFrame:self.address.bounds];
    button.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    [button addTarget:self action:@selector(chose) forControlEvents:UIControlEventTouchUpInside];
    [self.address addSubview:button];
}
//-(void)chose{
//    TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"定位城市" delegate:self];
//    [locateView showInView:self.view];
//}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    TSLocateView *locateView = (TSLocateView *)actionSheet;
//    TSLocation *location = locateView.locate;
    
//    NSLog(@"state:%@ city:%@  lat:%f lon:%f",location.state, location.city, location.latitude, location.longitude);
    //You can uses location to your application.
//    self.address.text = [NSString stringWithFormat:@"%@ %@",location.state,location.city];
//    if(buttonIndex == 0) {
//        NSLog(@"Cancel");
//    }else {
//        NSLog(@"Select");
//    }
}
#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    } else{
        //   self.cityValue = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
    }
}

-(NSArray *)areaPickerData:(HZAreaPickerView *)picker
{
    NSArray *data;
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        data = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    } else{
        data = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
    }
    return data;
}



-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    if ([textField isEqual:self.address]) {
        [self.view endEditing:YES];
        [self cancelLocatePicker];
        self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict
                                                       withDelegate:self
                                                      andDatasource:self] ;
        [self.locatePicker showInView:self.view];
//       self.totalView.frame = CGRectMake(0, -60, SCREEN_W, SCREEN_H -49);
    }
    else {
//        [self cancelLocatePicker];
//        self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity
//                                                       withDelegate:self
//                                                      andDatasource:self] ;
//        [self.locatePicker showInView:self.view];
        
//        if ([textField isEqual:self.name]) {
//            self.totalView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H -49);
//        }
//        if ([textField isEqual:self.numbel]) {
//            self.totalView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H -49);
//        }
//        if ([textField isEqual:self.detailAddress]) {
//            self.totalView.frame = CGRectMake(0, - 2*60, SCREEN_W, SCREEN_H -49);
//        }
        return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self cancelLocatePicker];
//    self.totalView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H -49);
    [self.view endEditing:YES];
}

-(void)setAreaValue:(NSString *)areaValue{
    if (![_areaValue isEqualToString:areaValue]) {
        _areaValue = [areaValue copy];
        self.address.text = areaValue;
    }
}


#pragma mark --- 存在的数据写入 ---
-(void)creatDataSource{
    if (self.dataArrayModel != nil) {
        self.name.text = self.dataArrayModel.name;
        self.numbel.text = self.dataArrayModel.phone;
        self.address.text = [NSString stringWithFormat:@"%@ %@ %@",self.dataArrayModel.province,self.dataArrayModel.area,self.dataArrayModel.city];
        self.detailAddress.text = self.dataArrayModel.address;
        if ([self.dataArrayModel.selected isEqualToString:@"1"]) {
            self.moRenButtonSelect.selected = YES;
        }else{
            self.moRenButtonSelect.selected = NO;
        }
    }
}

//#pragma mark -- 创建导航栏 --
//-(void)setupNav{
//    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [left setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
//    [left addTarget:self action:@selector(disss) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
//    self.navigationItem.leftBarButtonItem = leftBtn ;
//    UILabel *lable = [[UILabel alloc] init];
//    lable.frame = CGRectMake(0, 0, 60, 30);
//    lable.text = @"添加地址";
//    self.navigationItem.titleView = lable;
//    self.view.backgroundColor = [UIColor whiteColor];
//}
#pragma mark -- 返回上一页 --
-(void)disss{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击空白退出键盘
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
//}


#pragma mark -- 收货信息 --
-(void)creatUI{
    self.name = [[UITextField alloc] initWithFrame:CGRectMake(90*PROPORTION_WIDTH, 40*PROPORTION_WIDTH, SCREEN_W - 115*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
    self.numbel = [[UITextField alloc] initWithFrame:CGRectMake( 90*PROPORTION_WIDTH,20*PROPORTION_WIDTH, SCREEN_W - 95*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
    self.address = [[UITextField alloc] initWithFrame:CGRectMake( 90*PROPORTION_WIDTH, 20*PROPORTION_WIDTH,SCREEN_W - 105*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
    self.detailAddress = [[UITextField alloc] initWithFrame:CGRectMake( 90*PROPORTION_WIDTH,25*PROPORTION_WIDTH, SCREEN_W - 105*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
//    self.name.placeholder = @"收货人姓名";
//    self.numbel.placeholder = @"手机号";
//    self.address.placeholder = @"所在区域";
//    self.detailAddress.placeholder = @"详细信息";
    
//    self.name.borderStyle = UITextBorderStyleRoundedRect;
//    self.numbel.borderStyle = UITextBorderStyleRoundedRect;
//    self.address.borderStyle = UITextBorderStyleRoundedRect;
//    self.detailAddress.borderStyle = UITextBorderStyleRoundedRect;
    
    self.name.keyboardType = UIKeyboardTypeTwitter;
    self.numbel.keyboardType = UIKeyboardTypeNumberPad;
    self.address.keyboardType = UIKeyboardTypeTwitter;
    self.detailAddress.keyboardType = UIKeyboardTypeTwitter;
    
    self.name.clearsOnBeginEditing = NO;//为yes时再次编辑清空
    self.name.autocapitalizationType = UITextAutocapitalizationTypeNone;//首字母是否大写
    self.address.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.detailAddress.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(50*PROPORTION_WIDTH, 335*PROPORTION_WIDTH, 200*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
    lable.text = @"设为默认地址";
    lable.textColor = [self colorWithHexString:@"#555555"];
    lable.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    //默认的按钮
    UIButton *moRenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    moRenBtn.backgroundColor = [UIColor yellowColor];
    moRenBtn.frame  =  CGRectMake(15*PROPORTION_WIDTH, 335*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, 20*PROPORTION_WIDTH);
    [moRenBtn setImage:[UIImage imageNamed:@"select_selected_icon"] forState:UIControlStateNormal];
    [moRenBtn setImage:[UIImage imageNamed:@"select_normal_icon"] forState:UIControlStateSelected];
    self.moRenButtonSelect = moRenBtn;
    [moRenBtn addTarget:self action:@selector(moren:) forControlEvents:UIControlEventTouchUpInside];
    //防止挡住了看不到 使用代理让页面整体上移动
    self.totalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 49)];
    
    [self.totalView addSubview:moRenBtn];
    [self.totalView addSubview:lable];
    
    
    //改需求
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 64*PROPORTION_WIDTH, SCREEN_W, 75*PROPORTION_WIDTH)];
    [nameView addSubview:self.name];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 40*PROPORTION_WIDTH, 85*PROPORTION_WIDTH, 15*PROPORTION_WIDTH)];
    nameLabel.text = @"收货人：";
    nameLabel.textColor = [self colorWithHexString:@"#555555"];
    nameLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    [nameView addSubview:nameLabel];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 74*PROPORTION_WIDTH, SCREEN_W - 30*PROPORTION_WIDTH, 0.5)];
    line1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [nameView addSubview:line1];
    
    
    UIView *numbelView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameView.frame), SCREEN_W, 55*PROPORTION_WIDTH)];
    [numbelView addSubview:self.numbel];
    UILabel *numbelLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, 60*PROPORTION_WIDTH, 15*PROPORTION_WIDTH)];
    numbelLabel.text = @"手机号：";
    numbelLabel.textColor = [self colorWithHexString:@"#555555"];
    numbelLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    [numbelView addSubview:numbelLabel];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 54*PROPORTION_WIDTH, SCREEN_W - 30*PROPORTION_WIDTH, 0.5)];
    line2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [numbelView addSubview:line2];
    
    
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(numbelView.frame), SCREEN_W, 55*PROPORTION_WIDTH)];
    [addressView addSubview:self.address];
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, 70*PROPORTION_WIDTH, 15*PROPORTION_WIDTH)];
    addressLabel.text = @"所在区域：";
    addressLabel.textColor = [self colorWithHexString:@"#555555"];
    addressLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    [addressView addSubview:addressLabel];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 54*PROPORTION_WIDTH, SCREEN_W - 30*PROPORTION_WIDTH, 0.5)];
    line3.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [addressView addSubview:line3];
    
    
    UIView *detailAddressView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(addressView.frame), SCREEN_W, 65*PROPORTION_WIDTH)];
    [detailAddressView addSubview:self.detailAddress];
    UILabel *detailAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 25*PROPORTION_WIDTH, 70*PROPORTION_WIDTH, 15*PROPORTION_WIDTH)];
    detailAddressLabel.text = @"详细地址：";
    detailAddressLabel.textColor = [self colorWithHexString:@"#555555"];
    detailAddressLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    [detailAddressView addSubview:detailAddressLabel];
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 64*PROPORTION_WIDTH, SCREEN_W - 30*PROPORTION_WIDTH, 0.5)];
    line4.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [detailAddressView addSubview:line4];
    
    
    [self.totalView addSubview:nameView];
    [self.totalView addSubview:numbelView];
    [self.totalView addSubview:addressView];
    [self.totalView addSubview:detailAddressView];
    
    self.name.font =self.numbel.font= self.address.font = self.detailAddress.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    self.name.textColor =self.numbel.textColor= self.address.textColor = self.detailAddress.textColor = [self colorWithHexString:@"#555555"];
    [self.view addSubview:self.totalView];
    
//    [self.view addSubview:moRenBtn];
//    [self.view addSubview:lable];
//    
//    [self.view addSubview:self.name];
//    [self.view addSubview:self.numbel];
//    [self.view addSubview:self.address];
//    [self.view addSubview:self.detailAddress];
    //是指address的代理
    self.address.delegate = self;
    self.name.delegate = self;
    self.numbel.delegate = self;
    self.detailAddress.delegate = self;
    
    [self.name addTarget:self action:@selector(isSave:) forControlEvents:UIControlEventEditingChanged];
    [self.numbel addTarget:self action:@selector(isSave:) forControlEvents:UIControlEventEditingChanged];
    [self.address addTarget:self action:@selector(isSave:) forControlEvents:UIControlEventEditingChanged];
    [self.detailAddress addTarget:self action:@selector(isSave:) forControlEvents:UIControlEventEditingChanged];

}
-(void)isSave:(UITextField *)textField{
    if (self.name.text.length != 0 && self.numbel.text.length != 0 && self.address.text.length != 0 && self.detailAddress.text.length != 0) {
        self.isAllAndSave = YES;
    }else{
        self.isAllAndSave = NO;
    }
}

//默认按钮点击事件
-(void)moren:(UIButton *)button{
    button.selected = !button.selected;
    if (self.moRenButtonSelect.selected == YES) {
         NSLog(@"--------yes");
    }else{
        NSLog(@"----------no");
    }
}

-(void)creatAddAddress{
    [self.view addSubview:self.addressView];
}

-(void)viewWillAppear:(BOOL)animated{
    //隐藏标签栏
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    //显示标签栏
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark -- 懒加载 --
-(UIView *)addressView{
    if (!_addressView) {
        _addressView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H-55*PROPORTION_WIDTH, SCREEN_W, 55*PROPORTION_WIDTH)];
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setTitle:@"保存" forState:UIControlStateNormal];
        [addBtn setTitleColor:[self colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        addBtn.font = [UIFont systemFontOfSize:20*PROPORTION_WIDTH];
        addBtn.backgroundColor = [self colorWithHexString:@"#FD681F"];
        [addBtn addTarget:self action:@selector(addSave) forControlEvents:UIControlEventTouchUpInside];
        addBtn.frame = CGRectMake(0, 0, SCREEN_W, 55*PROPORTION_WIDTH);
        self.saveBtn = addBtn;//全局button
//        [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _addressView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        [_addressView addSubview:addBtn];
    }
    return _addressView;
}
-(void)addSave{
    //保存地址
    if (self.name.text.length == 0 || !(self.numbel.text.length == 11) || self.address.text.length == 0 || self.detailAddress.text.length == 0) {
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"地址不能为空" message:@"请填写完地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [aler show];//不用弹窗的形式提醒用户
        [self.saveBtn setTitle:@"完善资料" forState:UIControlStateNormal];
        
        return;
    }
    int isMoren = 0;
    if (self.moRenButtonSelect.selected == YES) {
        isMoren = 1;
    }
//    SaveAddress *save = [SaveAddress shareInstance];
//    [save insertDataIntoSaveWithName:self.name.text PhoneNumber:self.numbel.text Address:self.address.text DetailAddress:self.detailAddress.text WithMoren:[NSString stringWithFormat:@"%d",isMoren]];
//    [save selectAllDataFromSave];
    
    UserID *user = [UserID shareInState];
    NSArray *userArray = [user redFromUserListAllData];
    UserIDModle *userString = [userArray lastObject];
    NSString *moren = [NSString stringWithFormat:@"%d",isMoren];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (self.dataArrayModel != nil) {
        [manager POST:AddressChange parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFormData:[userString.ID dataUsingEncoding:NSUTF8StringEncoding] name:@"customer_id"];
            [formData appendPartWithFormData:[self.dataArrayModel.selfId dataUsingEncoding:NSUTF8StringEncoding] name:@"sh_id"];
            [formData appendPartWithFormData:[self.name.text dataUsingEncoding:NSUTF8StringEncoding] name:@"sh_name"];
            [formData appendPartWithFormData:[self.numbel.text dataUsingEncoding:NSUTF8StringEncoding] name:@"sh_phone"];
            [formData appendPartWithFormData:[self.address.text dataUsingEncoding:NSUTF8StringEncoding] name:@"sh_shengshiqu"];
            [formData appendPartWithFormData:[self.detailAddress.text dataUsingEncoding:NSUTF8StringEncoding] name:@"sh_dizhi"];
            [formData appendPartWithFormData:[moren dataUsingEncoding:NSUTF8StringEncoding] name:@"is_default"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                NSLog(@"成功");
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSLog(@"失败");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
        return;
    }
    [manager POST:[NSString stringWithFormat:@"%@",AddressSaveList] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:[userString.ID dataUsingEncoding:NSUTF8StringEncoding] name:@"sh_id"];
        [formData appendPartWithFormData:[self.name.text dataUsingEncoding:NSUTF8StringEncoding] name:@"sh_name"];
        [formData appendPartWithFormData:[self.numbel.text dataUsingEncoding:NSUTF8StringEncoding] name:@"sh_phone"];
        [formData appendPartWithFormData:[self.address.text dataUsingEncoding:NSUTF8StringEncoding] name:@"sh_shengshiqu"];
        [formData appendPartWithFormData:[self.detailAddress.text dataUsingEncoding:NSUTF8StringEncoding] name:@"sh_dizhi"];
        [formData appendPartWithFormData:[moren dataUsingEncoding:NSUTF8StringEncoding] name:@"is_default"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            NSLog(@"失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error: %@", error);
    }];

    
}
#pragma mark --- 创建导航栏 ---
-(void)creatNav{
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
    [left setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(abc) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UILabel *titileV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titileV.text = @"添加地址";
    titileV.textAlignment = NSTextAlignmentCenter;
    titileV.font = [UIFont systemFontOfSize:17];
    titileV.textColor = [self colorWithHexString:@"#555555"];
    self.navigationItem.titleView = titileV;
}
-(void)abc{
    [self.navigationController popViewControllerAnimated:YES];
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
