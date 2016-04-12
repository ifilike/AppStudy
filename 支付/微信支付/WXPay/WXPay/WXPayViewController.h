//
//  WXPayViewController.h
//  WXPay
//
//  Created by babbage on 16/4/11.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface WXPayViewController : UIViewController

- (void)WXPayWithBody:(NSString *)title totalMoney:(NSString *)price orderId:(NSString *)orderId;

@end

@interface WXPayViewController ()<WXApiDelegate>

-(void)WXPaySucceed;

@end