//  NewsDetailViewController.m
//  AccumulationFund
//  Created by mac on 15/11/17.
//  Copyright © 2015年 huancun. All rights reserved.

#import "NewsListViewController.h"
#import "NewsInfoTableViewCell.h"
#import "FundReferences.h"
#import "NewsEmptyCell.h"

@interface NewsListViewController () <UITableViewDataSource,UITableViewDelegate>
@end

@implementation NewsListViewController

static NSString *const knewscell = @"newsTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

#pragma mark - 数据源排序


#pragma mark - 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 44.0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = BackgroundColor;
    }
    return _tableView;
}

#pragma mark - UItableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSource.count == 0) {
        return 1;
    }
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.dataSource.count == 0) {
        NewsEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"NewsEmptyCell" owner:nil options:nil].lastObject;
            cell.statusLabel.text = @"    网速不给力哦    \n    点击刷新    ";
            cell.cellHeightCons.constant = [UIScreen mainScreen].bounds.size.height - 80;
        }
        return cell;
    }
    
    NewsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:knewscell];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NewsInfoTableViewCell" owner:nil options:nil].lastObject;
    }
    cell.model = self.dataSource[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataSource.count == 0) {
        NewsEmptyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell startLoadInformation];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

@end
