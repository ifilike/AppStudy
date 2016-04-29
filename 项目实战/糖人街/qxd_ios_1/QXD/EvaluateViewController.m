//
//  EvaluateViewController.m
//  QXD
//
//  Created by zhujie on 平成27-12-21.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "EvaluateViewController.h"
#import "EvaluateModle.h"
#import "EvaluateTableViewCell.h"
#import "EvaluateDetailViewController.h"

@interface EvaluateViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) UIView *topView;
@end

@implementation EvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评价";
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    [self creatNav];
    self.view.backgroundColor = [UIColor whiteColor];
}
#pragma mark --- 创建导航栏 ---
-(void)creatNav{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    label.text = @"评价";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [self colorWithHexString:@"#555555"];
    label.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21*PROPORTION_WIDTH, 21*PROPORTION_WIDTH)];
    button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"return_icon"]];
    [button addTarget:self action:@selector(backWithE) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = left;
}
-(void)backWithE{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 代理 ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pingjia"];
    if (!cell) {
        cell = [[EvaluateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pingjia"];
    }
    EvaluateModle *modle = self.dataArray[indexPath.row];
    [cell configWithEvaluatModel:modle];
    cell.DetailBlock = ^(){
        EvaluateDetailViewController *detail = [[EvaluateDetailViewController alloc] init];
        detail.datailModel = modle;
        detail.orderId = self.orderID;
        [self.navigationController pushViewController:detail animated:YES];
    };
    return cell;
};
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100*PROPORTION_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01*PROPORTION_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01*PROPORTION_WIDTH;
}
#pragma mark --- 创建数据元 ---
-(void)creatDataSource{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dict = @{@"id":self.orderID};
    [manager GET:OrderEvaluate parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
            NSArray *array = [responseObject objectForKey:@"model"];
            for (NSDictionary *dict in array) {
                EvaluateModle *modle = [[EvaluateModle alloc] initWithDiction:dict];
                [self.dataArray addObject:modle];
            }
            [self.tableView reloadData];
        }else{
            NSLog(@"数据格式不对");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
}
#pragma mark --- 页面将要出现 ---
-(void)viewWillAppear:(BOOL)animated{
    [self creatDataSource];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.dataArray removeAllObjects];
}
#pragma mark --- 懒加载 ---
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(UIView *)topView{
    if (!_topView) {
        _topView  = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, 55*PROPORTION_WIDTH)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 0, SCREEN_W - 30*PROPORTION_WIDTH, 55*PROPORTION_WIDTH)];
        titleLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        titleLabel.textColor = [self colorWithHexString:@"#555555"];
        titleLabel.text = @"给商品评价";
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 54*PROPORTION_WIDTH, SCREEN_W - 30*PROPORTION_WIDTH, 1*PROPORTION_WIDTH)];
        view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
//        [_topView addSubview:view];
        [_topView addSubview:titleLabel];
    }
    return _topView;
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
