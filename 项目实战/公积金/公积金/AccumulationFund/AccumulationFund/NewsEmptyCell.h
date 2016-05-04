//
//  NewsEmptyCell.h
//  AccumulationFund
//
//  Created by mac on 15/12/11.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsEmptyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activeIndicator;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) NSLayoutConstraint *cellHeightCons;

- (void)startLoadInformation;
@end
