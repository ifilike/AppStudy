//
//  LoanQueryViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/19.
//  Copyright © 2015年 huancun. All rights reserved.
//

#define KLoanQuery @"loanQueryIdentifier"

#import "LoanQueryViewController.h"
#import "FundReferences.h"
#import "UserInfoTableViewCell.h"
#import "UIColor+Hex.h"
#import "AccountInfoCenter.h"

@interface LoanQueryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *loanTableView;
@property (strong, nonatomic) NSArray *nameArray;

@end

@implementation LoanQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"贷款查询";
    [self.view addSubview:self.loanTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"开始监听贷款查询信息通知");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loanInformationDidLoad) name:@"loanInformationDidLoadNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.loanInfo.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"未找到您的贷款记录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:true completion:nil];
    }
}

- (void)loanInformationDidLoad {
    self.loanInfo = [AccountInfoCenter sharedAccountInfoCenter].loanInformation;
    [self.loanTableView reloadData];
}

- (UITableView *)loanTableView
{
    if (_loanTableView == nil) {
        _loanTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _loanTableView.delegate = self;
        _loanTableView.dataSource = self;
        _loanTableView.backgroundColor = [UIColor colorWithHexString:@"ececec"];
        _loanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _loanTableView;
}

#pragma mark - UITableView 代理方法实现
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
    [tableView registerClass:[UserInfoTableViewCell class] forCellReuseIdentifier:KLoanQuery];
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KLoanQuery];
    if (!cell) {
        cell = [[UserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KLoanQuery];
    }
    
    
    NSDictionary *dict = self.nameArray[indexPath.section][indexPath.row];
    NSString *title = dict.allKeys.firstObject;
    NSString *detail = self.loanInfo[dict[title]];
    
    cell.leftLabel.text = title;
    cell.rightLabel.text = [detail isKindOfClass:[NSNull class]] ? @"无" : detail;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return k_screen_width / 9;
}

- (NSArray *)nameArray {
    if (_nameArray == nil) {
        _nameArray = @[
                       @[
                           @{@"姓名" : @"jkrxm"},
                           @{@"贷款状态" : @"dkzt"},
                           @{@"对冲选择" : @"dcxz"},
                           @{@"当前月还额" : @"yhke"},
                           @{@"本金余额" : @"bjye"},
                           @{@"已还金额" : @"yhje"},
                           ],
                       @[
                           @{@"已还利息" : @"yhlx"},
                           @{@"剩余期次" : @"syqc"},
                           @{@"下次还款日期" : @"xcyhke"},
                           @{@"逾期本金" : @"yqbj"},
                           @{@"逾期利息" : @"yqlx"},
                           @{@"当前逾期次数" : @"dqyqcs"},
                           @{@"累计逾期次数" : @"ljyqcs"},
                           ],
                       ];
    }
    return _nameArray;
}


@end
