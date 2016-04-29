//
//  AddFriendViewController.m
//  QXD
//
//  Created by zhujie on 平成27-12-17.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "AddFriendViewController.h"
#import "UMSocial.h"


@interface AddFriendViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self creatNav];
}
#pragma mark --- 代理方法 ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vipFriend"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"vipFriend"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.imageView setImage:[UIImage imageNamed:@"返回.png"]];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"_______%ld",indexPath.row);
    [UMSocialSnsService presentSnsController:self appKey:UMAppKey shareText:@"aaaaaaa" shareImage:[UIImage imageNamed:@"喜欢.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline, nil] delegate:self];
    
}

#pragma mark --- 创建导航栏 ---
-(void)creatNav{
    self.title = @"邀请用户";
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
#pragma mark --- 返回上一页 ---
-(void)back{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark --- 懒加载 ---
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        _dataArray = @[@"添加QQ好友",@"添加微博好友",@"添加微信好友",@"添加通讯录好友"];
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
