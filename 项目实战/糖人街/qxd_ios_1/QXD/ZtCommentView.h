//
//  ZtCommentView.h
//  QXD
//
//  Created by wzp on 16/1/31.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZtCommentView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView * tableView;

@property(nonatomic,retain)NSMutableArray * commentModelArr;
@property(nonatomic,retain)NSMutableArray * cellHighArr;
@property(nonatomic,assign)float frameH;

- (instancetype)initWithFrame:(CGRect)frame withModelArr:(NSMutableArray*)modelArr;


- (void)reloadDataWithModelArr:(NSMutableArray*)commentModelArr;

//- (void)changeHeight;

@end
