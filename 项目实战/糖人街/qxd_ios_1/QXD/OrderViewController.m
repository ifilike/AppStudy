//
//  OrderViewController.m
//  QXD
//
//  Created by zhujie on 平成27-11-22.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderTableViewCell.h"
#import "OrderModel.h"
#import "UserID.h"
#import "UserIDModle.h"
#import "OrderDetailModel.h"
#import "MineViewController.h"
//#import "DetailViewController.h"

@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) NSString *userID;
@property(nonatomic,strong) NSDictionary *urlDictionary;
@property(nonatomic,strong) UIButton *buttonSelect;
@property(nonatomic,assign) BOOL isBolck;
@property(nonatomic,assign) BOOL isHave_update_with_jygb;//是否超时 关闭
@property(nonatomic,strong) UIView *bgView;//背景图

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
//    [self creatDataSource];
    [self creatUPIntop];
    [self creatNav];
    
}
#pragma mark --- 创建导航栏 ---
-(void)creatNav{
//    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
//    [left setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
//    [left addTarget:self action:@selector(backWithR) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
//    self.navigationItem.leftBarButtonItem = leftBtn;
//    
//    UILabel *titileV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    titileV.text = @"全部订单";
//    titileV.textAlignment = NSTextAlignmentCenter;
//    titileV.font = [UIFont systemFontOfSize:17];
//    titileV.textColor = [self colorWithHexString:@"#555555"];
//    self.navigationItem.titleView = titileV;
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    [left setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(backWithR) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, SCREEN_W - 200, 44)];
    titleLabel.text = @"我的订单";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [self colorWithHexString:@"#555555"];
    
    UIView *lineT = [[UIView alloc] initWithFrame:CGRectMake(0, 63, SCREEN_W, 0.5)];
    lineT.backgroundColor = [self colorWithHexString:@"#DDDDDD"];
//    [topView addSubview:lineT];
    
    topView.backgroundColor = [self colorWithHexString:@"#f7f7f7"];
    [topView addSubview:titleLabel];
    [topView addSubview: left];
    [self.view addSubview:topView];
}
-(void)backWithR{
        [self.navigationController popViewControllerAnimated:YES];
}

//-(void)creatDataSource{
//    NSMutableArray *hangArray1 = @[@"雅士"];
//    NSMutableArray *hangArray2 = @[@"精华"];
//    NSMutableArray *hangArray3 = @[@"精华"];
//    
//    [self.dataArray addObject:hangArray1];
//    [self.dataArray addObject:hangArray2];
//    [self.dataArray addObject:hangArray3];
//    
//}
#pragma mark -- tableViewDelegate --
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"%ld",self.dataArray.count);
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *arr = [self.dataArray objectAtIndex:section];
//    return arr.count;
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell"];
    if (!cell) {
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderTableViewCell"];
    }
    //给model 赋值 ＝＝ self.dataArray的第index.row个元素
    OrderModel *model = [self.dataArray objectAtIndex:indexPath.section];
    
//    cell.dataArry = self.dataArray;
    cell.dataArry = model.products;
    cell.DataArray = model.PRODUCTS;
    
    [cell configCellWithOrderModel:model];
    cell.VC = self;
    //物流订单号
    cell.express_id = model.express_id;
    
    [cell.detailTableView reloadData];
    
    cell.deleteWtihSelf = ^(){//删除
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:OrderDelete parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFormData:[model.ID dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                NSLog(@"成功");
            [self creatDataSource];
            }else{
                NSLog(@"失败");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];

    };
    __weak typeof(OrderTableViewCell *)selfCell = cell;
    cell.getPayMoney = ^(){//支付宝的总钱
        selfCell.payMoney = model.total_money;
        selfCell.orderId = model.ID;
    };
    cell.BlockReloadWithOutTime = ^(){
        //重新请求数据
        [self.dataArray removeAllObjects];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:OrderList parameters:self.urlDictionary progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                NSLog(@"成功");
                NSArray *arrary = [responseObject objectForKey:@"model"];
                for (NSDictionary *dic in arrary) {
                    OrderModel *modle = [[OrderModel alloc] initWithDictionary:dic];
                    
                    [self.dataArray addObject:modle];
                }
                [self.tableView reloadData];
                //刷新默一行
                if (indexPath.section == 0) {
                    [self creatDataSource];
                    return ;
                }
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];//刷新莫个section
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                NSLog(@"数据格式不对");
            }
