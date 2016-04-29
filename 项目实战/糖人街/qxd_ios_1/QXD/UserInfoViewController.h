//
//  UserInfoViewController.h
//  QXD
//
//  Created by zhujie on 平成27-11-12.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "ZJBaseController.h"

@interface UserInfoViewController : ZJBaseController


@property(nonatomic,strong) NSString *VC;

@property(nonatomic,strong) void(^blockWithUser)();
@property(nonatomic,strong) void(^blockWithShopCart)();

@end
