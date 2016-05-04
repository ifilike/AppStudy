//
//  YDSearchViewController.h
//  AccumulationFund
//
//  Created by babbage on 15/12/18.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YDSearchViewController;
@protocol DataSearchDelegate <NSObject>

- (void)dataSearch:(YDSearchViewController *)controller
didSelectWithObject:(NSDictionary *)aObject;


@end

@interface YDSearchViewController : UIViewController
@property(nonatomic,strong)NSArray *searchDataArr;
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,weak)id<DataSearchDelegate> delegate;

@end
