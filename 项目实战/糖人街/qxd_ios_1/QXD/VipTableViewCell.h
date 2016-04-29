//
//  VipTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成27-12-04.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VipModle;

@interface VipTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *iconImag;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIImageView *vipImg;
@property(nonatomic,strong) UILabel *detailLabel;

-(void)configCellWithModle:(VipModle *)model;
@end
