//
//  HomeTableViewCell3.h
//  QXD
//
//  Created by wzp on 15/12/23.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DefaultModel;
@class ProductListModel;
@class FoundImageButton;


@interface HomeTableViewCell3 : UITableViewCell<UIScrollViewDelegate>

@property(nonatomic,retain)FoundImageButton * imageBut;
@property(nonatomic,retain)UIScrollView * scrollView;
@property(nonatomic,retain)UIButton * allGoodsBut;
@property(nonatomic,retain)NSMutableArray * subViewArr;


- (void)setModel:(DefaultModel *)model;

- (void)ssss;


@end
