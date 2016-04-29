//
//  HomeTableViewCell2.h
//  QXD
//
//  Created by wzp on 15/11/30.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeModel2;
@class ByxxrMode;


@interface HomeTableViewCell2 : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)NSMutableArray * subViewArr;




- (void)setModel:(HomeModel2*)model;

- (void)setByxxrModel:(ByxxrMode*)model withModelArr:(NSMutableArray*)modelArr;





@end
