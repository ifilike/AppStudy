//
//  WDYY2ViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/21.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "WDYY2ViewController.h"
#import "WDYY2TableViewCell.h"
#import "WDYY2TableView.h"
#import "FundReferences.h"
#import "ConvenientTools.h"

@interface WDYY2ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) WDYY2TableView * tableView;
@end

@implementation WDYY2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的预约";

    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"开始监听预约查询信息通知");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appointedInformationDidLoad) name:@"appointedInfoDidLoadNotification" object:nil];
    [self showTableViewLineView];
}

- (void)showTableViewLineView {
    if ([self.appointedInfo count] == 0) {
        self.tableView.lineView.hidden = true;
    } else {
        self.tableView.lineView.hidden = false;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)appointedInformationDidLoad {
    self.appointedInfo = [ConvenientTools sharedConvenientTools].appointedInfo;
    [self.tableView reloadData];
    [self showTableViewLineView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.appointedInfo count] == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"未找到您的预约记录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:true completion:nil];
        return;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.appointedInfo.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDYY2TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"wdyy2_cell"];
    if (cell == nil) {
        cell = [[WDYY2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wdyy2_cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableString * str = [NSMutableString string];
    NSDictionary * infoDict = self.appointedInfo[indexPath.row];
    
    NSString *slrq = infoDict[@"slrq"];
    if (slrq.length >= 10) {
        [str appendFormat:@"\n%@ 预约\n", [slrq substringToIndex:10]];
    }
    [str appendFormat:@"%@\n", infoDict[@"ywlx"]];
    NSString *yysj = infoDict[@"yysj"];
    if (yysj.length >= 10) {
        [str appendFormat:@"预约时间 %@\n", [yysj substringToIndex:10]];
    }
    [str appendFormat:@"预约网点 %@\n", infoDict[@"yywd"]];
    [str appendString:@"申请编号\n"];
    [str appendFormat:@"%@\n", infoDict[@"sqbh"]];
    cell.infoLabel.text = str.copy;
    return cell;
}

- (WDYY2TableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[WDYY2TableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(20, 0, 50, 0);
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

@end
