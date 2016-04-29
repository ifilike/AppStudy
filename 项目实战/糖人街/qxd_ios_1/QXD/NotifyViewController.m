//
//  NotifyViewController.m
//  QXD
//
//  Created by zhujie on 平成28-01-04.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import "NotifyViewController.h"
#import "UserID.h"
#import "UserIDModle.h"
#import "NotifyTableViewCell.h"
#import "UserInfoViewController.h"



@interface NotifyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) UserIDModle *userModel;
@property(nonatomic,strong) UIView *bgView;

@end

@implementation NotifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    [self.view addSubview:self.tableView];
    [self creatDateArray];
}


#pragma mark --- 导航栏 ---
-(void)creatUI{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
    [leftBtn setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backWithBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = left;
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = @"消息通知";
    titleView.textColor = [self colorWithHexString:@"#555555"];
    titleView.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = titleView;
}
-(void)backWithBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 代理 ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notifyCell"];
    if (!cell) {
        cell = [[NotifyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notifyCell"];
    }
    
//    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.imageV.frame = CGRectMake(21*PROPORTION_WIDTH, 25*PROPORTION_WIDTH, 40*PROPORTION_WIDTH, 40*PROPORTION_WIDTH);
        cell.titleLabel.frame = CGRectMake(CGRectGetMaxX(cell.imageV.frame) + 20*PROPORTION_WIDTH, 25*PROPORTION_WIDTH, WIDTH - 102*PROPORTION_WIDTH, 40);
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80*PROPORTION_WIDTH;
    }else return 70*PROPORTION_WIDTH;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return -2*PROPORTION_WIDTH;
//}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
#pragma mark --- 创建数据元 ---
-(void)creatDateArray{
   
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSLog(@"%@",self.userModel.ID);
    NSDictionary *dict = @{@"customer_id":self.userModel.ID};
    [manger GET:Notify parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
            NSArray *array = [responseObject objectForKey:@"model"];
        
            for (NSDictionary *dict in array) {
                [self.dataArray addObject:[dict objectForKey:@"notice_content"]];
            }
            if (array.count == 0) {
                [self.view addSubview:self.bgView];
            }
            
            [self.tableView reloadData];
        }else{
            NSLog(@"数据格式不对");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
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
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -40, SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [self colorWithHexString:@"#f7f7f7"];
    }
    return _tableView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H /2 - 100*PROPORTION_WIDTH, SCREEN_W, 30*PROPORTION_WIDTH)];
        UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 30*PROPORTION_WIDTH)];
        bgLabel.text = @"你还没有消息通知";
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
-(UserIDModle *)userModel{
    if (!_userModel) {
        UserID *user = [UserID shareInState];
        _userModel = [[user redFromUserListAllData] lastObject];
    }
    return _userModel;
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
