//
//  DepositeDetailViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/19.
//  Copyright © 2015年 huancun. All rights reserved.
//

#define kDepositeCell @"depositeCell"

#import "DepositeDetailViewController.h"
#import "FundReferences.h"
#import "UIColor+Hex.h"
#import "UIView+CG.h"

#import "DepositeDetailTableViewCell.h"
#import "AccountInfoCenter.h"

@interface DepositeDetailViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *depositeTableView;

@end

@implementation DepositeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴存明细";
    [self.view addSubview:self.depositeTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"开始监听缴存明细信息通知");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(depositDetailInformationDidLoad) name:@"depositDetailInformationDidLoadNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.depositDetail.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"未找到您的缴存记录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:true completion:nil];
    }
}

- (void)depositDetailInformationDidLoad {
    self.depositDetail = [AccountInfoCenter sharedAccountInfoCenter].depositDetail;
    [self.depositeTableView reloadData];
}

- (UITableView *)depositeTableView {
    if (_depositeTableView == nil) {
        _depositeTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _depositeTableView.delegate = self;
        _depositeTableView.dataSource = self;
        _depositeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _depositeTableView.backgroundColor = [UIColor colorWithHexString:@"ececec"];
    }
    return _depositeTableView;
}



#pragma mark - UItableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.depositDetail.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[DepositeDetailTableViewCell class] forCellReuseIdentifier:kDepositeCell];
    DepositeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDepositeCell];
    if (!cell) {
        cell = [[DepositeDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDepositeCell];
    }
    cell.dict = self.depositDetail[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return k_screen_width / 5 * 2;
}

@end
