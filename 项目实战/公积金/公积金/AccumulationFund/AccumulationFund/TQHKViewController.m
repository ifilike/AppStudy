//
//  TQHKViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/14.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "TQHKViewController.h"
#import "TQHKTableViewCell.h"
#import "FundReferences.h"
#import "TQHKXQCollectionViewController.h"

@interface TQHKViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSArray * dataSource;

@end

@implementation TQHKViewController

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = @[
                        @[
                            @{@"key" : @"还款方式",
                              @"value" : @"等额本息"},
                            @{@"key" : @"剩余贷款本金",
                              @"value" : @"1234567.78元"},
                            @{@"key" : @"原贷款年限",
                              @"value" : @"20年"},
                            @{@"key" : @"贷款利率",
                              @"value" : @"基准 (5.65%)"}
                            ],
                        @[
                            @{@"key" : @"",
                              @"value" : @"提前还本"},
                            @{@"key" : @"提前还款金额",
                              @"value" : @"10万元"},
                            @{@"key" : @"提前还款方式",
                              @"value" : @"缩短还款年限"},
                            @{@"key" : @"提前还款时间",
                              @"value" : @"2015-09-19"}
                            ]
                        ];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"提前还款";

    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(-5, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return [self.dataSource[section] count] + 1;
    }
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > [self.dataSource[indexPath.section] count] - 1) {
        UITableViewCell * ButtonCell = [tableView dequeueReusableCellWithIdentifier:@"btnCell"];
        if (ButtonCell == nil) {
            ButtonCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"btnCell"];
            UIButton * button = [[UIButton alloc] init];
            [ButtonCell addSubview:button];
            button.frame = CGRectMake(k_screen_width * 0.1, (120 - 49) * 0.5, k_screen_width * 0.8, 49);
            ButtonCell.backgroundColor = BackgroundColor;
            button.backgroundColor = BarColor;
            [button setTitle:@"计算" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(calculaterButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
        return ButtonCell;
    }
    
    TQHKTableViewCell * cell = (TQHKTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"tqhkCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TQHKTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.keyLabel.text = self.dataSource[indexPath.section][indexPath.row][@"key"];
    cell.valueLabel.text = self.dataSource[indexPath.section][indexPath.row][@"value"];
    return cell;
}

- (void)calculaterButtonClick {
    [self.navigationController pushViewController:[TQHKXQCollectionViewController new] animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > [self.dataSource[indexPath.section] count] - 1) {
        return 120;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        if ([self.dataSource[1] count] == 2) {
            self.dataSource = nil;
            [self.tableView reloadData];
            return;
        }
        self.dataSource = @[
                            @[
                                @{@"key" : @"还款方式",
                                  @"value" : @"等额本息"},
                                @{@"key" : @"剩余贷款本金",
                                  @"value" : @"1234567.78元"},
                                @{@"key" : @"原贷款年限",
                                  @"value" : @"20年"},
                                @{@"key" : @"贷款利率",
                                  @"value" : @"基准 (5.65%)"}
                                ],
                            @[
                                @{@"key" : @"",
                                  @"value" : @"提前还清"},
                                @{@"key" : @"提前还款时间",
                                  @"value" : @"2016年09月"},
                                ]
                            ];
        [self.tableView reloadData];
    }
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.backgroundColor = BackgroundColor;
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}


@end
