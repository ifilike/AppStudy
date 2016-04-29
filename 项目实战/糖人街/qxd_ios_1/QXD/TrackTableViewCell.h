//
//  TrackTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成28-01-23.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Track;

@interface TrackTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *detailLabel;
-(void)configCellWithTrackModle:(Track *)model;
@end
