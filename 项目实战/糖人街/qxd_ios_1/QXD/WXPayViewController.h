//
//  WXPayViewController.h
//  QXD
//
//  Created by zhujie on 平成28-02-17.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXPayViewController : UIViewController

@property(nonatomic,strong) NSString *order_id;
@property(nonatomic,strong) NSString *price;
@property(nonatomic,strong) void(^blockk)();

- (void)weixinChooseAct;

@end
