//
//  NewTrackTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成28-02-02.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTrackModel.h"

@interface NewTrackTableViewCell : UITableViewCell


@property(nonatomic,strong) UILabel *titleView;
@property(nonatomic,strong) UILabel *detailLabel;

-(void)configCellWithModle:(NewTrackModel *)newTrackModel;
@end
