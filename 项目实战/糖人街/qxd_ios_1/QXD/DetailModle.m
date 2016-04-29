//
//  DetailModle.m
//  QXD
//
//  Created by zhujie on 平成27-12-25.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "DetailModle.h"
#import "ProductModel.h"

@implementation DetailModle
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self creatModleWith:dict];
    }
    return self;
}
-(void)creatModleWith:(NSDictionary *)dic{
    self.order = [dic objectForKey:@"order"];
    self.order_id = [self.order objectForKey:@"id"];
    self.order_status = [self.order objectForKey:@"status"];
    
    self.address = [dic objectForKey:@"address"];
    self.address_name = [self.address objectForKey:@"name"];
    self.address_phone = [self.address objectForKey:@"phone"];
    self.address_detail_address = [NSString stringWithFormat:@"%@%@%@%@",[self.address objectForKey:@"province"],[self.address objectForKey:@"city"],[self.address objectForKey:@"area"],[self.address objectForKey:@"address"]];
    
    self.products = [[NSMutableArray alloc] init];
    self.PRODUCTS = [dic objectForKey:@"products"];
    for (NSDictionary *dic in self.PRODUCTS) {
        ProductModel *productModel = [[ProductModel alloc] initModleWithDic:dic];
        [self.products addObject:productModel];
    }
}

@end
