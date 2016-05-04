//
//  NewsViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 huancun. All rights reserved.
//


#import "NewsViewController.h"
#import "FundReferences.h"
#import "NewsInfoTableViewCell.h"
#import "UIView+CG.h"
#import "UIColor+Hex.h"
#import "NewsListViewController.h"
#import "DataSourceCenter.h"
#import "CenterInfoViewController.h"
#import "PolicyInfoViewController.h"
#import "WorkGuideViewController.h"
#import "NewsEmptyCell.h"

@interface NewsViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UIView *tableHeaderView;
}


@property (strong, nonatomic) NSArray *dataSource;

@property (nonatomic,strong)UITableView *newsTableView; //整体tableView

@property (nonatomic,strong)UIButton *centerBt;     //中心信息
@property (nonatomic,strong)UIButton *policyBt;     //政策信息
@property (nonatomic,strong)UIButton *workBt;       //办事指南



@end

@implementation NewsViewController

static NSString *const knewscell = @"newsIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self createUI];
    self.dataSource = [DataSourceCenter sharedDataSourceCenter].allNews;
    [self startObserverNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startObserverNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startObserverNotification {
    NSLog(@"开始监听所有新闻通知");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewReloadData) name:@"allNewsDidLoadNotification" object:nil];
}

- (void)tableViewReloadData {
    NSLog(@"%@", @"接收数据刷新tableView");
    self.dataSource = [DataSourceCenter sharedDataSourceCenter].allNews;
    [self.newsTableView reloadData];
}

- (void)createUI {
    
    //tableHeaderView
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, k_screen_width, k_screen_width / 5 * 4)];
    headView.backgroundColor = [UIColor whiteColor];
    
    //图片
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, k_screen_width, k_screen_width / 5 * 2)];
    topImageView.image = [UIImage imageNamed:@"homePage"];
    [headView addSubview:topImageView];
    
    //加一道杠
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topImageView.frame), k_screen_width, 10)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"ececec"];
    [headView addSubview:lineView];
    
    //按钮
    UIView *btView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame) , k_screen_width, k_screen_width / 5 * 2)];
    [btView addSubview:self.centerBt];
    [btView addSubview:self.policyBt];
    [btView addSubview:self.workBt];
    
    [headView addSubview:btView];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame) - 5, k_screen_width, 5)];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"ececec"];
    [headView addSubview:bottomView];
    
    [self.view addSubview:self.newsTableView];
    _newsTableView.tableHeaderView = headView;
}


#pragma mark - UiTableView 代理方法实现
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
#warning 未测试5s 与 6p
            cell.cellHeightCons.constant = 250;
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


#pragma mark - 懒加载

- (UITableView *)newsTableView {
    if (_newsTableView == nil) {
        _newsTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _newsTableView.delegate = self;
        _newsTableView.dataSource = self;
        _newsTableView.estimatedRowHeight = 44.0;
        _newsTableView.rowHeight = UITableViewAutomaticDimension;
        _newsTableView.showsHorizontalScrollIndicator = NO;
        _newsTableView.showsVerticalScrollIndicator = NO;
        _newsTableView.backgroundColor = BackgroundColor;
    }
    return _newsTableView;
}

//中心信息
- (UIButton *)centerBt {
    if (_centerBt == nil) {
        _centerBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _centerBt.frame = CGRectMake(k_screen_width / 7, k_screen_width / 20, k_screen_width / 6 , k_screen_width / 4);
        [_centerBt setBackgroundColor:[UIColor whiteColor]];
        [_centerBt setImage:[UIImage imageNamed:@"centerBt"] forState:UIControlStateNormal];
        _centerBt.imageEdgeInsets = UIEdgeInsetsMake(-5, 1, 5, 0);
        [_centerBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_centerBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _centerBt.titleLabel.font = YFont(12);
        
        [_centerBt setTitle:@"中心信息" forState:UIControlStateNormal];
        [_centerBt setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, -75, 10)];
        [_centerBt addTarget:self action:@selector(centerBtAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerBt;
}

//政策信息
- (UIButton *)policyBt {
    if (_policyBt == nil) {
        _policyBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _policyBt.frame = CGRectMake(k_screen_width / 7 * 3, k_screen_width / 20, k_screen_width / 6 , k_screen_width /4);
        [_policyBt setBackgroundColor:[UIColor whiteColor]];
        [_policyBt setImage:[UIImage imageNamed:@"policyBt"] forState:UIControlStateNormal];
        [_policyBt setTitle:@"政策信息" forState:UIControlStateNormal];
        
        [_policyBt setImageEdgeInsets:UIEdgeInsetsMake(-5, 1, 5, 0)];
        [_policyBt setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, -75, 10)];
        [_policyBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_policyBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _policyBt.titleLabel.font = YFont(12);
        [_policyBt addTarget:self action:@selector(policyBtAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _policyBt;
}

//办事指南
- (UIButton *)workBt {
    if (_workBt == nil) {
        _workBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _workBt.frame = CGRectMake(k_screen_width / 7 * 5, k_screen_width / 20, k_screen_width / 6, k_screen_width / 4);
        [_workBt setBackgroundColor:[UIColor whiteColor]];
        [_workBt setImage:[UIImage imageNamed:@"workBt"] forState:UIControlStateNormal];
        [_workBt setImageEdgeInsets:UIEdgeInsetsMake(-5, 1, 5, 0)];
        
        [_workBt setTitle:@"办事指南" forState:UIControlStateNormal];
        [_workBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_workBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        _workBt.titleLabel.font = YFont(12);
        _workBt.titleEdgeInsets = UIEdgeInsetsMake(0, -50, -75, 10);
        
        [_workBt addTarget:self action:@selector(workBtAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _workBt;
}

#pragma mark - 按钮方法


//中心信息
- (void)centerBtAction:(UIButton *)bt {
    NSLog(@"中心信息按钮");

    CenterInfoViewController *centerInfo = [[CenterInfoViewController alloc] init];
    centerInfo.navigationItem.title = bt.titleLabel.text;
    centerInfo.hidesBottomBarWhenPushed = true;
    centerInfo.dataSource = [DataSourceCenter sharedDataSourceCenter].centerInfos;
    [self.navigationController pushViewController:centerInfo animated:true];
}

//政策信息
- (void)policyBtAction:(UIButton *)bt {
    NSLog(@"政策信息按钮");
    
    PolicyInfoViewController *policyInfo = [[PolicyInfoViewController alloc] init];
    policyInfo.navigationItem.title = bt.titleLabel.text;
    policyInfo.hidesBottomBarWhenPushed = true;
    policyInfo.dataSource = [DataSourceCenter sharedDataSourceCenter].policyInfos;
    [self.navigationController pushViewController:policyInfo animated:true];
}

//办事指南
- (void)workBtAction:(UIButton *)bt {
    NSLog(@"办事指南按钮");
    
    WorkGuideViewController *workGuide = [[WorkGuideViewController alloc] init];
    workGuide.navigationItem.title = bt.titleLabel.text;
    workGuide.hidesBottomBarWhenPushed = true;
    workGuide.dataSource = [DataSourceCenter sharedDataSourceCenter].workGuides;
    [self.navigationController pushViewController:workGuide animated:true];
}

@end
