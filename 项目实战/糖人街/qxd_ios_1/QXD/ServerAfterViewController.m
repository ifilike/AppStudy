
//
//  ServerAfterViewController.m
//  QXD
//
//  Created by zhujie on 平成28-01-21.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import "ServerAfterViewController.h"
#import "FriendsModel.h"
#import "ScheduleModle.h"
#import "CalucateTableViewCell.h"
#import "ScheduleTableViewCell.h"

@interface ServerAfterViewController ()<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *dataArray1;//第二组
@property(nonatomic,strong) NSString *ID;//id 主键

@end

@implementation ServerAfterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.tableView];
    [self creatNav];
    [self getSource];
}
#pragma mark --- 代理 ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArray1.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40*PROPORTION_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 0.1*PROPORTION_WIDTH;
    }
    return 180*PROPORTION_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 160*PROPORTION_WIDTH;
    }
    return 95*PROPORTION_WIDTH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        CalucateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ser"];
        if (!cell) {
            cell = [[CalucateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ser"];
        }
        FriendsModel *modle = [[FriendsModel alloc] init];
        modle = [self.dataArray objectAtIndex:indexPath.row];
        
        [cell configCellWithShopCarModel:modle];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(275*PROPORTION_WIDTH, 120*PROPORTION_WIDTH, 80*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
        label.layer.borderWidth = 1;
        label.layer.borderColor = [[self colorWithHexString:@"#999999"] CGColor];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        label.text = @"待审核";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [self colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        [cell addSubview:label];
        
        return cell;
    }
    
    
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aa"];
    if (!cell) {
        cell = [[ScheduleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aa"];
    }
    
    ScheduleModle *model  = [self.dataArray1 objectAtIndex:indexPath.row];
    [cell configCellWithModel:model];
    if (indexPath.row == 0) {
        [cell changeColorWithOrgen];
    }
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20*PROPORTION_WIDTH, 0, SCREEN_W - 40, 40*PROPORTION_WIDTH)];
    label.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    if (section == 0) {
        label.textColor = [self colorWithHexString:@"#FD681F"];
        label.text = @"退货商品";
    }else{
        label.text = @"退货进度";
        label.textColor = [self colorWithHexString:@"#555555"];
    }
    view .backgroundColor = [UIColor whiteColor];
    [view addSubview:label];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 180*PROPORTION_WIDTH)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, SCREEN_W - 40*PROPORTION_WIDTH, 72*PROPORTION_WIDTH)];
    titleLabel.textColor = [self colorWithHexString:@"#555555"];
    titleLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    titleLabel.numberOfLines = 3;
    titleLabel.text = @"退货申请提交成功，我们会尽快的为您审核，若7个工作日未处理，退货申请将达成并需要您把货物退回给我们";
    
    UIButton *detailLabel = [[UIButton alloc] initWithFrame:CGRectMake(105*PROPORTION_WIDTH, 120*PROPORTION_WIDTH, SCREEN_W - 210*PROPORTION_WIDTH, 40*PROPORTION_WIDTH)];
    detailLabel.layer.borderWidth = 1;
    detailLabel.layer.borderColor = [[self colorWithHexString:@"#FD681F"] CGColor];
    detailLabel.layer.cornerRadius = 5;
    detailLabel.layer.masksToBounds = YES;
    detailLabel.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    [detailLabel setTitle:@"撤销退货申请" forState:UIControlStateNormal];
    [detailLabel setTitleColor:[self colorWithHexString:@"#FD681F"] forState:UIControlStateNormal];
    [detailLabel addTarget:self action:@selector(backWithTH) forControlEvents:UIControlEventTouchUpInside];
    
    //行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5*PROPORTION_WIDTH];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleLabel.text length])];
    titleLabel.attributedText = attributedString;
    [titleLabel sizeToFit];
    
    [view addSubview:titleLabel];
    [view addSubview:detailLabel];
    return view;
}

#pragma mark --- 撤销退货 ---
-(void)backWithTH{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:DeleteRefund parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFormData:[self.ID dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
        [formData appendPartWithFormData:[self.order_id dataUsingEncoding:NSUTF8StringEncoding] name:@"order_id"];
        [formData appendPartWithFormData:[self.product_id dataUsingEncoding:NSUTF8StringEncoding] name:@"product_id"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
        [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSLog(@"数据格式不对");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
}

#pragma mark --- 数据源 ---
-(void)getSource{
    
    NSDictionary *dict = @{@"order_id":self.order_id ,@"product_id":self.product_id};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:RefundSchedule parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
        [self.dataArray removeAllObjects];
        [self.dataArray1 removeAllObjects];
            NSDictionary *dictionary = [responseObject objectForKey:@"model"];
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = [dictionary objectForKey:@"refund"];
            FriendsModel *model = [[FriendsModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
            self.ID = model.ID;
            NSArray *array = [dictionary objectForKey:@"schedule"];
            for ( NSDictionary *dicc in array) {
                ScheduleModle *schedule = [[ScheduleModle alloc] initWithDic:dicc];
                [self.dataArray1 addObject:schedule];
            }
            [self.dataArray addObject:self.dataArray1];
//        }
        [self.tableView reloadData];
        }else{
            NSLog(@"数据格式不对");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
    
}


#pragma mark --- 创建导航栏 ---
-(void)creatNav{
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
    [left setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(abc) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UILabel *titileV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titileV.text = @"订单详情";
    titileV.textAlignment = NSTextAlignmentCenter;
    titileV.font = [UIFont systemFontOfSize:17];
    titileV.textColor = [self colorWithHexString:@"#555555"];
    self.navigationItem.titleView = titileV;
    //添加tableView
    [self.view addSubview:self.tableView];
}
-(void)abc{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 懒加载 ---
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
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H + 49*PROPORTION_WIDTH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
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
