//
//  InterestListView.h
//  QXD
//
//  Created by WZP on 15/11/22.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InterestProductModel;


@protocol InterestViewProtocol <NSObject>

- (void)toDoSomethingWith:(NSString*)productID;

@end


@interface InterestListView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UILabel * headView;
@property(nonatomic,retain)UILabel * footView;
@property(nonatomic,retain)UITableView * listTableView;
@property(nonatomic,retain)NSArray * productModelArr;
@property(nonatomic,assign)id <InterestViewProtocol> delegate;



- (void)noHeader;
- (void)noFoot;
- (void)reloadDataWithInterestModelArr:(NSMutableArray*)interestModelArr;

@end