//
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
        
    };
    cell.BlockChangeGYGB = ^(NSString *orderModle_id){
        NSDictionary *dic = @{@"status":@"jygb",@"id":orderModle_id};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:UpdateWithOrder parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                NSLog(@"成功");
            [self.tableView reloadData];
            }else{
                NSLog(@"数据格式不对");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 55*PROPORTION_WIDTH;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 14*PROPORTION_WIDTH;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *model = [[OrderModel alloc] init];
    model = [self.dataArray objectAtIndex:indexPath.section];
//    return (110+self.dataArray.count * 70);
    return (185*PROPORTION_WIDTH + model.products.count * 100*PROPORTION_WIDTH);
    //这里要获取每个self.dataArray下的数组 有几个OrderDetailModel 乘以 70 + 110；
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
#pragma mark --- 全部订单导航栏下面 不能滑动 ---
-(void)creatUPIntop{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, 40*PROPORTION_WIDTH)];
        headerView.backgroundColor = [UIColor whiteColor];
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W , 40*PROPORTION_WIDTH)];
        titleView.layer.borderWidth = 0.5;
        titleView.layer.borderColor = [[self colorWithHexString:@"#DDDDDD"] CGColor];
    
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(10*PROPORTION_WIDTH, 0, (SCREEN_W -30)/5, 40*PROPORTION_WIDTH)];
        [button1 setTitle:@"全部" forState:UIControlStateNormal];
        [button1 setTitleColor:[self colorWithHexString:@"#555555"] forState:UIControlStateNormal];
    [button1 setTitleColor:[self colorWithHexString:@"#FD681F"] forState:UIControlStateSelected];
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button1.frame), 0, (SCREEN_W -30)/5, 40*PROPORTION_WIDTH)];
        [button2 setTitle:@"待付款" forState:UIControlStateNormal];
        [button2 setTitleColor:[self colorWithHexString:@"#555555"] forState:UIControlStateNormal];
        [button2 setTitleColor:[self colorWithHexString:@"#FD681F"] forState:UIControlStateSelected];
        UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button2.frame), 0, (SCREEN_W -30)/5, 40*PROPORTION_WIDTH)];
        [button3 setTitle:@"待发货" forState:UIControlStateNormal];
        [button3 setTitleColor:[self colorWithHexString:@"#555555"] forState:UIControlStateNormal];
        [button3 setTitleColor:[self colorWithHexString:@"#FD681F"] forState:UIControlStateSelected];
        UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button3.frame), 0, (SCREEN_W -30)/5, 40*PROPORTION_WIDTH)];
        [button4 setTitle:@"待收货" forState:UIControlStateNormal];
        [button4 setTitleColor:[self colorWithHexString:@"#555555"] forState:UIControlStateNormal];
        [button4 setTitleColor:[self colorWithHexString:@"#FD681F"] forState:UIControlStateSelected];
        UIButton *button5 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button4.frame), 0, (SCREEN_W -30)/5, 40*PROPORTION_WIDTH)];
        [button5 setTitle:@"待评价" forState:UIControlStateNormal];
        [button5 setTitleColor:[self colorWithHexString:@"#555555"] forState:UIControlStateNormal];
        [button5 setTitleColor:[self colorWithHexString:@"#FD681F"] forState:UIControlStateSelected];
    button1.font = button2.font = button3.font = button4.font = button5.font = [UIFont systemFontOfSize:12];
    
        
        button1.tag = 75;
        button2.tag = 76;
        button3.tag = 77;
        button4.tag = 78;
        button5.tag = 79;
        
        [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button4 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button5 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [titleView addSubview:button1];
        [titleView addSubview:button2];
        [titleView addSubview:button3];
        [titleView addSubview:button4];
        [titleView addSubview:button5];
        [headerView addSubview:titleView];
    
        self.buttonSelect = button1;
        self.buttonSelect.selected = YES;
    
    [self.view addSubview:headerView];
}


