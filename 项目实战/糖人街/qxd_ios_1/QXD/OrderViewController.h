//
//  OrderViewController.h
//  QXD
//
//  Created by zhujie on 平成27-11-22.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController

@property(nonatomic,strong) NSString *urlString;

-(void)creatStatueWithString:(NSString *)string;

@end
