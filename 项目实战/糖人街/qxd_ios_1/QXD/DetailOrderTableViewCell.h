//
//  DetailOrderTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成27-12-25.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailOrderTableViewCell : UITableViewCell
@property(nonatomic,strong) UILabel *statueLabel;
@property(nonatomic,strong) UILabel *idLabel;

-(void)configWithModle:(NSString *)status WithID:(NSString *)ID;
@end
