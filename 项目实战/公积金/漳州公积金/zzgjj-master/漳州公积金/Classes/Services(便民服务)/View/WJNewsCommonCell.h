//
//  WJNewsCommonCell
//  漳州公积金
//
//  Created by fengwujie on 16/1/6.
//  Copyright © 2016年 vision-soft. All rights reserved.
//  计算列表Cell

#import <UIKit/UIKit.h>
@class WJNews;
@interface WJNewsCommonCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  设置当前CELL所在的行号
 *
 *  @param indexPath 当前行的indexPath
 *  @param rows      当前组中总行数
 */
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows;
/**
 *  Cell数据模型
 */
@property (nonatomic, strong) WJNews *news;
@end
