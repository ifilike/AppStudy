//
//  EvaluateTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成27-12-23.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EvaluateModle;

@interface EvaluateTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *iconImg;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIButton *clickBtn;

@property(nonatomic,strong) void(^DetailBlock)();
-(void)configWithEvaluatModel:(EvaluateModle *)model;
@end
