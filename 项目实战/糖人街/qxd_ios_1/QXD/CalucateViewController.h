//
//  CalucateViewController.h
//  QXD
//
//  Created by zhujie on 平成27-12-07.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalucateViewController : UIViewController

@property(nonatomic,strong) NSArray *array1;
@property(nonatomic,assign) float totalMoney;//总钱数

@property(nonatomic,strong) NSString *FriendModle_Customer_Id;
@property(nonatomic,strong) NSString *FriendModle_Product_Name;
@property(nonatomic,strong) NSMutableString *shopCarId;

@property(nonatomic,assign) BOOL isBuy;//立即购买传过来的

@end

