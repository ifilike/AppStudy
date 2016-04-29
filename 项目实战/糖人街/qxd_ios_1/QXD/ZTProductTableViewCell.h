//
//  ZTProductTableViewCell.h
//  QXD
//
//  Created by wzp on 15/12/7.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZTProductListModel;

@interface ZTProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IntroductionLabel;
@property (weak, nonatomic) IBOutlet UIButton *nowToBuyBut;

- (void)setModel:(ZTProductListModel*)model;

@end
