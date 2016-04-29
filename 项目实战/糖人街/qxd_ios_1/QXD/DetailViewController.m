//
//  DetailViewController.m
//  QXD
//
//  Created by zhujie on 平成27-12-25.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailModle.h"
#import "DetailOrderTableViewCell.h"
#import "AdresTableViewCell.h"
#import "BuyAllTableViewCell.h"
#import "ProductModel.h"
#import "OrderDetailTableViewCell.h"
#import "OrderDetailModel.h"
#import "OrderTableViewCell.h"
#import "UserID.h"
#import "UserIDModle.h"
#import "EvaluateViewController.h"
#import "ServiceViewController.h"
#import "ServerAfterViewController.h"
#import "TrackViewController.h"
#import "NewTrackModel.h"
#import "NewTrackTableViewCell.h"


//支付宝
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "APAuthV2Info.h"
#import "Track.h"

@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) NSString *order_statue;
@property(nonatomic,strong) UserIDModle *userModle;


//3组数据
@property(nonatomic,strong) NSMutableArray *dataArray1;
@property(nonatomic,strong) NSMutableArray *dataArray2;
@property(nonatomic,strong) NSMutableArray *dataArray3;
@property(nonatomic,strong) NSMutableArray *dataArray4;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self creatNav];
    //[self getDataSource];
}
#pragma mark ---创建导航栏---
-(void)creatNav{
//    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
//    [left setBackgroundImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
//    [left addTarget:self action:@selector(backWithaa) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
//    self.navigationItem.leftBarButtonItem = leftBtn;
//    
//    //创建导航栏
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    titleLabel.text = self.navWithStatue;
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
//    titleLabel.textColor = [self colorWithHexString:@"#555555"];
//    self.navigationItem.titleView = titleLabel;
    
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    [left setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(backWithaa) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, SCREEN_W - 200, 44)];
    titleLabel.text = @"订单详情";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [self colorWithHexString:@"#555555"];
    
    UIView *lineT = [[UIView alloc] initWithFrame:CGRectMake(0, 63, SCREEN_W, 1)];
    lineT.backgroundColor = [self colorWithHexString:@"#DDDDDD"];
    [topView addSubview:lineT];
    
    topView.backgroundColor = [self colorWithHexString:@"#f7f7f7"];
    [topView addSubview:titleLabel];
    [topView addSubview: left];
    [self.view addSubview:topView];
}
-(void)backWithaa{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 代理 ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"_______________%ld",self.dataArray4.count);
    if (section == 0 && self.dataArray4.count == 1) {
        return 2;
    }
    return 1;
}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [[self.dataArray objectAtIndex:section] count];
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"________%@",self.order_statue);
    if (indexPath.section == 0) {
        return 80*PROPORTION_WIDTH;
    }
    if (indexPath.section == 1) {
        return 110*PROPORTION_WIDTH;
    }else if([self.order_statue isEqualToString:@"dpj"]||[self.order_statue isEqualToString:@"ypj"] || [self.order_statue isEqualToString:@"jycg"]){
        return 160*PROPORTION_WIDTH;
    }
    return 110*PROPORTION_WIDTH;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15*PROPORTION_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 40*PROPORTION_WIDTH;
    }
    return 0.01*PROPORTION_WIDTH;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 40*PROPORTION_WIDTH)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 0, SCREEN_W - 30*PROPORTION_WIDTH, 40*PROPORTION_WIDTH)];
        titleLabel.text  = @"所购商品";
        titleLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        titleLabel.textColor = [self colorWithHexString:@"#555555"];
        [view addSubview:titleLabel];
        view.backgroundColor = [UIColor whiteColor];
        
        UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.5)];
        top.backgroundColor = [self colorWithHexString:@"DDDDDD"];
        [view addSubview:top];
        return view;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 &&indexPath.row == 0) {
        DetailOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aaaa"];
        if (!cell) {
            cell = [[DetailOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aaaa"];
        }
        for (NSDictionary *dic in [self.dataArray objectAtIndex:indexPath.section]) {
            NSString *address_id = [dic objectForKey:@"id"];
            NSString *addres_status = [dic objectForKey:@"status"];
            [cell configWithModle:addres_status WithID:address_id];
            
            
            //的到订单的状态 判断是否需要 售后服务
            self.order_statue = addres_status;
            //获得状态后  根据状态写出最底下的标签栏的文字是什么
            [self creatLaterView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 0&&indexPath.row == 1) {
        NewTrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newtrack"];
        if (!cell) {
            cell = [[NewTrackTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newtrack"];
        }
        NewTrackModel *model = [self.dataArray4 objectAtIndex:0];
        [cell configCellWithModle:model];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 1) {
        AdresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bbbb"];
        if (!cell) {
            cell = [[AdresTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bbbb"];
        }
        for (NSDictionary *dic in [self.dataArray objectAtIndex:indexPath.section]) {
            NSString *name = [dic objectForKey:@"name"];
            NSString *phone = [dic objectForKey:@"phone"];
            NSString *address = [NSString stringWithFormat:@"%@%@%@%@",[dic objectForKey:@"province"],[dic objectForKey:@"city"],[dic objectForKey:@"area"],[dic objectForKey:@"address"]];
            [cell configWithDictionary:name WithPhone:phone WithDetailAddress:address];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 2) {
        //        BuyAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cccc"];
        //        if (!cell) {
        //            cell = [[BuyAllTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cccc"];
        //        }
        //        for (ProductModel *model in [self.dataArray objectAtIndex:indexPath.section]) {
        //            [cell configCellWithProduct:model WithStatue:self.order_statue];
        //        }
        OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cccc"];
        if (!cell) {
            cell = [[OrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cccc"];
        }
        
        OrderDetailModel *model = self.dataArray3[indexPath.row];
        [cell configCellWithModel:model WithStatue:self.order_statue];
        
        __weak typeof (self) weakSelf = self;
        cell.getDataBlock = ^(UIButton *button){//////////申请售后的点击事件
            ProductModel *modle = [weakSelf.dataArray3 objectAtIndex:indexPath.row];
            //            NSLog(@"______%@",modle.product_id);
            //            NSLog(@"__%@",modle.product_price);
            //            NSLog(@"))))%@",modle.product_num);
            //            NSLog(@"______%@",self.ordreID);
            NSLog(@"%@",button.titleLabel.text);
            if ([button.titleLabel.text isEqualToString:@"申请售后"]) {
                ServiceViewController *service = [[ServiceViewController alloc] init];
                service.order_id = self.ordreID;
                service.product_num = modle.product_num;
                service.product_price = modle.product_price;
                service.product_id = modle.product_id;
                [self.navigationController pushViewController:service animated:YES];
            }else if([button.titleLabel.text isEqualToString:@"待审核"]){
                ServerAfterViewController *serviceAfter = [[ServerAfterViewController alloc] init];
                serviceAfter.product_id = modle.product_id;
                serviceAfter.order_id = self.ordreID;
                
                [self.navigationController pushViewController:serviceAfter animated:YES];
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderorder"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"orderorder"];
    }
    cell.textLabel.text = @"123456789123456789";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        TrackViewController *track = [[TrackViewController alloc] init];
        track.orderID = self.ordreID;
        track.express_id = self.express_id;
        [self.navigationController pushViewController:track animated:YES];
    }
}
#pragma mark --- 请求数据 ---
-(void)getDataSource{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dic = @{@"id":self.ordreID};
    [manager GET:OrderDetailList parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
            NSDictionary *dictionary = [responseObject objectForKey:@"model"];
            DetailModle *modle = [[DetailModle alloc] initWithDict:dictionary];
            
            [self.dataArray1 addObject:modle.order];
            if (modle.address != nil) {
                [self.dataArray2 addObject:modle.address];
            }
            self.dataArray3 = modle.products;
            [self.dataArray addObject:self.dataArray1];
            [self.dataArray addObject:self.dataArray2];
            [self.dataArray addObject:self.dataArray3];
            [self.tableView reloadData];
        }else{
            NSLog(@"数据格式不对");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
    
}
//根据订单号的有无 判断是否需要展示最新的物流消息
-(void)getDataSourceWithTrack{
    NSLog(@"______%@",self.express_id);
    if (self.express_id.length != 0) {
        NSDictionary *dict = @{@"number":self.express_id};
//        NSDictionary *dict = @{@"id":self.ordreID};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //OrderTrack  NewsestTrack
        [manager GET:OrderTrack parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"code"]isEqualToString:@"0"]) {
                NSDictionary *dictionary = [responseObject objectForKey:@"model"];
                NSDictionary *dic = [dictionary objectForKey:@"result"];
                NSArray *array = [dic objectForKey:@"list"];
                NSDictionary *d = [array objectAtIndex:0];
                NewTrackModel *newTrack = [[NewTrackModel alloc] initWithDict:d];
                [self.dataArray4 addObject:newTrack];
                [self.tableView reloadData];
            }
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
    }
}
#pragma mark --- 页面将要出翔 ---
-(void)viewWillAppear:(BOOL)animated{
    [self.dataArray4 removeAllObjects];
    self.tabBarController.tabBar.hidden = YES;
    [self getDataSource];
    [self getDataSourceWithTrack];
    //[self creatLaterView];
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark --- 页面将要离开 ---
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [self.dataArray removeAllObjects];
    [self.dataArray1 removeAllObjects];
    [self.dataArray2 removeAllObjects];
    [self.dataArray3 removeAllObjects];
}


#pragma mark --- 代替标签栏  ---
-(void)creatLaterView{
    NSString *stringWithStatue = [[NSString alloc] init];
    if ([self.order_statue isEqualToString:@"dfk"]) {
        stringWithStatue = @"支付";
    }
    if ([self.order_statue isEqualToString:@"dfh"]) {
        stringWithStatue = @"订单跟踪";
    }
    if ([self.order_statue isEqualToString:@"dsh"]) {
        stringWithStatue = @"确认收货";
    }
    if ([self.order_statue isEqualToString:@"dpj"]) {
        stringWithStatue = @"评价";
    }
    if ([self.order_statue isEqualToString:@"ypj"]) {
        stringWithStatue = @"已评价";
    }
    if ([self.order_statue isEqualToString:@"jygb"]) {
        stringWithStatue = @"删除订单";
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 60*PROPORTION_WIDTH, SCREEN_W, 80*PROPORTION_WIDTH)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(230*PROPORTION_WIDTH, 10*PROPORTION_WIDTH, 130*PROPORTION_WIDTH, 40*PROPORTION_WIDTH)];
    view.backgroundColor = [UIColor whiteColor];
    [button setTitle:stringWithStatue forState:UIControlStateNormal];
    [button setTitleColor:[self colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    button.backgroundColor = [self colorWithHexString:@"FD681F"];
    button.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    button.layer.cornerRadius = 5*PROPORTION_WIDTH;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(orangeClick:) forControlEvents:UIControlEventTouchUpInside];
    //划线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [view addSubview:lineView];
    
    [view addSubview:button];
    [self.view addSubview:view];
}
#pragma mark --- 标签栏点击事件 ---
-(void)orangeClick:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"支付"]) {
        OrderTableViewCell *cell = [[OrderTableViewCell alloc] init];
        cell.order = [[Order alloc] init];
        cell.order.productName = @"糖人街";
        cell.order.amount = self.payMoney;
        cell.orderId = self.ordreID;
        [cell pay];
    }
    if ([button.titleLabel.text isEqualToString:@"订单跟踪"]) {
        TrackViewController *track = [[TrackViewController alloc] init];
        track.orderID = self.ordreID;
        [self.navigationController pushViewController:track animated:YES];
    }
    if ([button.titleLabel.text isEqualToString:@"确认收货"]) {
        NSDictionary *dic = @{@"status":@"dpj",@"id":self.ordreID};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:UpdateWithOrder parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                NSLog(@"成功");
            }
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
    }
    if ([button.titleLabel.text isEqualToString:@"评价"]) {
        EvaluateViewController *evaluate = [[EvaluateViewController alloc] init];
        evaluate.orderID = self.ordreID;
        [self.navigationController pushViewController:evaluate animated:YES];
    }
    if ([button.titleLabel.text isEqualToString:@"已评价"]) {
        EvaluateViewController *evaluate = [[EvaluateViewController alloc] init];
        evaluate.orderID = self.ordreID;
        [self.navigationController pushViewController:evaluate animated:YES];
    }
    if ([button.titleLabel.text isEqualToString:@"删除订单"]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:OrderDelete parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFormData:[self.ordreID dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                NSLog(@"成功");
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
        
    }
    
    
}

#pragma mark -- 懒加载  ---
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_W, SCREEN_H - 31*PROPORTION_WIDTH -44) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [self colorWithHexString:@"f7f7f7"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(NSMutableArray *)dataArray1{
    if (!_dataArray1) {
        _dataArray1 = [[NSMutableArray alloc] init];
    }
    return _dataArray1;
}
-(NSMutableArray *)dataArray2{
    if (!_dataArray2) {
        _dataArray2 = [[NSMutableArray alloc] init];
    }
    return _dataArray2;
}
-(NSMutableArray *)dataArray3{
    if (!_dataArray3) {
        _dataArray3 = [[NSMutableArray alloc] init];
    }
    return _dataArray3;
}
-(NSMutableArray *)dataArray4{
    if (!_dataArray4) {
        _dataArray4 = [[NSMutableArray alloc] init];
    }
    return _dataArray4;
}
-(UserIDModle *)userModle{
    if (!_userModle) {
        UserID *user = [UserID shareInState];
        _userModle = [[user redFromUserListAllData] lastObject];
    }
    return _userModle;
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
