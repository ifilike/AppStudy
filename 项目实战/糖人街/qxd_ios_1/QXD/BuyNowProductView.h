//
//  BuyNowProductView.h
//  QXD
//
//  Created by wzp on 16/1/19.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZTProductListModel;

@interface BuyNowProductView : UIView



@property(nonatomic,retain)UIImageView * imageView2;
@property(nonatomic,retain)UILabel * nameLabel;
@property(nonatomic,retain)UILabel * detailsLabel;


@property(nonatomic,retain)UIButton * buyBut;
@property(nonatomic,retain)NSString * productID;



- (void)setZTProductListModel:(ZTProductListModel*)model tag:(NSInteger)tag;


@end
