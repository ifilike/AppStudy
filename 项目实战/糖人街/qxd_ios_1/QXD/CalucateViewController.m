 //
//  CalucateViewController.m
//  QXD
//
//  Created by zhujie on 平成27-12-07.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "CalucateViewController.h"
#import "FriendsModel.h"
#import "CalucateTableViewCell.h"
#import "UserID.h"
#import "UserIDModle.h"
#import "AddressModel.h"
#import "TextViewController.h"
#import "CouponTableViewCell.h"
#import "PayTableViewCell.h"
#import "DiscountModle.h"
#import "AddressViewController.h"
//支付宝
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "APAuthV2Info.h"
#import "OrderViewController.h"
#import "WXPayViewController.h"
#import "WXApi.h"

@interface CalucateViewController ()<UITableViewDataSource,UITableViewDelegate,WXApiDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) NSMutableArray *addressArray;
@property(nonatomic,strong) NSMutableArray *MorenAddressArray;

@property(nonatomic,strong) NSMutableArray *array2;
@property(nonatomic,strong) NSMutableArray *array3;

@property(nonatomic,strong) UIButton *selectBtnWithCoupon;
@property(nonatomic,strong) UIButton *selectBtnWithPay;

@property(nonatomic,assign) BOOL isSelectWithCoupon;

@property(nonatomic,strong) UserIDModle *userModle;//用户
@property(nonatomic,strong) NSDictionary *userDic;


@property(nonatomic,strong) NSString *litterMoney;//减少的钱数
@property(nonatomic,strong) NSString *youfeiType;//减少钱数的类型

@property(nonatomic,assign) float onceYoufei;//本来的邮费
@property(nonatomic,strong) UILabel *productMoney;//商品总价
@property(nonatomic,strong) UILabel *coupMoney;//优惠价格
@property(nonatomic,strong) UILabel *youLabel;//邮费价格
@property(nonatomic,strong) UILabel *totalLabel;//总计的钱数
@property(nonatomic,strong) NSString *payMoney;//支付的钱数
@property(nonatomic,strong) NSString *youhui;//优惠卷ID
@property(assign,nonatomic) BOOL is_Have_Address;//有没有收获地址
@property(nonatomic,strong) AddressModel *change_AddressModel;//从收获地址选择后的地址模型

@property(nonatomic,strong) NSString *orderID;//订单id

@property(nonatomic,strong) UIView *lineV1;//优惠卷下面的划线消失

@property(nonatomic,assign) NSInteger items;//纪录点击的是第几个item 然后点亮它
@property(nonatomic,strong) UIButton *payBtn;//结算按钮
@property(nonatomic,strong) UILabel *discount;//优惠劵的是否可以选择 选择还是没有优惠
@property(nonatomic,strong) NSString *isOnceAppear;//第一次出现 显示的优惠卷 以后就不用根据有无数据来判断改显示什么
@property(nonatomic,strong) NSString *saveOnceAppear;//保存优惠卷内容
@property(nonatomic,strong) NSString *pay_type;//支付方式
@end

@implementation CalucateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = -1;
    self.isOnceAppear = @"";
    self.is_Have_Address = YES;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self creatNav];
    [self creatUI];
    [self getSource];
//    [self creatDataSource];
    
}
-(void)onResp:(BaseResp *)resp {
    
    if (resp.errCode == 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"pop" object:nil];
    }else{
        NSLog(@"微信支付失败");
    }
    
}
-(void)aaaa{
    NSLog(@"_____%@",self.orderID);
    OrderViewController *ordear = [[OrderViewController alloc] init];
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController pushViewController:ordear animated:YES];
}


- (void)onReq:(BaseReq *)req {
    
}
#pragma mark --- 创建导航栏 ---
-(void)creatNav{
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    [left setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(abc) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, SCREEN_W - 200, 44)];
    
    titleLabel.text = @"确认订单";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [self colorWithHexString:@"#555555"];
    
    topView.backgroundColor = [self colorWithHexString:@"f7f7f7"];
    [topView addSubview:titleLabel];
    [topView addSubview: left];
    [self.view addSubview:topView];
}
-(void)abc{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 创建视图 ---
-(void)creatUI{
//    self.navigationItem.title = @"确认订单";
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 54*PROPORTION_WIDTH, SCREEN_W, 54*PROPORTION_WIDTH)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(170*PROPORTION_WIDTH, 0, 90*PROPORTION_WIDTH, 54*PROPORTION_WIDTH)];
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - 115*PROPORTION_WIDTH, 0, 115*PROPORTION_WIDTH,54*PROPORTION_WIDTH)];
    totalLabel.text = [NSString stringWithFormat:@"￥%.2f",self.totalMoney + self.onceYoufei];
    totalLabel.textColor = [self colorWithHexString:@"#FD681F"];
    totalLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    self.payMoney = [NSString stringWithFormat:@"%.2f",self.totalMoney + self.onceYoufei];
    self.totalLabel = totalLabel;
    payBtn.backgroundColor = [self colorWithHexString:@"#FD681F"];
