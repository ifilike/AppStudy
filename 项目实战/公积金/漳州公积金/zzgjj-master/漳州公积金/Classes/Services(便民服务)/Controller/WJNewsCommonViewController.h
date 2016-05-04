//
//  WJNewsCommonViewController.h
//  漳州公积金
//
//  Created by fengwujie on 16/1/6.
//  Copyright © 2016年 vision-soft. All rights reserved.
//  新闻列表父控制器

#import <UIKit/UIKit.h>

@interface WJNewsCommonViewController : UITableViewController

/**
 *  (5为政策法规，7为办事指南)
 */
@property (nonatomic, strong) NSNumber *lmid;

@end
