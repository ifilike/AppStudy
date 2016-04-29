//
//  SubGoodsView.h
//  QXD
//
//  Created by WZP on 15/11/16.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ByxxrMode;
@class DeleteLienLabel;
@class ProductListModel;
@class TopLabel;

@protocol SubGoodsViewDelegate <NSObject>

- (void)addMethodToImageButton;

@end



@interface SubGoodsView : UIView

@property(nonatomic,retain)UIButton * imageButton;
@property(nonatomic,retain)TopLabel * goodsNameLable;
@property(nonatomic,retain)DeleteLienLabel * oldProice;
@property(nonatomic,retain)UILabel * goodsPriceLable;
@property(nonatomic,retain)NSString * productID;
@property(nonatomic,retain)NSString * imageStr;
@property(nonatomic,retain)NSData * imageData;
@property(nonatomic,retain)NSString * buyPrice;
@property(nonatomic,retain)UIButton * discountBut;


- (instancetype)initWithFrame:(CGRect)frame withModel:(ByxxrMode*)model;

//- (void)setModel:(ByxxrMode*)model;


@end
