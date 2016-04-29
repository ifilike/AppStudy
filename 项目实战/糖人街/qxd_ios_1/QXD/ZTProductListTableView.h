//
//  ZTProductListTableView.h
//  QXD
//
//  Created by wzp on 15/12/7.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BuyButtonProtocol <NSObject>

@required
- (void)addButtonEvent;
- (void)doOtherThingWithProductID:(NSString*)productID;
@end



@interface ZTProductListTableView : UIView<UITableViewDataSource,UITableViewDelegate>






@property(nonatomic,retain)UITableView * tableView;
@property(nonatomic,retain)NSMutableArray * listModelArr;
@property(nonatomic,assign)id<BuyButtonProtocol> delegate;



- (void)reloadDatasWithZTProductListModelArr:(NSMutableArray*)ZTProductListModelArr;


@end
