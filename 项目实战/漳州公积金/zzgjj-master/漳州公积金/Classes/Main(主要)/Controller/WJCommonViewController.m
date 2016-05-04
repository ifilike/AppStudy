
//
//  WJCommonViewController.m
//  黑马微博
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "WJCommonViewController.h"
#import "WJCommonGroup.h"
#import "WJCommonItem.h"
#import "WJCommonCell.h"
#import "WJCommonArrowItem.h"
#import "WJCommonSwitchItem.h"
#import "WJCommonLabelItem.h"

#define WJStatusCellMargin 20

@interface WJCommonViewController ()
@property (nonatomic, strong) NSMutableArray *groups;
@end

@implementation WJCommonViewController

- (NSMutableArray *)groups
{
    if (_groups == nil) {
        self.groups = [NSMutableArray array];
    }
    return _groups;
}

/** 屏蔽tableView的样式 */
- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置tableView属性
    self.tableView.backgroundColor = WJGlobalBg;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = WJStatusCellMargin;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(WJStatusCellMargin - 35, 0, 0, 0);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WJCommonGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJCommonCell *cell = [WJCommonCell cellWithTableView:tableView];
    WJCommonGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    // 设置cell所处的行号 和 所处组的总行数
    [cell setIndexPath:indexPath rowsInSection:group.items.count];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    WJCommonGroup *group = self.groups[section];
    return group.footer;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    WJCommonGroup *group = self.groups[section];
    return group.header;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取出这行对应的item模型
    WJCommonGroup *group = self.groups[indexPath.section];
    WJCommonItem *item = group.items[indexPath.row];
    
    // 2.判断有无需要跳转的控制器
    if (item.destVcClass) {
        UIViewController *destVc = [[item.destVcClass alloc] init];
        destVc.title = item.title;
        [self.navigationController pushViewController:destVc animated:YES];
    }
    // 3.判断有无想执行的操作
    else if (item.operation) {
        item.operation();
    }
}
@end