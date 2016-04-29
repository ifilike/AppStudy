//
//  BuyNowTableViewCell.h
//  QXD
//
//  Created by wzp on 16/1/19.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BuyNowProductView;
@class ZTProductListModel;

@interface BuyNowTableViewCell : UITableViewCell


@property(nonatomic,retain)BuyNowProductView * buyNowView;



- (void)setZTProductListModel:(ZTProductListModel*)model tag:(NSInteger)tag;



@end
