//
//  VipViewController.m
//  QXD
//
//  Created by zhujie on 平成27-12-04.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "VipViewController.h"
#import "VipTableViewCell.h"
#import "VipModle.h"
#import "UserID.h"
#import "UserIDModle.h"
#import "AddFriendViewController.h"

@interface VipViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) UserIDModle *userModle;

@end

@implementation VipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[self creatVipDown]];
    [self.view addSubview:self.tableView];
    
}
#pragma mark --- tableview代理 ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1+self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vipCell"];
    if (!cell) {
        cell = [[VipTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"vipCell"];
    }
    if (indexPath.section == 0) {
        [cell.iconImag removeFromSuperview];
        [cell.nameLabel removeFromSuperview];
        [cell.vipImg removeFromSuperview];
        [cell.detailLabel removeFromSuperview];
        cell.backgroundColor = [UIColor whiteColor];
        if (indexPath.section == 0) {
            [cell addSubview:[self creatVipTop]];
        }
    }else{
    VipModle *modle = [self.dataArray objectAtIndex:indexPath.section - 1];
        [cell configCellWithModle:modle];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 200;
    }
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    if (section == 1) {
        return 80;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 60)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_W, 30)];
        label.text = @"尊敬的年卡用户可以添加三位成员共同使用会员资格";
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        
        [view addSubview:label];
        return view;
    }
    return nil;
}

#pragma mark --- 卖点会员卡 ---
-(UIView *)creatVipTop{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 200)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0,30, SCREEN_W, 25)];
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(titleLabel.frame) + 30,  SCREEN_W, 25)];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(numberLabel.frame) + 30,  SCREEN_W, 25)];
    
    
    titleLabel.text = @"卖点会员卡";
    numberLabel.text = self.userModle.vip_id;
    timeLabel.text = [NSString stringWithFormat:@"有效期：%@",self.userModle.vip_time_limit];
    
    titleLabel.textAlignment  = NSTextAlignmentCenter;
    numberLabel.textAlignment  = NSTextAlignmentCenter;
    timeLabel.textAlignment  = NSTextAlignmentCenter;

    [view addSubview:titleLabel];
    [view addSubview:numberLabel];
    [view addSubview:timeLabel];
    return view;
}
#pragma mark --- 添加副卡用户 ---
-(UIView *)creatVipDown{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 70, SCREEN_W, 70)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, 20, SCREEN_W - 60, 30)];
    button.layer.cornerRadius  = 5;
    button.layer.masksToBounds = YES;
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"添加副卡用户" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addUser) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    return view;
}
#pragma mark === 添加副卡按钮事件 ===
-(void)addUser{
    if (self.dataArray.count >= 3) {
        return;
    }
    AddFriendViewController *friend = [[AddFriendViewController alloc] init];
    [self.navigationController  pushViewController:friend animated:YES];
}


#pragma mark ---- 视图将要出现 ----
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    //判断会员  如果是会员
    if ([self.userModle.is_vip isEqualToString:@"1"]) {
        [self.dataArray removeAllObjects];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *dic = @{@"vip_id":self.userModle.vip_id};
        [manager GET:userVip parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"Succeed:%@",responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject) {
                    VipModle *vipModel = [[VipModle alloc] initWithDict:dic];
                    [self.dataArray addObject:vipModel];
                }
            }
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
//        [manager GET:userVip parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            NSLog(@"Succeed:%@",responseObject);
//            if ([responseObject isKindOfClass:[NSArray class]]) {
//                for (NSDictionary *dic in responseObject) {
//                    VipModle *vipModel = [[VipModle alloc] initWithDict:dic];
//                    [self.dataArray addObject:vipModel];
//                }
//            }
//            [self.tableView reloadData];
//            
//        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//            NSLog(@"Error:%@",error);
//        }];
    }
}

#pragma mark --- 懒加载 ---
-(UserIDModle *)userModle{
    if (!_userModle) {
        UserID *user = [UserID shareInState];
        _userModle = [[user redFromUserListAllData] lastObject];
    }
    return _userModle;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64 - 70) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