//    payBtn.layer.cornerRadius = 5;
//    payBtn.layer.masksToBounds = YES;
    [payBtn setTitle:@"结算" forState:UIControlStateNormal];
    payBtn.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    [payBtn addTarget:self action:@selector(creatOrder) forControlEvents:UIControlEventTouchUpInside];
    self.payBtn = payBtn;
    
    //划线
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.5)];
    lineV.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [view addSubview:lineV];
    //添加 总计
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170*PROPORTION_WIDTH, 54*PROPORTION_WIDTH)];
    label.textColor = [self colorWithHexString:@"#555555"];
    label.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    label.text = @"总计:";
    label.textAlignment = NSTextAlignmentRight;
    [view addSubview:label];
    
    [view addSubview:totalLabel];
    [view addSubview:payBtn];
    [self.view addSubview:view];
}

#pragma mark --- 请求数据 创建数据源 ---
-(void)getSource{
//    [self.array2 removeAllObjects];
    self.array2 = [[NSMutableArray alloc] init];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSLog(@"%@",self.userDic);
    [manager GET:DiscountList parameters:self.userDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
            NSArray *array = [responseObject objectForKey:@"model"];
            if (array.count != 0) {
                DiscountModle *model = [[DiscountModle alloc] init];
                model.ID = @"0";
                model.condition_descript = @"0";
                model.coupon_descript = @"不使用优惠券";
                model.time_limt = @(365);
                model.coupon_type = @"no";
                model.deadline = @"0";
                [self.array2 addObject:model];
            }
            for (NSDictionary *dic in array) {
                DiscountModle *model = [[DiscountModle alloc] initWithDiscountDic:dic];
                [self.array2 addObject: model];
                NSLog(@"%@",model.coupon_sums);
            }
            
        self.array3 = @[@"支付宝",@"微信支付"];
//            self.array3 = @[@"支付宝"];
        
        [self.dataArray addObject:self.array1];
        [self.dataArray addObject:self.array2];
        [self.dataArray addObject:self.array3];
        [self.tableView reloadData];
        }else{
            NSLog(@"数据格式不对");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
}
#pragma mark ---- 确认支付 生成订单 ---
-(void)creatOrder{
    NSLog(@"pay_type:%@",self.pay_type);
    if (self.addressArray.count == 0) {
        TextViewController *text = [[TextViewController alloc] init];
        [self.navigationController pushViewController:text animated:YES];
    
        return;
    }
    //购物车id
    BOOL isMoren = NO;
    NSString *addressId = [[NSString alloc] init];
    for (AddressModel *model in self.addressArray) {
        if ([model.selected isEqualToString:@"0"]) {
            isMoren = YES;
            addressId = model.selfId;
        }
        if (!isMoren) {
            addressId = model.selfId;
        }
    }
    
    self.FriendModle_Customer_Id = self.FriendModle_Product_Name = self.shopCarId = nil;

    for (FriendsModel *modle in self.array1) {
        self.FriendModle_Customer_Id = modle.customer_id;
        self.FriendModle_Product_Name = modle.product_name;
        NSString *str = [NSString stringWithFormat:@"%@,",modle.ID];
        [self.shopCarId appendString:str];
    }
    NSLog(@"+++++++%@",self.pay_type);
    NSString *total_money = [NSString stringWithFormat:@"%.2f",[self.payMoney floatValue]];
    //添加订单为待付款状态
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //根据是否是购物车来判断传哪一个接口
    if (self.isBuy == NO) {
        [manager POST:AddShopping parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFormData:[self.FriendModle_Customer_Id dataUsingEncoding:NSUTF8StringEncoding] name:@"customer_id"];
            //        [formData appendPartWithFormData:[self.FriendModle_Product_Name dataUsingEncoding:NSUTF8StringEncoding] name:@"customer_nickname"];
            [formData appendPartWithFormData:[self.userModle.nickName dataUsingEncoding:NSUTF8StringEncoding] name:@"customer_nickname"];
            [formData appendPartWithFormData:[self.shopCarId dataUsingEncoding:NSUTF8StringEncoding] name:@"shopping_cart_id"];
            [formData appendPartWithFormData:[total_money dataUsingEncoding:NSUTF8StringEncoding] name:@"total_money"];
            [formData appendPartWithFormData:[addressId dataUsingEncoding:NSUTF8StringEncoding] name:@"address_id"];
            if (self.youhui != nil) {
                [formData appendPartWithFormData:[self.youhui dataUsingEncoding:NSUTF8StringEncoding] name:@"coupon_id"];
            }
            [formData appendPartWithFormData:[self.pay_type dataUsingEncoding:NSUTF8StringEncoding] name:@"pay_type"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                NSLog(@"成功");
//            NSString *stringWithOrderID = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            self.orderID = [responseObject objectForKey:@"model"];
            [self pay];
            }else{
                NSLog(@"数据格式不对");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
    }else if(self.isBuy == YES){
        [manager POST:AddOrder parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFormData:[self.FriendModle_Customer_Id dataUsingEncoding:NSUTF8StringEncoding] name:@"customer_id"];
            //        [formData appendPartWithFormData:[self.FriendModle_Product_Name dataUsingEncoding:NSUTF8StringEncoding] name:@"customer_nickname"];
            [formData appendPartWithFormData:[self.userModle.nickName dataUsingEncoding:NSUTF8StringEncoding] name:@"customer_nickname"];
            [formData appendPartWithFormData:[total_money dataUsingEncoding:NSUTF8StringEncoding] name:@"total_money"];
            [formData appendPartWithFormData:[addressId dataUsingEncoding:NSUTF8StringEncoding] name:@"address_id"];
            if (self.youhui != nil) {
                [formData appendPartWithFormData:[self.youhui dataUsingEncoding:NSUTF8StringEncoding] name:@"coupon_id"];
            }
            //产品数组
            FriendsModel *friendModle = [self.array1 firstObject];
            //产品id
            [formData appendPartWithFormData:[friendModle.product_id dataUsingEncoding:NSUTF8StringEncoding] name:@"product_id"];
            [formData appendPartWithFormData:[friendModle.product_name dataUsingEncoding:NSUTF8StringEncoding] name:@"product_name"];
            //产品第一张图
            [formData appendPartWithFormData:[friendModle.product_img dataUsingEncoding:NSUTF8StringEncoding] name:@"product_img"];
            //产品单价
            [formData appendPartWithFormData:[friendModle.product_price dataUsingEncoding:NSUTF8StringEncoding] name:@"product_price"];
            //购买数量
            [formData appendPartWithFormData:[friendModle.product_num dataUsingEncoding:NSUTF8StringEncoding] name:@"product_num"];
            //规格
            [formData appendPartWithFormData:[friendModle.product_standard dataUsingEncoding:NSUTF8StringEncoding] name:@"product_standard"];
            [formData appendPartWithFormData:[self.pay_type dataUsingEncoding:NSUTF8StringEncoding] name:@"pay_type"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                NSLog(@"成功");
//            NSString *stringWithOrderID = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            self.orderID = [responseObject objectForKey:@"model"];
            [self pay];
            }else{
                NSLog(@"失败");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
        
    }

}

#pragma mark --- viewWillApper ---
-(void)viewWillAppear:(BOOL)animated{
    self.pay_type = @"zfb";
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self.payBtn setTitle:@"结算" forState:UIControlStateNormal];
    [self.addressArray removeAllObjects];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aaaa) name:@"pop" object:nil];
}

