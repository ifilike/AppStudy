//
//  NewsDetailViewController.h
//  AccumulationFund
//
//  Created by mac on 15/11/17.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSourceCenter.h"

@interface NewsListViewController : UIViewController

@property (strong, nonatomic) NSArray *dataSource;
@property (nonatomic,strong)UITableView *tableView;

@end
