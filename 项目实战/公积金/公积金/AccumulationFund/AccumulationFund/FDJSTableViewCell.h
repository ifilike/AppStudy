//
//  FDJSTableViewCell.h
//  AccumulationFund
//
//  Created by mac on 15/11/18.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDJSTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;

@end
