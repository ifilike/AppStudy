//
//  EvaluateDetailViewController.h
//  QXD
//
//  Created by zhujie on 平成27-12-23.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EvaluateModle;

@interface EvaluateDetailViewController : UIViewController
@property(nonatomic,strong) EvaluateModle *datailModel;
@property(nonatomic,strong) NSString *orderId;
@end
