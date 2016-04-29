//
//  MemberPriceTableViewCell.h
//  QXD
//
//  Created by wzp on 15/12/1.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MemberModel;

@interface MemberPriceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *openBut;
@property (weak, nonatomic) IBOutlet UIView *deleteLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *discountLab;






- (void)setModel:(MemberModel*)model;

@end
