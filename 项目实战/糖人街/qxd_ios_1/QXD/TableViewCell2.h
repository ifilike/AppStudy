//
//  TableViewCell2.h
//  QXD
//
//  Created by WZP on 15/11/17.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DefaultModel;
@class ProductListModel;
@class FoundImageButton;

@interface TableViewCell2 : UITableViewCell<UIScrollViewDelegate>

@property(nonatomic,retain)FoundImageButton * imageBut;
@property(nonatomic,retain)UIScrollView * scrollView;
@property(nonatomic,retain)UIButton * allGoodsBut;
@property(nonatomic,retain)NSMutableArray * subViewArr;


- (void)setModel:(DefaultModel *)model;

@end
