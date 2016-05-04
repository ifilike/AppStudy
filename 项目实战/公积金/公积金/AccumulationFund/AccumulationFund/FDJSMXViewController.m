//
//  FDJSMXViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/18.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "FDJSMXViewController.h"
#import "FDJSMXTableViewCell.h"

@interface FDJSMXViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView * tableView;

@end

@implementation FDJSMXViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"房贷计算明细";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.backView.bounds];
    [self.backView addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FDJSMXTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mingxiCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FDJSMXTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.NumberLabel.text  = [NSString stringWithFormat:@"第%.2i期", [self.dataSource[indexPath.row][@"no"] intValue]];
    cell.CountLabel.text = [self.dataSource[indexPath.row][@"count"] stringByAppendingString:@"元"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

@end