#pragma mark --- viewWillDisMiss ---
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pop" object:nil];
}
#pragma mark --- tableView代理 ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *selfArray = [self.dataArray objectAtIndex:section];
    self.lineV1.hidden = YES;
    if (section == 1) {
        if (!self.isSelectWithCoupon) {
            self.lineV1.hidden = NO;
            return 0;
        }
    }
    NSLog(@"__________%d",selfArray.count);
    return selfArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CalucateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopCarCel"];
        if (!cell) {
            cell = [[CalucateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shopCarCel"];
        }
        FriendsModel *model = [self.array1 objectAtIndex:indexPath.row];
        [cell configCellWithShopCarModel:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不出现点击变暗效果
        return cell;
    }
    if (indexPath.section == 1) {
        CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"couponTableViewCell"];
        if (!cell) {
            cell = [[CouponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"couponTableViewCell"];
        }
        NSArray *array = [self.dataArray objectAtIndex:indexPath.section];
        DiscountModle *modle = [array objectAtIndex:indexPath.row];
        
        if (indexPath.row == self.items) {
            [cell configWithDis:modle];
        }else{
        [cell configWithDisModle:modle];
        }

        cell.SelectWithSelect = ^(UIButton *button){
            self.selectBtnWithCoupon.selected = NO;
            button.selected = YES;
            self.selectBtnWithCoupon = button;
        };
        cell.SelectBtnWithCoupon = ^(UIButton *btn){//是否点击 点击完成后计算总钱数 实现计算总钱的方法
            if (self.selectBtnWithCoupon == btn) {
                btn.selected = !btn.selected;
                if (btn.selected == NO) {
                    self.litterMoney = [NSString stringWithFormat:@"%f",0.00];
                    [self creatTodayMoney];
                    
                    self.youhui = nil;
                    return ;
                }
            }
            self.selectBtnWithCoupon.selected = NO;
            btn.selected = YES;
            self.selectBtnWithCoupon = btn;
            self.items = indexPath.row;
            [self creatTodayMoney];
        };
        cell.moneyBlock = ^(NSString *string){//减少的钱
            NSLog(@"________________%@",string);
            self.litterMoney = string;
        };
        cell.youfeiBlock = ^(NSString *strign){//减免的类型
            self.youfeiType = strign;
        };
        cell.youhuijuanBlock = ^(NSString *string){//优惠卷的id
            self.youhui = string;
            NSLog(@"_______________________%@",modle.coupon_descript);
            self.isOnceAppear = modle.coupon_descript;
            if (self.saveOnceAppear.length != 0) {
                self.isOnceAppear = self.saveOnceAppear;
            }
        };
        cell.dismisss = ^(NSString *abc){//点击时候缩回去 不让优惠卷显示出来 显示优惠卷的内容
            self.saveOnceAppear = abc;
            self.isOnceAppear = abc;
            [self down];
        };
        
        return cell;
    }else{
        PayTableViewCell *cell = [[PayTableViewCell alloc] init];
//        PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aaaaa"];
//        if (!cell) {
//            cell = [[PayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bbbb"];
//        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不出现点击变暗效果
        NSString *string = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [cell configCellWithString:string WithPayType:self.pay_type];
        if (indexPath.row == 0 && [self.pay_type isEqualToString:@"zfb"]) {
             self.selectBtnWithPay = cell.selectButton;
        }
        if (indexPath.row == 1 && [self.pay_type isEqualToString:@"wx"]) {
            self.selectBtnWithPay = cell.selectButton;
        }
        self.selectBtnWithPay.selected = YES;
        cell.SelectPay = ^(UIButton *button){
            self.selectBtnWithPay.selected = NO;
            button.selected = YES;
            self.selectBtnWithPay = button;
            if (indexPath.row == 1) {
                self.pay_type = @"wx";
            }else{
                self.pay_type = @"zfb";
            }
        };
        return cell;
   }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 130*PROPORTION_WIDTH;
    }
    return 50.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 115*PROPORTION_WIDTH)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 115*PROPORTION_WIDTH)];
        UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 25*PROPORTION_WIDTH, SCREEN_W - 40*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
        
        UILabel *nameV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70*PROPORTION_WIDTH, 17*PROPORTION_WIDTH)];
         UILabel *peopleNameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameV.frame), 0, SCREEN_W - 290*PROPORTION_WIDTH, 17*PROPORTION_WIDTH)];
        UILabel *phoneV = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(peopleNameLable.frame) + 5*PROPORTION_WIDTH, 0, 55*PROPORTION_WIDTH, 17*PROPORTION_WIDTH)];
        UILabel *telephoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneV.frame) - 10*PROPORTION_WIDTH, 0, CGRectGetMaxX(firstView.frame) - CGRectGetMaxX(phoneV.frame)-20*PROPORTION_WIDTH, 17*PROPORTION_WIDTH)];
        
        
        UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, CGRectGetMaxY(firstView.frame) + 5*PROPORTION_WIDTH, SCREEN_W  - 40*PROPORTION_WIDTH, 35*PROPORTION_WIDTH)];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, secondView.frame.size.width, secondView.frame.size.height)];
        
        UIView *backView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 100*PROPORTION_WIDTH)];
        backView.backgroundColor = [UIColor whiteColor];
        [view addSubview:backView];
        //添加label 和线条
        UIImageView *imageV  = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W - 30*PROPORTION_WIDTH, 40*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
        imageV.image = [UIImage imageNamed:@"arrow_icon"];
        [view addSubview:imageV];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 100*PROPORTION_WIDTH, SCREEN_W, 0.5)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [view addSubview:lineView];
        
        
        nameV.text = @"收货人：";
        phoneV.text = @"手机：";
        nameV.textColor = phoneV.textColor = addressLabel.textColor = [self colorWithHexString:@"#999999"];
        peopleNameLable.textColor = telephoneNumberLabel.textColor = [self colorWithHexString:@"#555555"];
        nameV.font = phoneV.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
        [firstView addSubview:nameV];
        [firstView addSubview:phoneV];
        
        UserID *user = [UserID shareInState];
        NSArray *array = [user redFromUserListAllData];
        UserIDModle *model = [array lastObject];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",AddressShowList,model.ID];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                NSLog(@"成功");
                NSArray *array = [responseObject objectForKey:@"model"];
                NSArray *rootArray = array;
                //如果没有地址 提示用户添加地址
                if (rootArray.count == 0) {
                    self.is_Have_Address = NO;
                    UILabel *tiXinLabel = [[UILabel alloc] initWithFrame:btn.bounds];
                    tiXinLabel.text = @"点击添加地址";
                    tiXinLabel.textColor = [self colorWithHexString:@"#FD681F"];
                    tiXinLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
                    tiXinLabel.backgroundColor = [UIColor whiteColor];
                    tiXinLabel.textAlignment = NSTextAlignmentCenter;
                    [btn addSubview:tiXinLabel];
                    return ;
                }
                
                //有用户地址 获取
                for (NSDictionary *dict in array) {
                    AddressModel *model = [[AddressModel alloc] initWithDict:dict];
                    [self.addressArray addObject:model];
                    if ([model.selected isEqualToString:@"0"]) {
                        [self.MorenAddressArray addObject:model];
                        AddressModel *mod = [self.MorenAddressArray lastObject];
                        peopleNameLable.text = [NSString stringWithFormat:@"%@",mod.name];
                        telephoneNumberLabel.text = mod.phone;
                        peopleNameLable.font = telephoneNumberLabel.font = [UIFont systemFontOfSize:17 *PROPORTION_WIDTH];
                        addressLabel.text = [NSString stringWithFormat:@"收货地址: %@%@%@%@",mod.province,mod.city,mod.area,mod.address ];
                        
                    }
                    if (self.MorenAddressArray.count == 0) {
                        AddressModel *modd = [self.addressArray lastObject];
                        peopleNameLable.text = [NSString stringWithFormat:@"%@",modd.name];
                        telephoneNumberLabel.text = modd.phone;
                        addressLabel.text = [NSString stringWithFormat:@"收货地址: %@%@%@%@",modd.province,modd.city,modd.area,modd.address ];
                    }
                }
                //用户是否从收获地址跳改页面 如果是 显示从收获地址选择的而不使用网络请求的数据
                if (self.change_AddressModel != nil) {
                    peopleNameLable.text = [NSString stringWithFormat:@"%@",self.change_AddressModel.name];
                    telephoneNumberLabel.text = self.change_AddressModel.phone;
                    addressLabel.text = [NSString stringWithFormat:@"收货地址: %@%@%@%@",self.change_AddressModel.province,self.change_AddressModel.city,self.change_AddressModel.area,self.change_AddressModel.address ];
                }
                
                //行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:addressLabel.text];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:5*PROPORTION_WIDTH];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [addressLabel.text length])];
                addressLabel.attributedText = attributedString;
                [addressLabel sizeToFit];
                
                [self.payBtn setTitle:@"结算" forState:UIControlStateNormal];
            }else{
                NSLog(@"数据不正确");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Failure:%@",error);
        }];
        
        telephoneNumberLabel.textAlignment = NSTextAlignmentRight;
        addressLabel.numberOfLines = 2;
        addressLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        
        [firstView addSubview:peopleNameLable];
        [firstView addSubview:telephoneNumberLabel];
        [secondView addSubview:addressLabel];
        
        [view addSubview:firstView];
        [view addSubview:secondView];
        [view addSubview:btn];
        btn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.0];
        [btn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    return view;
    }
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W , 65*PROPORTION_WIDTH)];
        UILabel *dicountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 25*PROPORTION_WIDTH, 100*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
        UILabel *dicountMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W - 200*PROPORTION_WIDTH, 25*PROPORTION_WIDTH, 150*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
        UIButton *down = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - 40*PROPORTION_WIDTH, 30*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
        
        self.discount = dicountMoneyLabel;
        if (self.isOnceAppear.length == 0) {
            if (self.array2.count != 0) {
                self.isOnceAppear = @"选择优惠券";
            }else{
                self.isOnceAppear = @"没有可用优惠券";
            }
        }
        self.discount.text = self.isOnceAppear;
        
        dicountLabel.text = @"优惠券";
        
        dicountLabel.font = dicountMoneyLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        dicountLabel.textColor = [self colorWithHexString:@"#555555"];
        dicountMoneyLabel.textColor = [self colorWithHexString:@"#FD681F"];
        dicountMoneyLabel.textAlignment = NSTextAlignmentRight;
        
        UIView *bacV = [[UIView alloc] initWithFrame:CGRectMake(0, 15*PROPORTION_WIDTH, SCREEN_W, 50*PROPORTION_WIDTH)];
        bacV.backgroundColor = [UIColor whiteColor];
        [view addSubview:bacV];
        [view addSubview:dicountLabel];
        [view addSubview:dicountMoneyLabel];
        [view addSubview:down];
        
