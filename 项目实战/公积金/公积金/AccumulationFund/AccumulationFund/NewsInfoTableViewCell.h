//
//  NewsInfoTableViewCell.h
//  AccumulationFund
//
//  Created by mac on 15/12/9.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

@interface NewsInfoTableViewCell : UITableViewCell


@property (strong, nonatomic) NewsModel *model;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
