//
//  WorkGuideViewController.m
//  AccumulationFund
//
//  Created by mac on 15/12/9.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "WorkGuideViewController.h"

@interface WorkGuideViewController ()

@end

@implementation WorkGuideViewController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataSourceInformationDidLoad) name:@"workGuidesDidLoadNotification" object:nil];
}

- (void)dataSourceInformationDidLoad {
    self.dataSource = [DataSourceCenter sharedDataSourceCenter].workGuides;
    [self.tableView reloadData];
}

@end