//        down.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"arrow_icon"]];
        [down setImage:[UIImage imageNamed:@"arrow_icon_icon"] forState:UIControlStateNormal];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 50*PROPORTION_WIDTH)];
        btn.backgroundColor = [UIColor clearColor];
        [view addSubview: btn];
        [btn addTarget:self action:@selector(down) forControlEvents:UIControlEventTouchUpInside];
        [down addTarget:self action:@selector(down) forControlEvents:UIControlEventTouchUpInside];
//        view.backgroundColor = [UIColor cyanColor];
        //划线
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 15*PROPORTION_WIDTH, SCREEN_W, 0.5*PROPORTION_WIDTH)];
        lineV.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [view addSubview:lineV];
        UIView *lineV1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64.5*PROPORTION_WIDTH, SCREEN_W, 0.5*PROPORTION_WIDTH)];
        lineV1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        self.lineV1 = lineV1;
//        [view addSubview:lineV1];
        
        return view;
    }
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 65*PROPORTION_WIDTH)];
        UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 30*PROPORTION_WIDTH, SCREEN_W -20*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
        //背景色
        UIView *baV = [[UIView alloc] initWithFrame:CGRectMake(0, 15*PROPORTION_WIDTH, SCREEN_W, 50*PROPORTION_WIDTH)];
        baV.backgroundColor = [UIColor whiteColor];
        [view addSubview:baV];
        
        payLabel.text = @"支付方式";
        payLabel.textColor = [self colorWithHexString:@"#555555"];
        payLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        [view addSubview:payLabel];
        view.backgroundColor = [self colorWithHexString:@"f7f7f7"];
        //划线
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 14*PROPORTION_WIDTH, SCREEN_W, 0.5*PROPORTION_WIDTH)];
        lineV.backgroundColor = [self colorWithHexString:@"#DDDDDD"];
        [view addSubview:lineV];
        
        return view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 115*PROPORTION_WIDTH;
    }if (section == 1) {
        return 65*PROPORTION_WIDTH;
    }
    return 65*PROPORTION_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2 && self.isBuy == YES) {
        return 140*PROPORTION_WIDTH;
    }else if (section == 2 && self.isBuy == NO){
        return 80*PROPORTION_WIDTH;
    }
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView *moneyTotalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 100*PROPORTION_WIDTH)];
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 15*PROPORTION_WIDTH, SCREEN_W, 0.5)];
        UILabel *productMoney = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, SCREEN_W - 30*PROPORTION_WIDTH, 28)];
        UILabel *coupMoney = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, CGRectGetMaxY(productMoney.frame), SCREEN_W - 30*PROPORTION_WIDTH, 28)];
        UILabel *youLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH , CGRectGetMaxY(coupMoney.frame), SCREEN_W - 30*PROPORTION_WIDTH, 28)];
        
        //背景色
        UIView *bageView = [[UIView alloc] initWithFrame:CGRectMake(0, 15*PROPORTION_WIDTH, SCREEN_W, 105*PROPORTION_WIDTH)];
        bageView.backgroundColor = [UIColor whiteColor];
        [moneyTotalView addSubview:bageView];
        
        
        lineV.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        productMoney.textAlignment = NSTextAlignmentRight;
        coupMoney.textAlignment = NSTextAlignmentRight;
        youLabel.textAlignment = NSTextAlignmentRight;
        productMoney.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        coupMoney.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        youLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        productMoney.textColor = youLabel.textColor = coupMoney.textColor = [self colorWithHexString:@"FD681F"];
        
        productMoney.text = [NSString stringWithFormat:@"￥%.2f",self.totalMoney];
        coupMoney.text = @"-￥0.00";
        youLabel.text = [NSString stringWithFormat:@"+￥%.2f",self.onceYoufei];
        
        self.productMoney = productMoney;
        self.coupMoney = coupMoney;
        self.youLabel = youLabel;
        
        [moneyTotalView addSubview:lineV];
        [moneyTotalView addSubview:productMoney];
        [moneyTotalView addSubview:coupMoney];
        [moneyTotalView addSubview:youLabel];
        
        //添加 商品金额 优惠 运费
        UILabel *productMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100*PROPORTION_WIDTH, 28*PROPORTION_WIDTH)];
        UILabel *coupLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100*PROPORTION_WIDTH, 28*PROPORTION_WIDTH)];
        UILabel *yLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100*PROPORTION_WIDTH, 28*PROPORTION_WIDTH)];
        [productMoney addSubview:productMoneyLabel];
        [coupMoney addSubview:coupLabel];
        [youLabel addSubview:yLabel];
        
        productMoneyLabel.text = @"商品金额";
        coupLabel.text = @"优惠";
        yLabel.text = @"运费";
        
        productMoneyLabel.textColor = coupLabel.textColor =  yLabel.textColor = [self colorWithHexString:@"#555555"];
        productMoneyLabel.font = coupLabel.font =  yLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        
        return moneyTotalView;
    }
    return nil;
}

