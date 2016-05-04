//
//  WJCalculatorViewController.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/6.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "WJCalculatorViewController.h"
#import "WJNews.h"
#import "MJExtension.h"
#import "WJWebViewController.h"
#import "WJNewsCommonCell.h"

@interface WJCalculatorViewController ()
@property (nonatomic, strong) NSMutableArray *news;

@end

@implementation WJCalculatorViewController

-(NSMutableArray *)news
{
    if (_news==nil) {
        NSArray *array = @[@{@"FTitle":@"可贷额度计算器" , @"RedirectUrl": @"http://2015.zzgjj.gov.cn/jsq/kdednew.htm"},@{@"FTitle":@"等额本金月还款额计算器" , @"RedirectUrl": @"http://2015.zzgjj.gov.cn/jsq/return.asp"},@{@"FTitle":@"等额本息月还款额计算器" , @"RedirectUrl": @"http://2015.zzgjj.gov.cn/jsq/return1.asp"}];
        _news = [WJNews mj_objectArrayWithKeyValuesArray:array];
        /*
        NSDictionary *dict1 = @{@"title":@"可贷额度计算器" , @"destUrl": @"http://www.baidu.com"};
        WJNews *new1 = [WJNews mj_objectWithKeyValues:dict1];
        NSDictionary *dict2 = @{@"title":@"等额本金月还款额计算器" , @"destUrl": @"http://www.baidu.com"};
        WJNews *new2 = [WJNews mj_objectWithKeyValues:dict2];
        NSDictionary *dict3 = @{@"title":@"等额本息月还款额计算器" , @"destUrl": @"http://www.baidu.com"};
        WJNews *new3 = [WJNews mj_objectWithKeyValues:dict3];
        [self.news addObject:new1];
        [self.news addObject:new2];
        [self.news addObject:new3];
         */
    }
    return _news;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableView属性
    self.tableView.backgroundColor = WJGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.sectionFooterHeight = WJStatusCellMargin;
    self.tableView.sectionHeaderHeight = 0;
    //self.tableView.contentInset = UIEdgeInsetsMake(WJStatusCellMargin - 35, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.news.count;
}


#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1.创建cell
    WJNewsCommonCell *cell = [WJNewsCommonCell cellWithTableView:tableView];
    // 2.设置cell的数据
    WJNews *news = self.news[indexPath.row];
    cell.news = news;
    [cell setIndexPath:indexPath rowsInSection:self.news.count];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取出这行对应的News模型
    WJNews *new = self.news[indexPath.row];
    if (new.RedirectUrl) {
        WJWebViewController *webVC = [[WJWebViewController alloc] init];
        webVC.title = new.FTitle;
        webVC.strUrl = new.RedirectUrl;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

@end
