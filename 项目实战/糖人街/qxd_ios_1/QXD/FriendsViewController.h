//
//  FriendsViewController.h
//  QXD
//
//  Created by ZhangRui on 15/11/9.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "ZJBaseController.h"

@interface FriendsViewController : ZJBaseController
@property(nonatomic,strong) void(^editingSelected)(NSString *str);
@property(nonatomic,strong) void(^editingUnSelected)(NSString *str);

//@property(nonatomic,strong) NSString *FriendModle_Customer_Id;
//@property(nonatomic,strong) NSString *FriendModle_Product_Name;
//@property(nonatomic,strong) NSMutableString *shopCarId;
//@property(nonatomic,assign) NSInteger numberOfShopping;
-(void)creatDataSourceAgien;
@end
