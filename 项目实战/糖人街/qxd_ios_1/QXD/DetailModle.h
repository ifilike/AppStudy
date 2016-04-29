//
//  DetailModle.h
//  QXD
//
//  Created by zhujie on 平成27-12-25.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModle : NSObject

//订单
@property(nonatomic,strong) NSDictionary *order;
@property(nonatomic,copy) NSString *order_status;
@property(nonatomic,copy) NSString *order_id;

//地址
@property(nonatomic,strong) NSDictionary *address;
@property(nonatomic,copy) NSString *address_name;
@property(nonatomic,copy) NSString *address_phone;
@property(nonatomic,copy) NSString *address_detail_address;

//产品
@property(nonatomic,strong) NSMutableArray *products;
@property(nonatomic,strong) NSArray *PRODUCTS;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