#pragma mark ---缩回去---
-(void)down{
    self.isSelectWithCoupon = !self.isSelectWithCoupon;
//    [self.tableView reloadData];//刷新全部
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];//刷新莫个section
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark --- 打折的钱数 ---
-(void)creatTodayMoney{
    float litter  = [self.litterMoney floatValue];
    if ([self.youfeiType isEqualToString:@"sp"]) {//商品优惠
        self.youLabel.text = [NSString stringWithFormat:@"+￥%.2f元",self.onceYoufei];
        self.coupMoney.text = [NSString stringWithFormat:@"-￥%.2f元",litter];
        self.totalLabel.text = [NSString stringWithFormat:@"￥%.2f",self.totalMoney + self.onceYoufei - litter];
        self.payMoney = [NSString stringWithFormat:@"%.2f",self.totalMoney + self.onceYoufei - litter];
    }
    if ([self.youfeiType isEqualToString:@"yf"]) {//邮费优惠后价格
        self.coupMoney.text = [NSString stringWithFormat:@"-￥0.00元"];
        if (litter > self.onceYoufei) {
            self.youLabel.text = [NSString stringWithFormat:@"+￥0.00元"];
            self.totalLabel.text = [NSString stringWithFormat:@"￥%.2f",self.totalMoney];
            self.payMoney = [NSString stringWithFormat:@"%.2f",self.totalMoney];;
        }
        else{
            self.youLabel.text = [NSString stringWithFormat:@"+￥%.2f元",(self.onceYoufei - litter)];
            self.totalLabel.text = [NSString stringWithFormat:@"￥%.2f",self.totalMoney + self.onceYoufei - litter];
            self.payMoney = [NSString stringWithFormat:@"%.2f",self.totalMoney + self.onceYoufei - litter];
        }
    }
    
    if ([self.youfeiType isEqualToString:@"no"]) {
        self.totalLabel.text = [NSString stringWithFormat:@"￥%.2f",self.totalMoney];
    }
}


