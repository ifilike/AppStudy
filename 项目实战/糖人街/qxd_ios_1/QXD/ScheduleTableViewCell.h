//
//  ScheduleTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成28-01-22.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScheduleModle;

@interface ScheduleTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *detailLabe;

-(void)configCellWithModel:(ScheduleModle *)modle;
-(void)changeColorWithOrgen;
@end
