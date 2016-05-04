//
//  AccountQueryViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/19.
//  Copyright © 2015年 huancun. All rights reserved.
//

#define kuserInfo @"userInfoIdentifier"

#import "AccountQueryViewController.h"
#import "FundReferences.h"
#import "UserInfoTableViewCell.h"
#import "UIColor+Hex.h"
#import "AccountInfoCenter.h"

@interface AccountQueryViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *accountTableView;
@property (strong, nonatomic) NSArray *nameArray;

@end

@implementation AccountQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"账户信息";
    [self.view addSubview:self.accountTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"开始监听账户信息通知");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAccountInformationDidLoad) name:@"userAccountInfoDidLoadNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.userAccountDict.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"未找到您的用户信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:true completion:nil];
    }
}

- (void)userAccountInformationDidLoad {
    self.userAccountDict = [AccountInfoCenter sharedAccountInfoCenter].userAccount;
    [self.accountTableView reloadData];
}

- (UITableView *)accountTableView
{
    if (_accountTableView == nil) {
        _accountTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _accountTableView.delegate = self;
        _accountTableView.dataSource = self;
        
        _accountTableView.backgroundColor = [UIColor colorWithHexString:@"ececec"];
        
        _accountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _accountTableView;
}





#pragma mark - UItableview 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.nameArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.nameArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView registerClass:[UserInfoTableViewCell class] forCellReuseIdentifier:kuserInfo];
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kuserInfo];
    if (!cell) {
        cell = [[UserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kuserInfo];
    }
    
    NSDictionary *dict = self.nameArray[indexPath.section][indexPath.row];
    NSString *title = dict.allKeys.firstObject;
    NSString *detail = self.userAccountDict[dict[title]];
    
    cell.leftLabel.text = title;
    cell.rightLabel.text = [detail isKindOfClass:[NSNull class]] ? @"无" : detail;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return k_screen_width / 9;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


- (NSArray *)nameArray {
    if (_nameArray == nil) {
        _nameArray = @[
                       @[
                           @{@"个人账号" : @"zgzh"},
                           @{@"单位名称" : @"dwmc"},
                           @{@"单位账号" : @"dwzh"},
                           @{@"账户状态" : @"zhzt"},
                           @{@"缴至月份" : @"jzyf"},
                           @{@"缴存基数" : @"jcjs"},
                           ],
                       @[
                           @{@"月缴存额" : @"yjce"},
                           @{@"个人部分" : @"grbf"},
                           @{@"个人缴存比例" : @"grjcbl"},
                           @{@"单位部分" : @"dwbf"},
                           @{@"单位缴存比例" : @"dwjcbl"},
                           ],
                       ];
    }
    return _nameArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"个人信息查询收到内存警告");
    self.userAccountDict = nil;
    [self.accountTableView reloadData];
}

@end