#pragma mark ---- 添加收货地址 ----
-(void)addAddress{
    if (self.is_Have_Address) {
        AddressViewController *addres = [[AddressViewController alloc] init];
        addres.is_shopping = YES;
        addres.getAddressBlock = ^(AddressModel *model){
            self.change_AddressModel = model;
        };
        [self.navigationController pushViewController:addres animated:YES];
    }else{
    TextViewController *text = [[TextViewController alloc] init];
    [self.navigationController pushViewController:text animated:YES];
    }
}

#pragma mark --- 懒加载 ---
-(float)onceYoufei{
    if (!_onceYoufei) {
        _onceYoufei = 0;
    }
    return _onceYoufei;
}
-(NSMutableString *)shopCarId{
    if (!_shopCarId) {
        _shopCarId = [[NSMutableString alloc] init];
    }
    return _shopCarId;
}

-(UserIDModle *)userModle{
    if (!_userModle) {
        UserID *user = [UserID shareInState];
        _userModle = [[user redFromUserListAllData] lastObject];
    }
    return _userModle;
}
-(NSDictionary *)userDic{
    if (!_userDic) {
        _userDic = [[NSDictionary alloc] init];
        _userDic = @{@"customer_id":self.userModle.ID,@"sums":[NSString stringWithFormat:@"%.2f",self.totalMoney],@"condition":@"dd"};
    }
    return _userDic;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44, SCREEN_W, SCREEN_H -49  -40) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [self colorWithHexString:@"#f7f7f7"];
        _tableView.separatorColor = [self colorWithHexString:@"#DDDDDD"];
    }
    return _tableView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(NSMutableArray *)addressArray{
    if (!_addressArray) {
        _addressArray = [[NSMutableArray alloc] init];
    }
    return _addressArray;
}
-(NSMutableArray *)MorenAddressArray{
    if (!_MorenAddressArray) {
        _MorenAddressArray = [[NSMutableArray alloc] init];
    }
    return _MorenAddressArray;
}
#pragma mark === 支付 ===
-(void)pay{
    //[self creatOrder];//生成订单
    if ([self.pay_type isEqualToString:@"wx"]) {
        WXPayViewController *wxPay = [[WXPayViewController alloc] init];
        float price_money = [self.payMoney floatValue];
        NSString *pri = [NSString stringWithFormat:@"%.0f",price_money*100];
        NSLog(@"price_str:%@",pri);
        wxPay.price = pri;
        wxPay.order_id = self.orderID;
        [wxPay weixinChooseAct];
        
        
        return ;
    }
    
    
    NSLog(@"_________支付___________");
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    //    Product *product = [self.productList objectAtIndex:indexPath.row];
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088611922925773";
    NSString *seller = @"esok@esok.cn";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANfEOGuHDyStqzetu37gO0Lxy9ucCVpT3t7oao/oYHyeQIhI4sxu7dnTbSdsR3DKglHg+9sNbIvubxxeLPvfjrF/Lvky0sYIGBRYyQXQb+kwOq0dwqHGvqN4FP1EwI69CfQP/a2J/z4D0stF/htv4B24dxag7mxZIKLJJvwstUbnAgMBAAECgYEAtVsDhTXPP6gNqs4HM3xrszgjfiIoJlkqkjfOIclTGEu3uBVzNBvlJdq0+5bicWZ1pTay2ors+qzdjX2G1+ovN2x9ZIZyVDL0P1CqgzwEu7hCIC5I/hlcMIux+h0U93stRxeimdCcbj2hCfzewE77hP4GQ6F4llzgDtvm9X41CYkCQQDy+63bcv7huWydUOuN7ObhOTAjoAe5SxJL89UkFkMGwJYqUm2cRNAkaJ3OPBBBXEeDpBjh323L6g0pUnM6q32lAkEA41NJY+GAXVUAWnAKNJHfXEi3XopnStsPRRL6gRCqTcceWEicq6CtyHEIxJuldiG0AP2u+Fh5faWx4phXKFEkmwJAFdGt2f/ojWJ2M2Y50MPOM7lL7lcHeocYPIPHxvbMzAVtNp2yRA8V1b8jNIrGNuhPb63DojzLAj2hMu25dTJDFQJAFi24CVCk73YtlKU9uadJvX0ytryWG02IDdsuKY1wsCnvIfnjnzMMAXRVwKjW2dGr+DTH717ia4nQ8ySdzEcuZQJAf1aGvpNuRP9Sf043ymPbhBVEb2bji6ltOr9R1VpCuaojP/EAYEAanzHLvcG+kc0QAk57+7hWp3smNQu+aYt1oQ==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    
   
    

    
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = @"糖人街商品";//商品标题
    order.productDescription = @"商品描述"; //商品描述
    order.amount = [NSString stringWithFormat:@"%@",self.payMoney]; //商品价格
//    order.amount = @"0.01";
    order.notifyURL =  @"http://www.qxd.com/mobile/ali/pay"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"qxd";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSString *statue = [resultDic objectForKey:@"resultStatus"];
            if ([statue isEqualToString:@"9000"]) {
                NSDictionary *dic = @{@"status":@"dfh",@"id":self.orderID};
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                [manager POST:UpdateWithOrder parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                        NSLog(@"成功");
                        OrderViewController *ordear = [[OrderViewController alloc] init];
                        [self.navigationController popViewControllerAnimated:YES];
                        [self.navigationController pushViewController:ordear animated:YES];
                        
                        
                    }else{
                        NSLog(@"数据格式不对");
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error:%@",error);
                }];
            }
            if ([statue isEqualToString:@"6001"]) {
                OrderViewController *ordear = [[OrderViewController alloc] init];
                [self.navigationController popViewControllerAnimated:YES];
                [self.navigationController pushViewController:ordear animated:YES];
            }
            
        }];
        NSArray *array = [[UIApplication sharedApplication] windows];
        UIWindow* win=[array objectAtIndex:0];
        [win setHidden:NO];
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
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
#pragma mark   ==============产生随机订单号==============
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end