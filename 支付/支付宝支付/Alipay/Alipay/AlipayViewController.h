//
//  AlipayViewController.h
//  Alipay
//
//  Created by babbage on 16/4/11.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import <UIKit/UIKit.h>
//
//测试商品信息封装在Product中,外部商户可以根据自己商品实际情况定义
//
@interface Product : NSObject{
@private
    float     _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;

-(instancetype)initWithTitle:(NSString *)subject Detail:(NSString *)body price:(CGFloat)price orderId:(NSString *)orderId;

@end


@interface AlipayViewController : UIViewController

-(void)payForProduct:(Product *)product;

@end