#pragma mark -- 点击订单的事件 --
-(void)buttonClick:(UIButton *)button{
    if (button.tag == 75) {
        NSLog(@"全部");
        self.urlDictionary = @{@"customer_id":self.userID,@"status":@""};//全部
        [self creatDataSource];
    }else if(button.tag == 76){
        NSLog(@"待付款");
        self.isBolck = YES;
        self.urlDictionary = @{@"customer_id":self.userID,@"status":@"dfk"};
        [self creatDataSource];
    }else if (button.tag == 77){
        NSLog(@"待发货");
        self.isBolck = YES;
        self.urlDictionary = @{@"customer_id":self.userID,@"status":@"dfh"};
        [self creatDataSource];
    }else if (button.tag == 78){
        NSLog(@"待收货");
        self.isBolck = YES;
        self.urlDictionary = @{@"customer_id":self.userID,@"status":@"dsh"};
        [self creatDataSource];
    }else{
        NSLog(@"待评价");
        self.urlDictionary = @{@"customer_id":self.userID,@"status":@"dpj"};
        [self creatDataSource];
    }
    self.buttonSelect.selected = NO;
    button.selected = !button.selected;
    self.buttonSelect = button;
}
#pragma mark --- 各种状态的订单 进入 ---
-(void)creatStatueWithString:(NSString *)string{
    if ([string isEqualToString:@"待付款"]) {
        UIButton *button = [self.view viewWithTag:76];
        [self buttonClick:button];
    }else if([string isEqualToString:@"待发货"]){
        UIButton *button = [self.view viewWithTag:77];
        [self buttonClick:button];
    }else if([string isEqualToString:@"待收货"]){
        UIButton *button = [self.view viewWithTag:78];
        [self buttonClick:button];
    }
}

#pragma mark -- 懒加载 --
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_W, SCREEN_H +5) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [self colorWithHexString:@"#f7f7f7"];
    }
    return _tableView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H /2 - 100*PROPORTION_WIDTH, SCREEN_W, 30*PROPORTION_WIDTH)];
        UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 30*PROPORTION_WIDTH)];
        bgLabel.text = @"你还没有订单";
        bgLabel.textAlignment = NSTextAlignmentCenter;
        bgLabel.textColor = [self colorWithHexString:@"#999999"];
        bgLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        [_bgView addSubview:bgLabel];
    }
    return _bgView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


#pragma mark -- 隐藏标签栏 --
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    if (self.isBolck) {
        return;
    }
    self.urlDictionary = @{@"customer_id":self.userID,@"status":@""};//全部
    
    [self creatDataSource];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewDidAppear:(BOOL)animated{
    
    for (OrderModel *model in self.dataArray) {
        if ([model.status isEqualToString:@"dfk"]) {
            //获取当前时间
            double newTime = [[self getCurrentTimeWithBase] doubleValue];
            double oldTime = [[self getBaseTimeWithFormatter:model.create_time] doubleValue];
            if ((newTime - 900) >= oldTime) {
                //超时处理
                NSDictionary *dic = @{@"status":@"jygb",@"id":model.ID};
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                [manager POST:UpdateWithOrder parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                        NSLog(@"成功");
                        _isHave_update_with_jygb = YES;
                    }else{
                        NSLog(@"数据格式不对");
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error:%@",error);
                }];
                
            }
        }
    }
    if (_isHave_update_with_jygb) {
        [self creatDataSource];
    }
    
    
}

-(void)creatDataSource{
    [self.dataArray removeAllObjects];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:OrderList parameters:self.urlDictionary progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
            NSArray *array = [responseObject objectForKey:@"model"];
            NSLog(@"_____________%@",array);
            for (NSDictionary *dic in array) {
                OrderModel *modle = [[OrderModel alloc] initWithDictionary:dic];
                
                [self.dataArray addObject:modle];
            }
            if (self.dataArray.count == 0) {
                [self.tableView addSubview:self.bgView];
            }else{
                [self.bgView removeFromSuperview];
            }
            
            [self.tableView reloadData];
        }else{
            NSLog(@"数据格式不对");
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
    
}

-(NSString *)userID{
    if (!_userID) {
        UserID *user = [UserID shareInState];
        UserIDModle *userModel = [[user redFromUserListAllData] lastObject];
        _userID = userModel.ID;
    }
    return _userID;
}
    
    //获取当前时间挫
-(NSString *)getCurrentTimeWithBase{
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a = [date timeIntervalSince1970];
        NSString *timeString  = [NSString stringWithFormat:@"%f",a];
        return timeString;
    }
    //时间转时间挫
-(NSString *)getBaseTimeWithFormatter:(NSString *)string{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *d = [formatter dateFromString:string];
        
    NSString *timeSp = [NSString stringWithFormat:@"%f",[d timeIntervalSince1970]];
    return timeSp;
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
    
}
@end
