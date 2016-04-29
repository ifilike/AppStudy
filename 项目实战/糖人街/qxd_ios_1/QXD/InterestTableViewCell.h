//
//  InterestTableViewCell.h
//  QXD
//
//  Created by WZP on 15/11/22.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InterestProductModel;
@class ProductListModel;





@interface InterestTableViewCell : UITableViewCell


@property(nonatomic,retain)NSMutableArray *subButttonArr;




- (void)setModel1:(InterestProductModel*)model1 model2:(InterestProductModel*)model2;

//- (void)setLittleTypeModel1:(ProductListModel*)model1 model2:(ProductListModel*)model2;

@end
