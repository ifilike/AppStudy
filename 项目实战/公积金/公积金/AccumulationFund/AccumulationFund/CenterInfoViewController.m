//
//  CenterInfoViewController.m
//  AccumulationFund
//
//  Created by mac on 15/12/9.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "CenterInfoViewController.h"

@interface CenterInfoViewController ()

@end

@implementation CenterInfoViewController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataSourceInformationDidLoad) name:@"centerInfosDidLoadNotification" object:nil];
}

- (void)dataSourceInformationDidLoad {
    self.dataSource = [DataSourceCenter sharedDataSourceCenter].centerInfos;
    [self.tableView reloadData];
}




@end
