//
//  LastViewController.m
//  QXD
//
//  Created by zhujie on 平成28-01-08.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import "LastViewController.h"
#import "LastTableViewCell.h"
#import "UserID.h"
#import "UserIDModle.h"
#import "LastCollectionModel.h"

@interface LastViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) UserIDModle *useridModel;

@property(nonatomic,strong) UIView *bgView;//没有我的心愿单的时候用来填充
@end

@implementation LastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self creatNav];
}
#pragma mark --- 创建导航栏 ---
-(void)creatNav{
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
    [left setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(abc) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UILabel *titileV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titileV.text = @"我的心愿单";
    titileV.textAlignment = NSTextAlignmentCenter;
    titileV.font = [UIFont systemFontOfSize:17];
    titileV.textColor = [self colorWithHexString:@"#555555"];
    self.navigationItem.titleView = titileV;
}
-(void)abc{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --- 代理 ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LastTableViewCell *cell = [[LastTableViewCell alloc] init];
    cell.dataArray = self.dataArray;
    cell.VC = self;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count %2 == 0) {
//        return self.dataArray.count/2 *(WIDTH/2  + (WIDTH/4-10));
        return 242*PROPORTION_WIDTH * self.dataArray.count/2;
//    }return (1+self.dataArray.count/2)*(WIDTH/2  + (WIDTH/4-10));
    }return 242*PROPORTION_WIDTH *(1+self.dataArray.count/2);
}
#pragma mark --- 页面将要出现的时候  ---
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [self creatDataArray];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark --- 请求数据 ---
-(void)creatDataArray{
    [self.dataArray removeAllObjects];
    UserID *user = [UserID shareInState];
    self.useridModel = [[user redFromUserListAllData] lastObject];
        NSDictionary *dic = @{@"customer_id":_useridModel.ID};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:WishList parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                NSLog(@"成功");
                NSArray *array = [responseObject objectForKey:@"model"];
                for (NSDictionary *dictionary in array) {
                    LastCollectionModel *modd = [[LastCollectionModel alloc] initWithDic:dictionary];
                    [self.dataArray addObject:modd];
                }
                if (self.dataArray.count != 0) {
                    [self.bgView removeFromSuperview];
                }else{
                    [_tableView addSubview:self.bgView];
                }
                [self.tableView reloadData];
            }else{
                NSLog(@"数据格式不对");
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
}
#pragma mark --- 懒加载 ---
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H + 49) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H /2 - 100*PROPORTION_WIDTH, SCREEN_W, 30*PROPORTION_WIDTH)];
        UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 30*PROPORTION_WIDTH)];
        bgLabel.text = @"你还没有心愿单";
        bgLabel.textAlignment = NSTextAlignmentCenter;
        bgLabel.textColor = [self colorWithHexString:@"#999999"];
        bgLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        [_bgView addSubview:bgLabel];
    }
    return _bgView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
