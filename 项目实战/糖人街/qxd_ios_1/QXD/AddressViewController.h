//
//  AddressViewController.h
//  QXD
//
//  Created by zhujie on 平成27-11-22.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressModel;

@interface AddressViewController : UIViewController
@property(nonatomic,strong) void(^updataSucceed)(NSString *string);

//购物车
@property(assign,nonatomic) BOOL is_shopping;
@property(nonatomic,strong) void(^getAddressBlock)(AddressModel *address);
@end
