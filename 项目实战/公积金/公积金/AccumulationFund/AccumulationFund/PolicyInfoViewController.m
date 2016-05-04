//
//  PolicyInfoViewController.m
//  AccumulationFund
//
//  Created by mac on 15/12/9.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "PolicyInfoViewController.h"

@interface PolicyInfoViewController ()

@end

@implementation PolicyInfoViewController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataSourceInformationDidLoad) name:@"policyInfosDidLoadNotification" object:nil];
}

- (void)dataSourceInformationDidLoad {
    self.dataSource = [DataSourceCenter sharedDataSourceCenter].policyInfos;
    [self.tableView reloadData];
}


@end
