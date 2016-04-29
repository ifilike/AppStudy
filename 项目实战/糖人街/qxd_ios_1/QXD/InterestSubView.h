//
//  InterestSubView.h
//  QXD
//
//  Created by WZP on 15/11/22.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeleteLienLabel;
@class InterestProductModel;
@class TopLabel;

@interface InterestSubView : UIButton


@property(nonatomic,retain)TopLabel * goodsNameLable;
@property(nonatomic,retain)DeleteLienLabel * oldProice;
@property(nonatomic,retain)UILabel * goodsPriceLable;
@property(nonatomic,retain)NSString * productID;
@property(nonatomic,retain)NSString * imageStr;
@property(nonatomic,retain)NSData * imageData;
@property(nonatomic,retain)NSString * buyPrice;
@property(nonatomic,retain)UIImageView * imageView2;


- (void)setModel:(InterestProductModel*)model;



@end
