//
//  OrderModel.h
//  QXD
//
//  Created by zhujie on 平成27-11-22.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject


//@property(nonatomic,copy) NSString *timeLabel;
//@property(nonatomic,copy) NSString *payStatueLabel;
//@property(nonatomic,copy) NSString *totalCountLabel;
//@property(nonatomic,copy) NSString *moneyCountLabel;
//@property(nonatomic,copy) NSString *payDetailButton;//订单跟踪
//@property(nonatomic,copy) NSString *payButton;//支付
//
//@property(nonatomic,strong) NSMutableArray *dataArry;


@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *customer_id;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,strong) NSMutableArray *products;
@property(nonatomic,copy) NSString *customer_name;
@property(nonatomic,copy) NSString *total_money;
@property(nonatomic,copy) NSString *pay_type;
@property(nonatomic,copy) NSString *express_id;


@property(nonatomic,strong) NSMutableArray *PRODUCTS;


-(id)initWithDictionary:(NSDictionary *)dict;

@end
