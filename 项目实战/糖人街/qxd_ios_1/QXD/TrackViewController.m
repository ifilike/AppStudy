//
//  TrackViewController.m
//  QXD
//
//  Created by zhujie on 平成27-12-21.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "TrackViewController.h"
#import "Track.h"
#import "TrackTableViewCell.h"

@interface TrackViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSString *expressId;//快递单号
@property(nonatomic,strong) NSString *experssName;//快递名称
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) NSMutableArray *dataArrayChange;//逆序数组
@end

@implementation TrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatNav];
    [self getdataSource];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- 代理 ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 110*PROPORTION_WIDTH;
    }
        NSInteger i = indexPath.row;
        Track *model = [self.dataArray objectAtIndex:i];
        NSString *text = model.status;
        UILabel *label = [[UILabel alloc] init];
        label.text = text;
        [label setNumberOfLines:0];
        UIFont *font = [UIFont fontWithName:@"Arial" size:14*PROPORTION_WIDTH];
        //设置字体
        label.font = font;
        CGSize constraint = CGSizeMake(WIDTH - 80*PROPORTION_WIDTH, 20000.0f);
        CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        return size.height + 60*PROPORTION_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.expressId.length == 0) {
        return -2*PROPORTION_WIDTH;
    }
    return 45*PROPORTION_WIDTH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row == 0) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trachtop"];
//        if (!cell) {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"trachtop"];
//        }
//        cell.imageView.image = [UIImage imageNamed:@"express delivery_icon"];
//        cell.textLabel.text = @"nihao";
//        
//        return cell;
//    }
    TrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"track"];
    if (!cell) {
        cell = [[TrackTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tack"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Track *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell configCellWithTrackModle:model];
    if (indexPath.row == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, SCREEN_W - 40*PROPORTION_WIDTH, 15*PROPORTION_WIDTH)];
        label.text = @"订单跟踪";
        label.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        label.textColor = [self colorWithHexString:@"#555555"];
        cell.titleLabel.frame = CGRectMake(60*PROPORTION_WIDTH, CGRectGetMaxY(label.frame)+10*PROPORTION_WIDTH, WIDTH - 80*PROPORTION_WIDTH, 40*PROPORTION_WIDTH);
        cell.titleLabel.textColor = [self colorWithHexString:@"#FD681F"];
        cell.detailLabel.frame = CGRectMake(60*PROPORTION_WIDTH, CGRectGetMaxY(cell.titleLabel.frame), WIDTH - 80*PROPORTION_WIDTH, 12*PROPORTION_WIDTH);
        
        [cell addSubview:label];
    }
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 45*PROPORTION_WIDTH)];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 10*PROPORTION_WIDTH, 25*PROPORTION_WIDTH, 25*PROPORTION_WIDTH)];
    imageV.image = [UIImage imageNamed:@"express delivery_icon"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10*PROPORTION_WIDTH , 0, SCREEN_W - 65 *PROPORTION_WIDTH, 45*PROPORTION_WIDTH)];
    label.text = [NSString stringWithFormat:@"%@    %@",self.experssName,self.expressId];
    label.textColor = [self colorWithHexString:@"#555555"];
    label.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    
    [view addSubview:label];
    [view addSubview:imageV];
    
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

#pragma makr ---- 数据源 ---
-(void)getdataSource{
//    NSDictionary *dict = @{@"id":self.orderID};
    NSLog(@"______%@",self.express_id);
    if (self.express_id.length == 0) {
        self.express_id = @"";
    }
    NSDictionary *dict = @{@"number":self.express_id};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:OrderTrack parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
            NSLog(@"%@",responseObject);
            NSDictionary *dictionary = [responseObject objectForKey:@"model"];
            NSString *status = [dictionary objectForKey:@"status"];
            if (![status isEqualToString:@"0"]) {
                NSLog(@"______________");
                Track *modle = [[Track alloc] init];
                modle.status = @"订单已提交，请等待卖家发货";
                modle.time = @"";
                [self.dataArray addObject:modle];
                NSDictionary *dic = [dictionary objectForKey:@"express"];
                self.experssName = [dic objectForKey:@"express_name"];
                self.expressId = [dic objectForKey:@"express_id"];
                [self.tableView reloadData];
                return ;
            }
            NSDictionary *dict = [dictionary objectForKey:@"result"];
            NSArray *array = [dict objectForKey:@"list"];
            NSLog(@"%@",self.orderID);
            NSLog(@"%@",dictionary);
//            NSArray *array = [dictionary objectForKey:@"tracks"];
            if (array.count == 0) {
                [self.view addSubview:self.bgView];
                [self.tableView removeFromSuperview];
                return ;
            }
            for (NSDictionary *dict in array) {
                Track *modle = [[Track alloc] initWithDic:dict];
                [self.dataArray addObject:modle];
            }
            Track *modelFirst = [self.dataArray objectAtIndex:0];
            Track *modelLast = [self.dataArray objectAtIndex:self.dataArray.count - 1];
            //给数组逆序
            if ([[self getBaseTimeWithFormatter:modelFirst.time] integerValue] < [[self getBaseTimeWithFormatter:modelLast.time] integerValue]) {
                self.dataArrayChange = [[NSMutableArray alloc] init];
                for (int i = 0; i < self.dataArray.count; i++) {
                    Track *modelChange = [self.dataArray objectAtIndex:self.dataArray.count - i - 1];
                    [self.dataArrayChange addObject:modelChange];
                    NSLog(@"___%@",self.dataArrayChange);
                    
                }
                [self.dataArray removeAllObjects];
                self.dataArray  = self.dataArrayChange;
            }
            
            NSDictionary *dic = [dictionary objectForKey:@"express"];
            self.experssName = [dic objectForKey:@"express_name"];
            self.expressId = [dic objectForKey:@"express_id"];
            [self.tableView reloadData];
        }else{
            NSLog(@"数据格式不对");
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
    
}
#pragma mark ---- 时间转化为时间挫 ----
//时间转时间挫
-(NSString *)getBaseTimeWithFormatter:(NSString *)string{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *d = [formatter dateFromString:string];
    
    NSString *timeSp = [NSString stringWithFormat:@"%f",[d timeIntervalSince1970]];
    return timeSp;
}

#pragma mark --- 创建导航栏 ---
-(void)creatNav{
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
    [left setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(backWithR) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UILabel *titileV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titileV.text = @"订单跟踪";
    titileV.textAlignment = NSTextAlignmentCenter;
    titileV.font = [UIFont systemFontOfSize:17];
    titileV.textColor = [self colorWithHexString:@"#555555"];
    self.navigationItem.titleView = titileV;
    [self.view addSubview:self.tableView];
}
-(void)backWithR{
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
#pragma mark --- 懒加载 ---
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(UITableView *)tableView{
    if (!_dataArray) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -36, SCREEN_W, SCREEN_H + 49 + 64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H /2 - 100*PROPORTION_WIDTH, SCREEN_W, 30*PROPORTION_WIDTH)];
        UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 30*PROPORTION_WIDTH)];
        bgLabel.text = @"你还没有物流信息";
        bgLabel.textAlignment = NSTextAlignmentCenter;
        bgLabel.textColor = [self colorWithHexString:@"#999999"];
        bgLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        [_bgView addSubview:bgLabel];
    }
    return _bgView;
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
