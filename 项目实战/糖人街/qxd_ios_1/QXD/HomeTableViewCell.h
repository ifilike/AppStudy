//
//  HomeTableViewCell.h
//  QXD
//
//  Created by WZP on 15/11/20.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeModel;
@class MutibleLabel;
@class ByxxrMode;

@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UILabel *labelView;
@property (weak, nonatomic) IBOutlet UIButton *detailsBut;
@property (weak, nonatomic) IBOutlet UIImageView *detailsView;
@property (weak, nonatomic) IBOutlet UIScrollView *productListView;
@property(nonatomic,retain)NSMutableArray * subViewArr;
@property(nonatomic,retain)UIView * lienView;

@property(nonatomic,retain)UIView * grayView;


- (void)setModel:(HomeModel*)model;





@end
